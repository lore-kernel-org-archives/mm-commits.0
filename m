From: akpm@linux-foundation.org
Subject: [merged] gcov-add-gcov-profiling-infrastructure.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:07 -0700
Message-ID: <200906182248.n5IMm7KM007163@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333AbZFRWtl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oberpar@linux.vnet.ibm.com, W.Li@Sun.COM, andi@firstfloor.org, heicars2@linux.vnet.ibm.com, jdike@addtoit.com, michaele@au1.ibm.com, mingo@elte.hu, mschwid2@linux.vnet.ibm.com, rusty@


The patch titled
     gcov: add gcov profiling infrastructure
has been removed from the -mm tree.  Its filename was
     gcov-add-gcov-profiling-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gcov: add gcov profiling infrastructure
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Enable the use of GCC's coverage testing tool gcov [1] with the Linux
kernel.  gcov may be useful for:

 * debugging (has this code been reached at all?)
 * test improvement (how do I change my test to cover these lines?)
 * minimizing kernel configurations (do I need this option if the
   associated code is never run?)

The profiling patch incorporates the following changes:

 * change kbuild to include profiling flags
 * provide functions needed by profiling code
 * present profiling data as files in debugfs

Note that on some architectures, enabling gcc's profiling option
"-fprofile-arcs" for the entire kernel may trigger compile/link/
run-time problems, some of which are caused by toolchain bugs and
others which require adjustment of architecture code.

For this reason profiling the entire kernel is initially restricted
to those architectures for which it is known to work without changes.
This restriction can be lifted once an architecture has been tested
and found compatible with gcc's profiling. Profiling of single files
or directories is still available on all platforms (see config help
text).

[1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Li Wei <W.Li@Sun.COM>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heicars2@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gcov.txt              |  246 +++++++++
 Documentation/kernel-parameters.txt |    7 
 Makefile                            |   11 
 arch/Kconfig                        |    2 
 include/linux/compiler-gcc3.h       |    6 
 kernel/Makefile                     |    1 
 kernel/gcov/Kconfig                 |   48 +
 kernel/gcov/Makefile                |    3 
 kernel/gcov/base.c                  |  148 +++++
 kernel/gcov/fs.c                    |  673 ++++++++++++++++++++++++++
 kernel/gcov/gcc_3_4.c               |  447 +++++++++++++++++
 kernel/gcov/gcov.h                  |  128 ++++
 scripts/Makefile.lib                |   11 
 13 files changed, 1726 insertions(+), 5 deletions(-)

diff -puN /dev/null Documentation/gcov.txt
--- /dev/null
+++ a/Documentation/gcov.txt
@@ -0,0 +1,246 @@
+Using gcov with the Linux kernel
+================================
+
+1. Introduction
+2. Preparation
+3. Customization
+4. Files
+5. Modules
+6. Separated build and test machines
+7. Troubleshooting
+Appendix A: sample script: gather_on_build.sh
+Appendix B: sample script: gather_on_test.sh
+
+
+1. Introduction
+===============
+
+gcov profiling kernel support enables the use of GCC's coverage testing
+tool gcov [1] with the Linux kernel. Coverage data of a running kernel
+is exported in gcov-compatible format via the "gcov" debugfs directory.
+To get coverage data for a specific file, change to the kernel build
+directory and use gcov with the -o option as follows (requires root):
+
+# cd /tmp/linux-out
+# gcov -o /sys/kernel/debug/gcov/tmp/linux-out/kernel spinlock.c
+
+This will create source code files annotated with execution counts
+in the current directory. In addition, graphical gcov front-ends such
+as lcov [2] can be used to automate the process of collecting data
+for the entire kernel and provide coverage overviews in HTML format.
+
+Possible uses:
+
+* debugging (has this line been reached at all?)
+* test improvement (how do I change my test to cover these lines?)
+* minimizing kernel configurations (do I need this option if the
+  associated code is never run?)
+
+--
+
+[1] http://gcc.gnu.org/onlinedocs/gcc/Gcov.html
+[2] http://ltp.sourceforge.net/coverage/lcov.php
+
+
+2. Preparation
+==============
+
+Configure the kernel with:
+
+        CONFIG_DEBUGFS=y
+        CONFIG_GCOV_KERNEL=y
+
+and to get coverage data for the entire kernel:
+
+        CONFIG_GCOV_PROFILE_ALL=y
+
+Note that kernels compiled with profiling flags will be significantly
+larger and run slower. Also CONFIG_GCOV_PROFILE_ALL may not be supported
+on all architectures.
+
+Profiling data will only become accessible once debugfs has been
+mounted:
+
+        mount -t debugfs none /sys/kernel/debug
+
+
+3. Customization
+================
+
+To enable profiling for specific files or directories, add a line
+similar to the following to the respective kernel Makefile:
+
+        For a single file (e.g. main.o):
+                GCOV_PROFILE_main.o := y
+
+        For all files in one directory:
+                GCOV_PROFILE := y
+
+To exclude files from being profiled even when CONFIG_GCOV_PROFILE_ALL
+is specified, use:
+
+                GCOV_PROFILE_main.o := n
+        and:
+                GCOV_PROFILE := n
+
+Only files which are linked to the main kernel image or are compiled as
+kernel modules are supported by this mechanism.
+
+
+4. Files
+========
+
+The gcov kernel support creates the following files in debugfs:
+
+        /sys/kernel/debug/gcov
+                Parent directory for all gcov-related files.
+
+        /sys/kernel/debug/gcov/reset
+                Global reset file: resets all coverage data to zero when
+                written to.
+
+        /sys/kernel/debug/gcov/path/to/compile/dir/file.gcda
+                The actual gcov data file as understood by the gcov
+                tool. Resets file coverage data to zero when written to.
+
+        /sys/kernel/debug/gcov/path/to/compile/dir/file.gcno
+                Symbolic link to a static data file required by the gcov
+                tool. This file is generated by gcc when compiling with
+                option -ftest-coverage.
+
+
+5. Modules
+==========
+
+Kernel modules may contain cleanup code which is only run during
+module unload time. The gcov mechanism provides a means to collect
+coverage data for such code by keeping a copy of the data associated
+with the unloaded module. This data remains available through debugfs.
+Once the module is loaded again, the associated coverage counters are
+initialized with the data from its previous instantiation.
+
+This behavior can be deactivated by specifying the gcov_persist kernel
+parameter:
+
+        gcov_persist=0
+
+At run-time, a user can also choose to discard data for an unloaded
+module by writing to its data file or the global reset file.
+
+
+6. Separated build and test machines
+====================================
+
+The gcov kernel profiling infrastructure is designed to work out-of-the
+box for setups where kernels are built and run on the same machine. In
+cases where the kernel runs on a separate machine, special preparations
+must be made, depending on where the gcov tool is used:
+
+a) gcov is run on the TEST machine
+
+The gcov tool version on the test machine must be compatible with the
+gcc version used for kernel build. Also the following files need to be
+copied from build to test machine:
+
+from the source tree:
+  - all C source files + headers
+
+from the build tree:
+  - all C source files + headers
+  - all .gcda and .gcno files
+  - all links to directories
+
+It is important to note that these files need to be placed into the
+exact same file system location on the test machine as on the build
+machine. If any of the path components is symbolic link, the actual
+directory needs to be used instead (due to make's CURDIR handling).
+
+b) gcov is run on the BUILD machine
+
+The following files need to be copied after each test case from test
+to build machine:
+
+from the gcov directory in sysfs:
+  - all .gcda files
+  - all links to .gcno files
+
+These files can be copied to any location on the build machine. gcov
+must then be called with the -o option pointing to that directory.
+
+Example directory setup on the build machine:
+
+  /tmp/linux:    kernel source tree
+  /tmp/out:      kernel build directory as specified by make O=
+  /tmp/coverage: location of the files copied from the test machine
+
+  [user@build] cd /tmp/out
+  [user@build] gcov -o /tmp/coverage/tmp/out/init main.c
+
+
+7. Troubleshooting
+==================
+
+Problem:  Compilation aborts during linker step.
+Cause:    Profiling flags are specified for source files which are not
+          linked to the main kernel or which are linked by a custom
+          linker procedure.
+Solution: Exclude affected source files from profiling by specifying
+          GCOV_PROFILE := n or GCOV_PROFILE_basename.o := n in the
+          corresponding Makefile.
+
+
+Appendix A: gather_on_build.sh
+==============================
+
+Sample script to gather coverage meta files on the build machine
+(see 6a):
+
+#!/bin/bash
+
+KSRC=$1
+KOBJ=$2
+DEST=$3
+
+if [ -z "$KSRC" ] || [ -z "$KOBJ" ] || [ -z "$DEST" ]; then
+  echo "Usage: $0 <ksrc directory> <kobj directory> <output.tar.gz>" >&2
+  exit 1
+fi
+
+KSRC=$(cd $KSRC; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+KOBJ=$(cd $KOBJ; printf "all:\n\t@echo \${CURDIR}\n" | make -f -)
+
+find $KSRC $KOBJ \( -name '*.gcno' -o -name '*.[ch]' -o -type l \) -a \
+                 -perm /u+r,g+r | tar cfz $DEST -P -T -
+
+if [ $? -eq 0 ] ; then
+  echo "$DEST successfully created, copy to test system and unpack with:"
+  echo "  tar xfz $DEST -P"
+else
+  echo "Could not create file $DEST"
+fi
+
+
+Appendix B: gather_on_test.sh
+=============================
+
+Sample script to gather coverage data files on the test machine
+(see 6b):
+
+#!/bin/bash
+
+DEST=$1
+GCDA=/sys/kernel/debug/gcov
+
+if [ -z "$DEST" ] ; then
+  echo "Usage: $0 <output.tar.gz>" >&2
+  exit 1
+fi
+
+find $GCDA -name '*.gcno' -o -name '*.gcda' | tar cfz $DEST -T -
+
+if [ $? -eq 0 ] ; then
+  echo "$DEST successfully created, copy to build system and unpack with:"
+  echo "  tar xfz $DEST"
+else
+  echo "Could not create file $DEST"
+fi
diff -puN Documentation/kernel-parameters.txt~gcov-add-gcov-profiling-infrastructure Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~gcov-add-gcov-profiling-infrastructure
+++ a/Documentation/kernel-parameters.txt
@@ -48,6 +48,7 @@ parameter is applicable:
 	EFI	EFI Partitioning (GPT) is enabled
 	EIDE	EIDE/ATAPI support is enabled.
 	FB	The frame buffer device is enabled.
+	GCOV	GCOV profiling is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
 	IMA     Integrity measurement architecture is enabled.
@@ -796,6 +797,12 @@ and is between 256 and 4096 characters. 
 			Format: off | on
 			default: on
 
+	gcov_persist=	[GCOV] When non-zero (default), profiling data for
+			kernel modules is saved and remains accessible via
+			debugfs, even when the module is unloaded/reloaded.
+			When zero, profiling data is discarded and associated
+			debugfs files are removed at module unload time.
+
 	gdth=		[HW,SCSI]
 			See header of drivers/scsi/gdth.c.
 
diff -puN Makefile~gcov-add-gcov-profiling-infrastructure Makefile
--- a/Makefile~gcov-add-gcov-profiling-infrastructure
+++ a/Makefile
@@ -330,6 +330,7 @@ AFLAGS_MODULE   = $(MODFLAGS)
 LDFLAGS_MODULE  =
 CFLAGS_KERNEL	=
 AFLAGS_KERNEL	=
+CFLAGS_GCOV	= -fprofile-arcs -ftest-coverage
 
 
 # Use LINUXINCLUDE when you must reference the include/ directory.
@@ -356,7 +357,7 @@ export CPP AR NM STRIP OBJCOPY OBJDUMP M
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
-export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
+export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
@@ -1216,8 +1217,8 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \) \
-		-type f -print | xargs rm -f
+		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \
+		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
 #
