From: akpm@linux-foundation.org
Subject: + make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:08:03 -0700
Message-ID: <200708232208.l7NM84Fi029202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932148AbXHWWIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, greg@kroah.com


The patch titled
     make kobject dynamic allocation check use kallsyms_lookup()
has been added to the -mm tree.  Its filename is
     make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make kobject dynamic allocation check use kallsyms_lookup()
From: Dave Hansen <haveblue@us.ibm.com>

One of the top ten sysfs problems is that users use statically allocated
kobjects.  This patch reminds them that this is a naughty thing.

One _really_ nice thing this patch does, is us the kallsyms mechanism to
print out exactly which symbol is being complained about:

	The kobject at, or inside 'statickobj.2'@(0xc040d020) is not dynamically allocated.

This patch replaces the previous implementation's use of a _sdata symbol in
favor of using kallsyms_lookup().  If a kobject's address is a resolvable
symbol, then it isn't dynamically allocated.

The one exception to this is init symbols.  The patch also checks to see
whether __init memory has been freed and if it has will allow kobjects in
those sections.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    1 
 init/main.c          |    9 ++++++
 lib/kobject.c        |   56 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

diff -puN include/linux/init.h~make-kobject-dynamic-allocation-check-use-kallsyms_lookup include/linux/init.h
--- a/include/linux/init.h~make-kobject-dynamic-allocation-check-use-kallsyms_lookup
+++ a/include/linux/init.h
@@ -83,6 +83,7 @@ extern initcall_t __security_initcall_st
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern int initmem_now_dynamic;
 
 /* used by init/main.c */
 void setup_arch(char **);
diff -puN init/main.c~make-kobject-dynamic-allocation-check-use-kallsyms_lookup init/main.c
--- a/init/main.c~make-kobject-dynamic-allocation-check-use-kallsyms_lookup
+++ a/init/main.c
@@ -776,12 +776,21 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
+/*
+ * __init/__init_data sections are turned into normal
+ * dynamically allocated memory later in boot.  When
+ * this is 0, the memory is for the __init purposes,
+ * when it it some other value, the memory is dynamic.
+ */
+int initmem_now_dynamic;
+
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
 static int noinline init_post(void)
 {
 	free_initmem();
+	initmem_now_dynamic = 1;
 	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
diff -puN lib/kobject.c~make-kobject-dynamic-allocation-check-use-kallsyms_lookup lib/kobject.c
--- a/lib/kobject.c~make-kobject-dynamic-allocation-check-use-kallsyms_lookup
+++ a/lib/kobject.c
@@ -15,6 +15,8 @@
 #include <linux/module.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/kallsyms.h>
+#include <asm-generic/sections.h>
 
 /**
  *	populate_dir - populate directory with attributes.
@@ -121,6 +123,59 @@ char *kobject_get_path(struct kobject *k
 }
 EXPORT_SYMBOL_GPL(kobject_get_path);
 
+#ifdef CONFIG_X86_32
+static int ptr_in_range(void *ptr, void *start, void *end)
+{
+	/*
+	 * This should hopefully get rid of causing warnings
+	 * if the architecture did not set one of the section
+	 * variables up.
+	 */
+	if (start >= end)
+		return 0;
+
+	if ((ptr >= start) && (ptr < end))
+		return 1;
+	return 0;
+}
+
+void verify_dynamic_kobject_allocation(struct kobject *kobj)
+{
+	char *namebuf;
+	const char *ret;
+
+	namebuf = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
+	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL,
+			namebuf);
+	/*
+	 * This is the X86_32-only part of this function.
+	 * This is here because it is valid to have a kobject
+	 * in an __init section, but only after those
+	 * sections have been freed back to the dynamic pool.
+	 */
+	if (!initmem_now_dynamic &&
+	    ptr_in_range(kobj, __init_begin, __init_end))
+		goto out;
+	if (!ret || !strlen(ret))
+		goto out;
+	pr_debug("---- begin silly warning ----\n");
+	pr_debug("This is a janitorial warning, not a kernel bug.\n");
+#ifdef CONFIG_DEBUG_KOBJECT
+	pr_debug("The kobject at, or inside '%s'@(0x%p) is not dynamically allocated.\n",
+			namebuf, kobj);
+#endif
+	pr_debug("kobjects must be dynamically allocated, not static\n");
+	/* dump_stack(); */
+	pr_debug("---- end silly warning ----\n");
+out:
+	kfree(namebuf);
+}
+#else
+static void verify_dynamic_kobject_allocation(struct kobject *kobj)
+{
+}
+#endif
+
 /**
  *	kobject_init - initialize object.
  *	@kobj:	object in question.
@@ -130,6 +185,7 @@ void kobject_init(struct kobject * kobj)
 	if (!kobj)
 		return;
 	WARN_ON(atomic_read(&kobj->kref.refcount));
+	verify_dynamic_kobject_allocation(kobj);
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
 	init_waitqueue_head(&kobj->poll);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
make-kobject-dynamic-allocation-check-use-kallsyms_lookup.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
page-owner-tracking-leak-detector.patch
