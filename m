From: akpm@linux-foundation.org
Subject: + add-a-kernel_address-that-works-for-data-too.patch added to -mm tree
Date: Fri, 08 Jan 2010 15:54:03 -0800
Message-ID: <201001082354.o08Ns4iM021858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab0AHXyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 18:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, ebiederm@xmission.com, linux-arch@vger.kernel.org, rmk+lkml@arm.linux.org.uk, rusty@rustcorp.com.au, sam@ravnborg.org


The patch titled
     add a kernel_address() that works for data too
has been added to the -mm tree.  Its filename is
     add-a-kernel_address-that-works-for-data-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add a kernel_address() that works for data too
From: Andi Kleen <andi@firstfloor.org>

Add a variant of kernel_text_address() that includes kernel data.

Assumes kernel is _text ... _end - init section. True everywhere?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 kernel/extable.c       |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff -puN include/linux/kernel.h~add-a-kernel_address-that-works-for-data-too include/linux/kernel.h
--- a/include/linux/kernel.h~add-a-kernel_address-that-works-for-data-too
+++ a/include/linux/kernel.h
@@ -206,6 +206,7 @@ extern unsigned long long memparse(const
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int kernel_address(unsigned long addr);
 extern int func_ptr_is_kernel_text(void *ptr);
 
 struct pid;
diff -puN kernel/extable.c~add-a-kernel_address-that-works-for-data-too kernel/extable.c
--- a/kernel/extable.c~add-a-kernel_address-that-works-for-data-too
+++ a/kernel/extable.c
@@ -72,6 +72,18 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
+static int core_kernel_address(unsigned long addr)
+{
+	if ((addr >= (unsigned long)_text &&
+	     addr <= (unsigned long)_end)) {
+		if (addr >= (unsigned long)__init_begin &&
+		    addr < (unsigned long)__init_end)
+			return system_state == SYSTEM_BOOTING;
+		return 1;
+	}
+	return 0;
+}
+
 int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
@@ -98,6 +110,12 @@ int kernel_text_address(unsigned long ad
 	return is_module_text_address(addr);
 }
 
+/* text or data in core kernel or module */
+int kernel_address(unsigned long addr)
+{
+	return core_kernel_address(addr) || is_module_address(addr);
+}
+
 /*
  * On some architectures (PPC64, IA64) function pointers
  * are actually only tokens to some data that then holds the
_

Patches currently in -mm which might be from andi@firstfloor.org are

kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
proc-revert-procfs-provide-stack-information-for-threads.patch
kfifo-use-void-pointers-for-user-buffers.patch
kfifo-sanitize-_user-error-handling.patch
kfifo-add-kfifo_out_peek.patch
kfifo-add-kfifo_initialized.patch
kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
rcu-add-rcustring-adt-for-rcu-protected-strings.patch
add-a-kernel_address-that-works-for-data-too.patch
sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
sysctl-add-call_usermodehelper_cleanup.patch
sysctl-convert-modprobe_path-to-proc_rcu_string.patch
sysctl-convert-poweroff_command-to-proc_rcu_string.patch
sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