@@ -1421,8 +1422,8 @@ clean: $(clean-dirs)
 	$(call cmd,rmfiles)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
-		-type f -print | xargs rm -f
+		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
+		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
 help:
 	@echo  '  Building external modules.'
diff -puN arch/Kconfig~gcov-add-gcov-profiling-infrastructure arch/Kconfig
--- a/arch/Kconfig~gcov-add-gcov-profiling-infrastructure
+++ a/arch/Kconfig
@@ -112,3 +112,5 @@ config HAVE_DMA_API_DEBUG
 
 config HAVE_DEFAULT_NO_SPIN_MUTEXES
 	bool
+
+source "kernel/gcov/Kconfig"
diff -puN include/linux/compiler-gcc3.h~gcov-add-gcov-profiling-infrastructure include/linux/compiler-gcc3.h
--- a/include/linux/compiler-gcc3.h~gcov-add-gcov-profiling-infrastructure
+++ a/include/linux/compiler-gcc3.h
@@ -16,6 +16,12 @@
 #define __must_check		__attribute__((warn_unused_result))
 #endif
 
+#ifdef CONFIG_GCOV_KERNEL
+# if __GNUC_MINOR__ < 4
+#   error "GCOV profiling support for gcc versions below 3.4 not included"
+# endif /* __GNUC_MINOR__ */
+#endif /* CONFIG_GCOV_KERNEL */
+
 /*
  * A trick to suppress uninitialized variable warning without generating any
  * code
diff -puN kernel/Makefile~gcov-add-gcov-profiling-infrastructure kernel/Makefile
--- a/kernel/Makefile~gcov-add-gcov-profiling-infrastructure
+++ a/kernel/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_STOP_MACHINE) += stop_machi
 obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
 obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
+obj-$(CONFIG_GCOV_KERNEL) += gcov/
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_KGDB) += kgdb.o
diff -puN /dev/null kernel/gcov/Kconfig
--- /dev/null
+++ a/kernel/gcov/Kconfig
@@ -0,0 +1,48 @@
+menu "GCOV-based kernel profiling"
+
+config GCOV_KERNEL
+	bool "Enable gcov-based kernel profiling"
+	depends on DEBUG_FS && CONSTRUCTORS
+	default n
+	---help---
+	This option enables gcov-based code profiling (e.g. for code coverage
+	measurements).
+
+	If unsure, say N.
+
+	Additionally specify CONFIG_GCOV_PROFILE_ALL=y to get profiling data
+	for the entire kernel. To enable profiling for specific files or
+	directories, add a line similar to the following to the respective
+	Makefile:
+
+	For a single file (e.g. main.o):
+	        GCOV_PROFILE_main.o := y
+
+	For all files in one directory:
+	        GCOV_PROFILE := y
+
+	To exclude files from being profiled even when CONFIG_GCOV_PROFILE_ALL
+	is specified, use:
+
+	        GCOV_PROFILE_main.o := n
+	and:
+	        GCOV_PROFILE := n
+
+	Note that the debugfs filesystem has to be mounted to access
+	profiling data.
+
+config GCOV_PROFILE_ALL
+	bool "Profile entire Kernel"
+	depends on GCOV_KERNEL
+	depends on S390 || X86_32
+	default n
+	---help---
+	This options activates profiling for the entire kernel.
+
+	If unsure, say N.
+
+	Note that a kernel compiled with profiling flags will be significantly
+	larger and run slower. Also be sure to exclude files from profiling
+	which are not linked to the kernel image to prevent linker errors.
+
+endmenu
diff -puN /dev/null kernel/gcov/Makefile
--- /dev/null
+++ a/kernel/gcov/Makefile
@@ -0,0 +1,3 @@
+EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+
+obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
diff -puN /dev/null kernel/gcov/base.c
--- /dev/null
+++ a/kernel/gcov/base.c
@@ -0,0 +1,148 @@
+/*
+ *  This code maintains a list of active profiling data structures.
+ *
+ *    Copyright IBM Corp. 2009
+ *    Author(s): Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ *    Based on the gcov-kernel patch by:
+ *		 Hubertus Franke <frankeh@us.ibm.com>
+ *		 Nigel Hinds <nhinds@us.ibm.com>
+ *		 Rajan Ravindran <rajancr@us.ibm.com>
+ *		 Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *		 Paul Larson
+ */
+
+#define pr_fmt(fmt)	"gcov: " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include "gcov.h"
+
+static struct gcov_info *gcov_info_head;
+static int gcov_events_enabled;
+static DEFINE_MUTEX(gcov_lock);
+
+/*
+ * __gcov_init is called by gcc-generated constructor code for each object
+ * file compiled with -fprofile-arcs.
+ */
+void __gcov_init(struct gcov_info *info)
+{
+	static unsigned int gcov_version;
+
+	mutex_lock(&gcov_lock);
+	if (gcov_version == 0) {
+		gcov_version = info->version;
+		/*
+		 * Printing gcc's version magic may prove useful for debugging
+		 * incompatibility reports.
+		 */
+		pr_info("version magic: 0x%x\n", gcov_version);
+	}
+	/*
+	 * Add new profiling data structure to list and inform event
+	 * listener.
+	 */
+	info->next = gcov_info_head;
+	gcov_info_head = info;
+	if (gcov_events_enabled)
+		gcov_event(GCOV_ADD, info);
+	mutex_unlock(&gcov_lock);
+}
+EXPORT_SYMBOL(__gcov_init);
+
+/*
+ * These functions may be referenced by gcc-generated profiling code but serve
+ * no function for kernel profiling.
+ */
+void __gcov_flush(void)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_flush);
+
+void __gcov_merge_add(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_add);
+
+void __gcov_merge_single(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_single);
+
+void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters)
+{
+	/* Unused. */
+}
+EXPORT_SYMBOL(__gcov_merge_delta);
+
+/**
+ * gcov_enable_events - enable event reporting through gcov_event()
+ *
+ * Turn on reporting of profiling data load/unload-events through the
+ * gcov_event() callback. Also replay all previous events once. This function
+ * is needed because some events are potentially generated too early for the
+ * callback implementation to handle them initially.
+ */
+void gcov_enable_events(void)
+{
+	struct gcov_info *info;
+
+	mutex_lock(&gcov_lock);
+	gcov_events_enabled = 1;
+	/* Perform event callback for previously registered entries. */
+	for (info = gcov_info_head; info; info = info->next)
+		gcov_event(GCOV_ADD, info);
+	mutex_unlock(&gcov_lock);
+}
+
+#ifdef CONFIG_MODULES
+static inline int within(void *addr, void *start, unsigned long size)
+{
+	return ((addr >= start) && (addr < start + size));
+}
+
+/* Update list and generate events when modules are unloaded. */
+static int gcov_module_notifier(struct notifier_block *nb, unsigned long event,
+				void *data)
+{
+	struct module *mod = data;
+	struct gcov_info *info;
+	struct gcov_info *prev;
+
+	if (event != MODULE_STATE_GOING)
+		return NOTIFY_OK;
+	mutex_lock(&gcov_lock);
+	prev = NULL;
+	/* Remove entries located in module from linked list. */
+	for (info = gcov_info_head; info; info = info->next) {
+		if (within(info, mod->module_core, mod->core_size)) {
+			if (prev)
+				prev->next = info->next;
+			else
+				gcov_info_head = info->next;
+			if (gcov_events_enabled)
+				gcov_event(GCOV_REMOVE, info);
+		} else
+			prev = info;
+	}
+	mutex_unlock(&gcov_lock);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gcov_nb = {
+	.notifier_call	= gcov_module_notifier,
+};
+
+static int __init gcov_init(void)
+{
+	return register_module_notifier(&gcov_nb);
+}
+device_initcall(gcov_init);
+#endif /* CONFIG_MODULES */
diff -puN /dev/null kernel/gcov/fs.c
--- /dev/null
+++ a/kernel/gcov/fs.c
@@ -0,0 +1,673 @@
+/*
+ *  This code exports profiling data as debugfs files to userspace.
+ *
+ *    Copyright IBM Corp. 2009
+ *    Author(s): Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ *    Based on the gcov-kernel patch by:
+ *		 Hubertus Franke <frankeh@us.ibm.com>
+ *		 Nigel Hinds <nhinds@us.ibm.com>
+ *		 Rajan Ravindran <rajancr@us.ibm.com>
+ *		 Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *		 Paul Larson
+ *		 Yi CDL Yang
+ */
+
+#define pr_fmt(fmt)	"gcov: " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/seq_file.h>
+#include "gcov.h"
+
+/**
+ * struct gcov_node - represents a debugfs entry
+ * @list: list head for child node list
+ * @children: child nodes
+ * @all: list head for list of all nodes
+ * @parent: parent node
+ * @info: associated profiling data structure if not a directory
+ * @ghost: when an object file containing profiling data is unloaded we keep a
+ *         copy of the profiling data here to allow collecting coverage data
+ *         for cleanup code. Such a node is called a "ghost".
+ * @dentry: main debugfs entry, either a directory or data file
+ * @links: associated symbolic links
+ * @name: data file basename
+ *
+ * struct gcov_node represents an entity within the gcov/ subdirectory
+ * of debugfs. There are directory and data file nodes. The latter represent
+ * the actual synthesized data file plus any associated symbolic links which
+ * are needed by the gcov tool to work correctly.
+ */
+struct gcov_node {
+	struct list_head list;
+	struct list_head children;
+	struct list_head all;
+	struct gcov_node *parent;
+	struct gcov_info *info;
+	struct gcov_info *ghost;
+	struct dentry *dentry;
+	struct dentry **links;
+	char name[0];
+};
+
+static const char objtree[] = OBJTREE;
+static const char srctree[] = SRCTREE;
+static struct gcov_node root_node;
+static struct dentry *reset_dentry;
+static LIST_HEAD(all_head);
+static DEFINE_MUTEX(node_lock);
+
+/* If non-zero, keep copies of profiling data for unloaded modules. */
+static int gcov_persist = 1;
+
+static int __init gcov_persist_setup(char *str)
+{
+	unsigned long val;
+
+	if (strict_strtoul(str, 0, &val)) {
+		pr_warning("invalid gcov_persist parameter '%s'\n", str);
+		return 0;
+	}
+	gcov_persist = val;
+	pr_info("setting gcov_persist to %d\n", gcov_persist);
+
+	return 1;
+}
+__setup("gcov_persist=", gcov_persist_setup);
+
+/*
+ * seq_file.start() implementation for gcov data files. Note that the
+ * gcov_iterator interface is designed to be more restrictive than seq_file
+ * (no start from arbitrary position, etc.), to simplify the iterator
+ * implementation.
+ */
+static void *gcov_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	loff_t i;
+
+	gcov_iter_start(seq->private);
+	for (i = 0; i < *pos; i++) {
+		if (gcov_iter_next(seq->private))
+			return NULL;
+	}
+	return seq->private;
+}
+
+/* seq_file.next() implementation for gcov data files. */
+static void *gcov_seq_next(struct seq_file *seq, void *data, loff_t *pos)
+{
+	struct gcov_iterator *iter = data;
+
+	if (gcov_iter_next(iter))
+		return NULL;
+	(*pos)++;
+
+	return iter;
+}
+
+/* seq_file.show() implementation for gcov data files. */
+static int gcov_seq_show(struct seq_file *seq, void *data)
+{
+	struct gcov_iterator *iter = data;
+
+	if (gcov_iter_write(iter, seq))
+		return -EINVAL;
+	return 0;
+}
+
+static void gcov_seq_stop(struct seq_file *seq, void *data)
+{
+	/* Unused. */
+}
+
+static const struct seq_operations gcov_seq_ops = {
+	.start	= gcov_seq_start,
+	.next	= gcov_seq_next,
+	.show	= gcov_seq_show,
+	.stop	= gcov_seq_stop,
+};
+
+/*
+ * Return the profiling data set for a given node. This can either be the
+ * original profiling data structure or a duplicate (also called "ghost")
+ * in case the associated object file has been unloaded.
+ */
+static struct gcov_info *get_node_info(struct gcov_node *node)
+{
+	if (node->info)
+		return node->info;
+
+	return node->ghost;
+}
+
+/*
+ * open() implementation for gcov data files. Create a copy of the profiling
+ * data set and initialize the iterator and seq_file interface.
+ */
+static int gcov_seq_open(struct inode *inode, struct file *file)
+{
+	struct gcov_node *node = inode->i_private;
+	struct gcov_iterator *iter;
+	struct seq_file *seq;
+	struct gcov_info *info;
+	int rc = -ENOMEM;
+
+	mutex_lock(&node_lock);
+	/*
+	 * Read from a profiling data copy to minimize reference tracking
+	 * complexity and concurrent access.
+	 */
+	info = gcov_info_dup(get_node_info(node));
+	if (!info)
+		goto out_unlock;
+	iter = gcov_iter_new(info);
+	if (!iter)
+		goto err_free_info;
+	rc = seq_open(file, &gcov_seq_ops);
+	if (rc)
+		goto err_free_iter_info;
+	seq = file->private_data;
+	seq->private = iter;
+out_unlock:
+	mutex_unlock(&node_lock);
+	return rc;
+
+err_free_iter_info:
+	gcov_iter_free(iter);
+err_free_info:
+	gcov_info_free(info);
+	goto out_unlock;
+}
+
+/*
+ * release() implementation for gcov data files. Release resources allocated
+ * by open().
+ */
+static int gcov_seq_release(struct inode *inode, struct file *file)
+{
+	struct gcov_iterator *iter;
+	struct gcov_info *info;
+	struct seq_file *seq;
+
+	seq = file->private_data;
+	iter = seq->private;
+	info = gcov_iter_get_info(iter);
+	gcov_iter_free(iter);
+	gcov_info_free(info);
+	seq_release(inode, file);
+
+	return 0;
+}
+
+/*
+ * Find a node by the associated data file name. Needs to be called with
+ * node_lock held.
+ */
+static struct gcov_node *get_node_by_name(const char *name)
+{
+	struct gcov_node *node;
+	struct gcov_info *info;
+
+	list_for_each_entry(node, &all_head, all) {
+		info = get_node_info(node);
+		if (info && (strcmp(info->filename, name) == 0))
+			return node;
+	}
+
+	return NULL;
+}
+
+static void remove_node(struct gcov_node *node);
+
+/*
+ * write() implementation for gcov data files. Reset profiling data for the
+ * associated file. If the object file has been unloaded (i.e. this is
+ * a "ghost" node), remove the debug fs node as well.
+ */
+static ssize_t gcov_seq_write(struct file *file, const char __user *addr,
+			      size_t len, loff_t *pos)
+{
+	struct seq_file *seq;
+	struct gcov_info *info;
+	struct gcov_node *node;
+
+	seq = file->private_data;
+	info = gcov_iter_get_info(seq->private);
+	mutex_lock(&node_lock);
+	node = get_node_by_name(info->filename);
+	if (node) {
+		/* Reset counts or remove node for unloaded modules. */
+		if (node->ghost)
+			remove_node(node);
+		else
+			gcov_info_reset(node->info);
+	}
+	/* Reset counts for open file. */
+	gcov_info_reset(info);
+	mutex_unlock(&node_lock);
+
+	return len;
+}
+
+/*
+ * Given a string <path> representing a file path of format:
+ *   path/to/file.gcda
+ * construct and return a new string:
+ *   <dir/>path/to/file.<ext>
+ */
+static char *link_target(const char *dir, const char *path, const char *ext)
+{
+	char *target;
+	char *old_ext;
+	char *copy;
+
+	copy = kstrdup(path, GFP_KERNEL);
+	if (!copy)
+		return NULL;
+	old_ext = strrchr(copy, '.');
+	if (old_ext)
+		*old_ext = '\0';
+	if (dir)
+		target = kasprintf(GFP_KERNEL, "%s/%s.%s", dir, copy, ext);
+	else
+		target = kasprintf(GFP_KERNEL, "%s.%s", copy, ext);
+	kfree(copy);
+
+	return target;
+}
+
+/*
+ * Construct a string representing the symbolic link target for the given
+ * gcov data file name and link type. Depending on the link type and the
+ * location of the data file, the link target can either point to a
+ * subdirectory of srctree, objtree or in an external location.
+ */
+static char *get_link_target(const char *filename, const struct gcov_link *ext)
+{
+	const char *rel;
+	char *result;
+
+	if (strncmp(filename, objtree, strlen(objtree)) == 0) {
+		rel = filename + strlen(objtree) + 1;
+		if (ext->dir == SRC_TREE)
+			result = link_target(srctree, rel, ext->ext);
+		else
+			result = link_target(objtree, rel, ext->ext);
+	} else {
+		/* External compilation. */
+		result = link_target(NULL, filename, ext->ext);
+	}
+
+	return result;
+}
+
+#define SKEW_PREFIX	".tmp_"
+
+/*
+ * For a filename .tmp_filename.ext return filename.ext. Needed to compensate
+ * for filename skewing caused by the mod-versioning mechanism.
+ */
+static const char *deskew(const char *basename)
+{
+	if (strncmp(basename, SKEW_PREFIX, sizeof(SKEW_PREFIX) - 1) == 0)
+		return basename + sizeof(SKEW_PREFIX) - 1;
+	return basename;
+}
+
+/*
+ * Create links to additional files (usually .c and .gcno files) which the
+ * gcov tool expects to find in the same directory as the gcov data file.
+ */
+static void add_links(struct gcov_node *node, struct dentry *parent)
+{
+	char *basename;
+	char *target;
+	int num;
+	int i;
+
+	for (num = 0; gcov_link[num].ext; num++)
+		/* Nothing. */;
+	node->links = kcalloc(num, sizeof(struct dentry *), GFP_KERNEL);
+	if (!node->links)
+		return;
+	for (i = 0; i < num; i++) {
+		target = get_link_target(get_node_info(node)->filename,
+					 &gcov_link[i]);
+		if (!target)
+			goto out_err;
+		basename = strrchr(target, '/');
+		if (!basename)
+			goto out_err;
+		basename++;
+		node->links[i] = debugfs_create_symlink(deskew(basename),
+							parent,	target);
+		if (!node->links[i])
+			goto out_err;
+		kfree(target);
+	}
+
+	return;
+out_err:
+	kfree(target);
+	while (i-- > 0)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
+static const struct file_operations gcov_data_fops = {
+	.open		= gcov_seq_open,
+	.release	= gcov_seq_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.write		= gcov_seq_write,
+};
+
+/* Basic initialization of a new node. */
+static void init_node(struct gcov_node *node, struct gcov_info *info,
+		      const char *name, struct gcov_node *parent)
+{
+	INIT_LIST_HEAD(&node->list);
+	INIT_LIST_HEAD(&node->children);
+	INIT_LIST_HEAD(&node->all);
+	node->info = info;
+	node->parent = parent;
+	if (name)
+		strcpy(node->name, name);
+}
+
+/*
+ * Create a new node and associated debugfs entry. Needs to be called with
+ * node_lock held.
+ */
+static struct gcov_node *new_node(struct gcov_node *parent,
+				  struct gcov_info *info, const char *name)
+{
+	struct gcov_node *node;
+
+	node = kzalloc(sizeof(struct gcov_node) + strlen(name) + 1, GFP_KERNEL);
+	if (!node) {
+		pr_warning("out of memory\n");
+		return NULL;
+	}
+	init_node(node, info, name, parent);
+	/* Differentiate between gcov data file nodes and directory nodes. */
+	if (info) {
+		node->dentry = debugfs_create_file(deskew(node->name), 0600,
+					parent->dentry, node, &gcov_data_fops);
+	} else
+		node->dentry = debugfs_create_dir(node->name, parent->dentry);
+	if (!node->dentry) {
+		pr_warning("could not create file\n");
+		kfree(node);
+		return NULL;
+	}
+	if (info)
+		add_links(node, parent->dentry);
+	list_add(&node->list, &parent->children);
+	list_add(&node->all, &all_head);
+
+	return node;
+}
+
+/* Remove symbolic links associated with node. */
+static void remove_links(struct gcov_node *node)
+{
+	int i;
+
+	if (!node->links)
+		return;
+	for (i = 0; gcov_link[i].ext; i++)
+		debugfs_remove(node->links[i]);
+	kfree(node->links);
+	node->links = NULL;
+}
+
+/*
+ * Remove node from all lists and debugfs and release associated resources.
+ * Needs to be called with node_lock held.
+ */
+static void release_node(struct gcov_node *node)
+{
+	list_del(&node->list);
+	list_del(&node->all);
+	debugfs_remove(node->dentry);
+	remove_links(node);
+	if (node->ghost)
+		gcov_info_free(node->ghost);
+	kfree(node);
+}
+
+/* Release node and empty parents. Needs to be called with node_lock held. */
+static void remove_node(struct gcov_node *node)
+{
+	struct gcov_node *parent;
+
+	while ((node != &root_node) && list_empty(&node->children)) {
+		parent = node->parent;
+		release_node(node);
+		node = parent;
+	}
+}
+
+/*
+ * Find child node with given basename. Needs to be called with node_lock
+ * held.
+ */
+static struct gcov_node *get_child_by_name(struct gcov_node *parent,
+					   const char *name)
+{
+	struct gcov_node *node;
+
+	list_for_each_entry(node, &parent->children, list) {
+		if (strcmp(node->name, name) == 0)
+			return node;
+	}
+
+	return NULL;
+}
+
+/*
+ * write() implementation for reset file. Reset all profiling data to zero
+ * and remove ghost nodes.
+ */
+static ssize_t reset_write(struct file *file, const char __user *addr,
+			   size_t len, loff_t *pos)
+{
+	struct gcov_node *node;
+
+	mutex_lock(&node_lock);
+restart:
+	list_for_each_entry(node, &all_head, all) {
+		if (node->info)
+			gcov_info_reset(node->info);
+		else if (list_empty(&node->children)) {
+			remove_node(node);
+			/* Several nodes may have gone - restart loop. */
+			goto restart;
+		}
+	}
+	mutex_unlock(&node_lock);
+
+	return len;
+}
+
+/* read() implementation for reset file. Unused. */
+static ssize_t reset_read(struct file *file, char __user *addr, size_t len,
+			  loff_t *pos)
+{
+	/* Allow read operation so that a recursive copy won't fail. */
+	return 0;
+}
+
+static const struct file_operations gcov_reset_fops = {
+	.write	= reset_write,
+	.read	= reset_read,
+};
+
+/*
+ * Create a node for a given profiling data set and add it to all lists and
+ * debugfs. Needs to be called with node_lock held.
+ */
+static void add_node(struct gcov_info *info)
+{
+	char *filename;
+	char *curr;
+	char *next;
+	struct gcov_node *parent;
+	struct gcov_node *node;
+
+	filename = kstrdup(info->filename, GFP_KERNEL);
+	if (!filename)
+		return;
+	parent = &root_node;
+	/* Create directory nodes along the path. */
+	for (curr = filename; (next = strchr(curr, '/')); curr = next + 1) {
+		if (curr == next)
+			continue;
+		*next = 0;
+		if (strcmp(curr, ".") == 0)
+			continue;
+		if (strcmp(curr, "..") == 0) {
+			if (!parent->parent)
+				goto err_remove;
+			parent = parent->parent;
+			continue;
+		}
+		node = get_child_by_name(parent, curr);
+		if (!node) {
+			node = new_node(parent, NULL, curr);
+			if (!node)
+				goto err_remove;
+		}
+		parent = node;
+	}
+	/* Create file node. */
+	node = new_node(parent, info, curr);
+	if (!node)
+		goto err_remove;
+out:
+	kfree(filename);
+	return;
+
+err_remove:
+	remove_node(parent);
+	goto out;
+}
+
+/*
+ * The profiling data set associated with this node is being unloaded. Store a
+ * copy of the profiling data and turn this node into a "ghost".
+ */
+static int ghost_node(struct gcov_node *node)
+{
+	node->ghost = gcov_info_dup(node->info);
+	if (!node->ghost) {
+		pr_warning("could not save data for '%s' (out of memory)\n",
+			   node->info->filename);
+		return -ENOMEM;
+	}
+	node->info = NULL;
+
+	return 0;
+}
+
+/*
+ * Profiling data for this node has been loaded again. Add profiling data
+ * from previous instantiation and turn this node into a regular node.
+ */
+static void revive_node(struct gcov_node *node, struct gcov_info *info)
+{
+	if (gcov_info_is_compatible(node->ghost, info))
+		gcov_info_add(info, node->ghost);
+	else {
+		pr_warning("discarding saved data for '%s' (version changed)\n",
+			   info->filename);
+	}
+	gcov_info_free(node->ghost);
+	node->ghost = NULL;
+	node->info = info;
+}
+
+/*
+ * Callback to create/remove profiling files when code compiled with
+ * -fprofile-arcs is loaded/unloaded.
+ */
+void gcov_event(enum gcov_action action, struct gcov_info *info)
+{
+	struct gcov_node *node;
+
+	mutex_lock(&node_lock);
+	node = get_node_by_name(info->filename);
+	switch (action) {
+	case GCOV_ADD:
+		/* Add new node or revive ghost. */
+		if (!node) {
+			add_node(info);
+			break;
+		}
+		if (gcov_persist)
+			revive_node(node, info);
+		else {
+			pr_warning("could not add '%s' (already exists)\n",
+				   info->filename);
+		}
+		break;
+	case GCOV_REMOVE:
+		/* Remove node or turn into ghost. */
+		if (!node) {
+			pr_warning("could not remove '%s' (not found)\n",
+				   info->filename);
+			break;
+		}
+		if (gcov_persist) {
+			if (!ghost_node(node))
+				break;
+		}
+		remove_node(node);
+		break;
+	}
+	mutex_unlock(&node_lock);
+}
+
+/* Create debugfs entries. */
+static __init int gcov_fs_init(void)
+{
+	int rc = -EIO;
+
+	init_node(&root_node, NULL, NULL, NULL);
+	/*
+	 * /sys/kernel/debug/gcov will be parent for the reset control file
+	 * and all profiling files.
+	 */
+	root_node.dentry = debugfs_create_dir("gcov", NULL);
+	if (!root_node.dentry)
+		goto err_remove;
+	/*
+	 * Create reset file which resets all profiling counts when written
+	 * to.
+	 */
+	reset_dentry = debugfs_create_file("reset", 0600, root_node.dentry,
+					   NULL, &gcov_reset_fops);
+	if (!reset_dentry)
+		goto err_remove;
+	/* Replay previous events to get our fs hierarchy up-to-date. */
+	gcov_enable_events();
+	return 0;
+
+err_remove:
+	pr_err("init failed\n");
+	if (root_node.dentry)
+		debugfs_remove(root_node.dentry);
+
+	return rc;
+}
+device_initcall(gcov_fs_init);
diff -puN /dev/null kernel/gcov/gcc_3_4.c
--- /dev/null
+++ a/kernel/gcov/gcc_3_4.c
@@ -0,0 +1,447 @@
+/*
+ *  This code provides functions to handle gcc's profiling data format
+ *  introduced with gcc 3.4. Future versions of gcc may change the gcov
+ *  format (as happened before), so all format-specific information needs
+ *  to be kept modular and easily exchangeable.
+ *
+ *  This file is based on gcc-internal definitions. Functions and data
+ *  structures are defined to be compatible with gcc counterparts.
+ *  For a better understanding, refer to gcc source: gcc/gcov-io.h.
+ *
+ *    Copyright IBM Corp. 2009
+ *    Author(s): Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ */
+
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/vmalloc.h>
+#include "gcov.h"
+
+/* Symbolic links to be created for each profiling data file. */
+const struct gcov_link gcov_link[] = {
+	{ OBJ_TREE, "gcno" },	/* Link to .gcno file in $(objtree). */
+	{ 0, NULL},
+};
+
+/*
+ * Determine whether a counter is active. Based on gcc magic. Doesn't change
+ * at run-time.
+ */
+static int counter_active(struct gcov_info *info, unsigned int type)
+{
+	return (1 << type) & info->ctr_mask;
+}
+
+/* Determine number of active counters. Based on gcc magic. */
+static unsigned int num_counter_active(struct gcov_info *info)
+{
+	unsigned int i;
+	unsigned int result = 0;
+
+	for (i = 0; i < GCOV_COUNTERS; i++) {
+		if (counter_active(info, i))
+			result++;
+	}
+	return result;
+}
+
+/**
+ * gcov_info_reset - reset profiling data to zero
+ * @info: profiling data set
+ */
+void gcov_info_reset(struct gcov_info *info)
+{
+	unsigned int active = num_counter_active(info);
+	unsigned int i;
+
+	for (i = 0; i < active; i++) {
+		memset(info->counts[i].values, 0,
+		       info->counts[i].num * sizeof(gcov_type));
+	}
+}
+
+/**
+ * gcov_info_is_compatible - check if profiling data can be added
+ * @info1: first profiling data set
+ * @info2: second profiling data set
+ *
+ * Returns non-zero if profiling data can be added, zero otherwise.
+ */
+int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2)
+{
+	return (info1->stamp == info2->stamp);
+}
+
+/**
+ * gcov_info_add - add up profiling data
+ * @dest: profiling data set to which data is added
+ * @source: profiling data set which is added
+ *
+ * Adds profiling counts of @source to @dest.
+ */
+void gcov_info_add(struct gcov_info *dest, struct gcov_info *source)
+{
+	unsigned int i;
+	unsigned int j;
+
+	for (i = 0; i < num_counter_active(dest); i++) {
+		for (j = 0; j < dest->counts[i].num; j++) {
+			dest->counts[i].values[j] +=
+				source->counts[i].values[j];
+		}
+	}
+}
+
+/* Get size of function info entry. Based on gcc magic. */
+static size_t get_fn_size(struct gcov_info *info)
+{
+	size_t size;
+
+	size = sizeof(struct gcov_fn_info) + num_counter_active(info) *
+	       sizeof(unsigned int);
+	if (__alignof__(struct gcov_fn_info) > sizeof(unsigned int))
+		size = ALIGN(size, __alignof__(struct gcov_fn_info));
+	return size;
+}
+
+/* Get address of function info entry. Based on gcc magic. */
+static struct gcov_fn_info *get_fn_info(struct gcov_info *info, unsigned int fn)
+{
+	return (struct gcov_fn_info *)
+		((char *) info->functions + fn * get_fn_size(info));
+}
+
+/**
+ * gcov_info_dup - duplicate profiling data set
+ * @info: profiling data set to duplicate
+ *
+ * Return newly allocated duplicate on success, %NULL on error.
+ */
+struct gcov_info *gcov_info_dup(struct gcov_info *info)
+{
+	struct gcov_info *dup;
+	unsigned int i;
+	unsigned int active;
+
+	/* Duplicate gcov_info. */
+	active = num_counter_active(info);
+	dup = kzalloc(sizeof(struct gcov_info) +
+		      sizeof(struct gcov_ctr_info) * active, GFP_KERNEL);
+	if (!dup)
+		return NULL;
+	dup->version		= info->version;
+	dup->stamp		= info->stamp;
+	dup->n_functions	= info->n_functions;
+	dup->ctr_mask		= info->ctr_mask;
+	/* Duplicate filename. */
+	dup->filename		= kstrdup(info->filename, GFP_KERNEL);
+	if (!dup->filename)
+		goto err_free;
+	/* Duplicate table of functions. */
+	dup->functions = kmemdup(info->functions, info->n_functions *
+				 get_fn_size(info), GFP_KERNEL);
+	if (!dup->functions)
+		goto err_free;
+	/* Duplicate counter arrays. */
+	for (i = 0; i < active ; i++) {
+		struct gcov_ctr_info *ctr = &info->counts[i];
+		size_t size = ctr->num * sizeof(gcov_type);
+
+		dup->counts[i].num = ctr->num;
+		dup->counts[i].merge = ctr->merge;
+		dup->counts[i].values = vmalloc(size);
+		if (!dup->counts[i].values)
+			goto err_free;
+		memcpy(dup->counts[i].values, ctr->values, size);
+	}
+	return dup;
+
+err_free:
+	gcov_info_free(dup);
+	return NULL;
+}
+
+/**
+ * gcov_info_free - release memory for profiling data set duplicate
+ * @info: profiling data set duplicate to free
+ */
+void gcov_info_free(struct gcov_info *info)
+{
+	unsigned int active = num_counter_active(info);
+	unsigned int i;
+
+	for (i = 0; i < active ; i++)
+		vfree(info->counts[i].values);
+	kfree(info->functions);
+	kfree(info->filename);
+	kfree(info);
+}
+
+/**
+ * struct type_info - iterator helper array
+ * @ctr_type: counter type
+ * @offset: index of the first value of the current function for this type
+ *
+ * This array is needed to convert the in-memory data format into the in-file
+ * data format:
+ *
+ * In-memory:
+ *   for each counter type
+ *     for each function
+ *       values
+ *
+ * In-file:
+ *   for each function
+ *     for each counter type
+ *       values
+ *
+ * See gcc source gcc/gcov-io.h for more information on data organization.
+ */
+struct type_info {
+	int ctr_type;
+	unsigned int offset;
+};
+
+/**
+ * struct gcov_iterator - specifies current file position in logical records
+ * @info: associated profiling data
+ * @record: record type
+ * @function: function number
+ * @type: counter type
+ * @count: index into values array
+ * @num_types: number of counter types
+ * @type_info: helper array to get values-array offset for current function
+ */
+struct gcov_iterator {
+	struct gcov_info *info;
+
+	int record;
+	unsigned int function;
+	unsigned int type;
+	unsigned int count;
+
+	int num_types;
+	struct type_info type_info[0];
+};
+
+static struct gcov_fn_info *get_func(struct gcov_iterator *iter)
+{
+	return get_fn_info(iter->info, iter->function);
+}
+
+static struct type_info *get_type(struct gcov_iterator *iter)
+{
+	return &iter->type_info[iter->type];
+}
+
+/**
+ * gcov_iter_new - allocate and initialize profiling data iterator
+ * @info: profiling data set to be iterated
+ *
+ * Return file iterator on success, %NULL otherwise.
+ */
+struct gcov_iterator *gcov_iter_new(struct gcov_info *info)
+{
+	struct gcov_iterator *iter;
+
+	iter = kzalloc(sizeof(struct gcov_iterator) +
+		       num_counter_active(info) * sizeof(struct type_info),
+		       GFP_KERNEL);
+	if (iter)
+		iter->info = info;
+
+	return iter;
+}
+
+/**
+ * gcov_iter_free - release memory for iterator
+ * @iter: file iterator to free
+ */
+void gcov_iter_free(struct gcov_iterator *iter)
+{
+	kfree(iter);
+}
+
+/**
+ * gcov_iter_get_info - return profiling data set for given file iterator
+ * @iter: file iterator
+ */
+struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter)
+{
+	return iter->info;
+}
+
+/**
+ * gcov_iter_start - reset file iterator to starting position
+ * @iter: file iterator
+ */
+void gcov_iter_start(struct gcov_iterator *iter)
+{
+	int i;
+
+	iter->record = 0;
+	iter->function = 0;
+	iter->type = 0;
+	iter->count = 0;
+	iter->num_types = 0;
+	for (i = 0; i < GCOV_COUNTERS; i++) {
+		if (counter_active(iter->info, i)) {
+			iter->type_info[iter->num_types].ctr_type = i;
+			iter->type_info[iter->num_types++].offset = 0;
+		}
+	}
+}
+
+/* Mapping of logical record number to actual file content. */
+#define RECORD_FILE_MAGIC	0
+#define RECORD_GCOV_VERSION	1
+#define RECORD_TIME_STAMP	2
+#define RECORD_FUNCTION_TAG	3
+#define RECORD_FUNCTON_TAG_LEN	4
+#define RECORD_FUNCTION_IDENT	5
+#define RECORD_FUNCTION_CHECK	6
+#define RECORD_COUNT_TAG	7
+#define RECORD_COUNT_LEN	8
+#define RECORD_COUNT		9
+
+/**
+ * gcov_iter_next - advance file iterator to next logical record
+ * @iter: file iterator
+ *
+ * Return zero if new position is valid, non-zero if iterator has reached end.
+ */
+int gcov_iter_next(struct gcov_iterator *iter)
+{
+	switch (iter->record) {
+	case RECORD_FILE_MAGIC:
+	case RECORD_GCOV_VERSION:
+	case RECORD_FUNCTION_TAG:
+	case RECORD_FUNCTON_TAG_LEN:
+	case RECORD_FUNCTION_IDENT:
+	case RECORD_COUNT_TAG:
+		/* Advance to next record */
+		iter->record++;
+		break;
+	case RECORD_COUNT:
+		/* Advance to next count */
+		iter->count++;
+		/* fall through */
+	case RECORD_COUNT_LEN:
+		if (iter->count < get_func(iter)->n_ctrs[iter->type]) {
+			iter->record = 9;
+			break;
+		}
+		/* Advance to next counter type */
+		get_type(iter)->offset += iter->count;
+		iter->count = 0;
+		iter->type++;
+		/* fall through */
+	case RECORD_FUNCTION_CHECK:
+		if (iter->type < iter->num_types) {
+			iter->record = 7;
+			break;
+		}
+		/* Advance to next function */
+		iter->type = 0;
+		iter->function++;
+		/* fall through */
+	case RECORD_TIME_STAMP:
+		if (iter->function < iter->info->n_functions)
+			iter->record = 3;
+		else
+			iter->record = -1;
+		break;
+	}
+	/* Check for EOF. */
+	if (iter->record == -1)
+		return -EINVAL;
+	else
+		return 0;
+}
+
+/**
+ * seq_write_gcov_u32 - write 32 bit number in gcov format to seq_file
+ * @seq: seq_file handle
+ * @v: value to be stored
+ *
+ * Number format defined by gcc: numbers are recorded in the 32 bit
+ * unsigned binary form of the endianness of the machine generating the
+ * file.
+ */
+static int seq_write_gcov_u32(struct seq_file *seq, u32 v)
+{
+	return seq_write(seq, &v, sizeof(v));
+}
+
+/**
+ * seq_write_gcov_u64 - write 64 bit number in gcov format to seq_file
+ * @seq: seq_file handle
+ * @v: value to be stored
+ *
+ * Number format defined by gcc: numbers are recorded in the 32 bit
+ * unsigned binary form of the endianness of the machine generating the
+ * file. 64 bit numbers are stored as two 32 bit numbers, the low part
+ * first.
+ */
+static int seq_write_gcov_u64(struct seq_file *seq, u64 v)
+{
+	u32 data[2];
+
+	data[0] = (v & 0xffffffffUL);
+	data[1] = (v >> 32);
+	return seq_write(seq, data, sizeof(data));
+}
+
+/**
+ * gcov_iter_write - write data for current pos to seq_file
+ * @iter: file iterator
+ * @seq: seq_file handle
+ *
+ * Return zero on success, non-zero otherwise.
+ */
+int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq)
+{
+	int rc = -EINVAL;
+
+	switch (iter->record) {
+	case RECORD_FILE_MAGIC:
+		rc = seq_write_gcov_u32(seq, GCOV_DATA_MAGIC);
+		break;
+	case RECORD_GCOV_VERSION:
+		rc = seq_write_gcov_u32(seq, iter->info->version);
+		break;
+	case RECORD_TIME_STAMP:
+		rc = seq_write_gcov_u32(seq, iter->info->stamp);
+		break;
+	case RECORD_FUNCTION_TAG:
+		rc = seq_write_gcov_u32(seq, GCOV_TAG_FUNCTION);
+		break;
+	case RECORD_FUNCTON_TAG_LEN:
+		rc = seq_write_gcov_u32(seq, 2);
+		break;
+	case RECORD_FUNCTION_IDENT:
+		rc = seq_write_gcov_u32(seq, get_func(iter)->ident);
+		break;
+	case RECORD_FUNCTION_CHECK:
+		rc = seq_write_gcov_u32(seq, get_func(iter)->checksum);
+		break;
+	case RECORD_COUNT_TAG:
+		rc = seq_write_gcov_u32(seq,
+			GCOV_TAG_FOR_COUNTER(get_type(iter)->ctr_type));
+		break;
+	case RECORD_COUNT_LEN:
+		rc = seq_write_gcov_u32(seq,
+				get_func(iter)->n_ctrs[iter->type] * 2);
+		break;
+	case RECORD_COUNT:
+		rc = seq_write_gcov_u64(seq,
+			iter->info->counts[iter->type].
+				values[iter->count + get_type(iter)->offset]);
+		break;
+	}
+	return rc;
+}
diff -puN /dev/null kernel/gcov/gcov.h
--- /dev/null
+++ a/kernel/gcov/gcov.h
@@ -0,0 +1,128 @@
+/*
+ *  Profiling infrastructure declarations.
+ *
+ *  This file is based on gcc-internal definitions. Data structures are
+ *  defined to be compatible with gcc counterparts. For a better
+ *  understanding, refer to gcc source: gcc/gcov-io.h.
+ *
+ *    Copyright IBM Corp. 2009
+ *    Author(s): Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+ *
+ *    Uses gcc-internal data definitions.
+ */
+
+#ifndef GCOV_H
+#define GCOV_H GCOV_H
+
+#include <linux/types.h>
+
+/*
+ * Profiling data types used for gcc 3.4 and above - these are defined by
+ * gcc and need to be kept as close to the original definition as possible to
+ * remain compatible.
+ */
+#define GCOV_COUNTERS		5
+#define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
+#define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
+#define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
+#define GCOV_TAG_FOR_COUNTER(count)					\
+	(GCOV_TAG_COUNTER_BASE + ((unsigned int) (count) << 17))
+
+#if BITS_PER_LONG >= 64
+typedef long gcov_type;
+#else
+typedef long long gcov_type;
+#endif
+
+/**
+ * struct gcov_fn_info - profiling meta data per function
+ * @ident: object file-unique function identifier
+ * @checksum: function checksum
+ * @n_ctrs: number of values per counter type belonging to this function
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time.
+ */
+struct gcov_fn_info {
+	unsigned int ident;
+	unsigned int checksum;
+	unsigned int n_ctrs[0];
+};
+
+/**
+ * struct gcov_ctr_info - profiling data per counter type
+ * @num: number of counter values for this type
+ * @values: array of counter values for this type
+ * @merge: merge function for counter values of this type (unused)
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time with the exception of the values array.
+ */
+struct gcov_ctr_info {
+	unsigned int	num;
+	gcov_type	*values;
+	void		(*merge)(gcov_type *, unsigned int);
+};
+
+/**
+ * struct gcov_info - profiling data per object file
+ * @version: gcov version magic indicating the gcc version used for compilation
+ * @next: list head for a singly-linked list
+ * @stamp: time stamp
+ * @filename: name of the associated gcov data file
+ * @n_functions: number of instrumented functions
+ * @functions: function data
+ * @ctr_mask: mask specifying which counter types are active
+ * @counts: counter data per counter type
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time with the exception of the next pointer.
+ */
+struct gcov_info {
+	unsigned int			version;
+	struct gcov_info		*next;
+	unsigned int			stamp;
+	const char			*filename;
+	unsigned int			n_functions;
+	const struct gcov_fn_info	*functions;
+	unsigned int			ctr_mask;
+	struct gcov_ctr_info		counts[0];
+};
+
+/* Base interface. */
+enum gcov_action {
+	GCOV_ADD,
+	GCOV_REMOVE,
+};
+
+void gcov_event(enum gcov_action action, struct gcov_info *info);
+void gcov_enable_events(void);
+
+/* Iterator control. */
+struct seq_file;
+struct gcov_iterator;
+
+struct gcov_iterator *gcov_iter_new(struct gcov_info *info);
+void gcov_iter_free(struct gcov_iterator *iter);
+void gcov_iter_start(struct gcov_iterator *iter);
+int gcov_iter_next(struct gcov_iterator *iter);
+int gcov_iter_write(struct gcov_iterator *iter, struct seq_file *seq);
+struct gcov_info *gcov_iter_get_info(struct gcov_iterator *iter);
+
+/* gcov_info control. */
+void gcov_info_reset(struct gcov_info *info);
+int gcov_info_is_compatible(struct gcov_info *info1, struct gcov_info *info2);
+void gcov_info_add(struct gcov_info *dest, struct gcov_info *source);
+struct gcov_info *gcov_info_dup(struct gcov_info *info);
+void gcov_info_free(struct gcov_info *info);
+
+struct gcov_link {
+	enum {
+		OBJ_TREE,
+		SRC_TREE,
+	} dir;
+	const char *ext;
+};
+extern const struct gcov_link gcov_link[];
+
+#endif /* GCOV_H */
diff -puN scripts/Makefile.lib~gcov-add-gcov-profiling-infrastructure scripts/Makefile.lib
--- a/scripts/Makefile.lib~gcov-add-gcov-profiling-infrastructure
+++ a/scripts/Makefile.lib
@@ -116,6 +116,17 @@ _a_flags       = $(KBUILD_CPPFLAGS) $(KB
                  $(asflags-y) $(AFLAGS_$(basetarget).o)
 _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
 
+#
+# Enable gcov profiling flags for a file, directory or for all files depending
+# on variables GCOV_PROFILE_obj.o, GCOV_PROFILE and CONFIG_GCOV_PROFILE_ALL
+# (in this order)
+#
+ifeq ($(CONFIG_GCOV_KERNEL),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(GCOV_PROFILE_$(basetarget).o)$(GCOV_PROFILE)$(CONFIG_GCOV_PROFILE_ALL)), \
+		$(CFLAGS_GCOV))
+endif
+
 # If building the kernel in a separate objtree expand all occurrences
 # of -Idir to -I$(srctree)/dir except for absolute paths (starting with '/').
 
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

origin.patch

