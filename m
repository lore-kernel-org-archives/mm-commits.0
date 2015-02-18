From: akpm@linux-foundation.org
Subject: [merged] scripts-gdb-add-infrastructure.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:43:46 -0800
Message-ID: <54e4eb72.UnH+2e7k3zCd6vGn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jan.kiszka@siemens.com, andi@firstfloor.org, ben@bwidawsk.net, bp@suse.de, jason.wessel@windriver.com, mmarek@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb: add infrastructure
has been removed from the -mm tree.  Its filename was
     scripts-gdb-add-infrastructure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: scripts/gdb: add infrastructure

This provides the basic infrastructure to load kernel-specific python
helper scripts when debugging the kernel in gdb.

The loading mechanism is based on gdb loading for <objfile>-gdb.py when
opening <objfile>.  Therefore, this places a corresponding link to the
main helper script into the output directory that contains vmlinux.

The main scripts will pull in submodules containing Linux specific gdb
commands and functions.  To avoid polluting the source directory with
compiled python modules, we link to them from the object directory.

Due to gdb.parse_and_eval and string redirection for gdb.execute, we
depend on gdb >= 7.2.

This feature is enabled via CONFIG_GDB_SCRIPTS.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Michal Marek <mmarek@suse.cz>		[kbuild stuff]
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                   |    5 ++++-
 lib/Kconfig.debug          |   11 +++++++++++
 scripts/Makefile           |    1 +
 scripts/gdb/Makefile       |    1 +
 scripts/gdb/linux/Makefile |   11 +++++++++++
 scripts/gdb/vmlinux-gdb.py |   23 +++++++++++++++++++++++
 6 files changed, 51 insertions(+), 1 deletion(-)

diff -puN Makefile~scripts-gdb-add-infrastructure Makefile
--- a/Makefile~scripts-gdb-add-infrastructure
+++ a/Makefile
@@ -927,6 +927,9 @@ endif
 ifdef CONFIG_BUILD_DOCSRC
 	$(Q)$(MAKE) $(build)=Documentation
 endif
+ifdef CONFIG_GDB_SCRIPTS
+	$(Q)ln -fsn `cd $(srctree) && /bin/pwd`/scripts/gdb/vmlinux-gdb.py
+endif
 	+$(call if_changed,link-vmlinux)
 
 # The actual objects are generated when descending,
@@ -1181,7 +1184,7 @@ MRPROPER_FILES += .config .config.old .v
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer
+		  signing_key.x509.signer vmlinux-gdb.py
 
 # clean - Delete most, but leave enough to build external modules
 #
diff -puN lib/Kconfig.debug~scripts-gdb-add-infrastructure lib/Kconfig.debug
--- a/lib/Kconfig.debug~scripts-gdb-add-infrastructure
+++ a/lib/Kconfig.debug
@@ -167,6 +167,17 @@ config DEBUG_INFO_DWARF4
 	  But it significantly improves the success of resolving
 	  variables in gdb on optimized code.
 
+config GDB_SCRIPTS
+	bool "Provide GDB scripts for kernel debugging"
+	depends on DEBUG_INFO
+	help
+	  This creates the required links to GDB helper scripts in the
+	  build directory. If you load vmlinux into gdb, the helper
+	  scripts will be automatically imported by gdb as well, and
+	  additional functions are available to analyze a Linux kernel
+	  instance. See Documentation/gdb-kernel-debugging.txt for further
+	  details.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
diff -puN scripts/Makefile~scripts-gdb-add-infrastructure scripts/Makefile
--- a/scripts/Makefile~scripts-gdb-add-infrastructure
+++ a/scripts/Makefile
@@ -36,6 +36,7 @@ subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
+subdir-$(CONFIG_GDB_SCRIPTS) += gdb
 
 # Let clean descend into subdirs
 subdir-	+= basic kconfig package
diff -puN /dev/null scripts/gdb/Makefile
--- /dev/null
+++ a/scripts/gdb/Makefile
@@ -0,0 +1 @@
+subdir-y := linux
diff -puN /dev/null scripts/gdb/linux/Makefile
--- /dev/null
+++ a/scripts/gdb/linux/Makefile
@@ -0,0 +1,11 @@
+always := gdb-scripts
+
+SRCTREE := $(shell cd $(srctree) && /bin/pwd)
+
+$(obj)/gdb-scripts:
+ifneq ($(KBUILD_SRC),)
+	$(Q)ln -fsn $(SRCTREE)/$(obj)/*.py $(objtree)/$(obj)
+endif
+	@:
+
+clean-files := *.pyc *.pyo $(if $(KBUILD_SRC),*.py)
diff -puN /dev/null scripts/gdb/vmlinux-gdb.py
--- /dev/null
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -0,0 +1,23 @@
+#
+# gdb helper commands and functions for Linux kernel debugging
+#
+#  loader module
+#
+# Copyright (c) Siemens AG, 2012, 2013
+#
+# Authors:
+#  Jan Kiszka <jan.kiszka@siemens.com>
+#
+# This work is licensed under the terms of the GNU GPL version 2.
+#
+
+import os
+
+sys.path.insert(0, os.path.dirname(__file__) + "/scripts/gdb")
+
+try:
+    gdb.parse_and_eval("0")
+    gdb.execute("", to_string=True)
+except:
+    gdb.write("NOTE: gdb 7.2 or later required for Linux helper scripts to "
+              "work.\n")
_

Patches currently in -mm which might be from jan.kiszka@siemens.com are

origin.patch

