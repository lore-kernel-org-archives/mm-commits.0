From: akpm@linux-foundation.org
Subject: [merged] kfifo-add-kfifo_initialized.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:33 -0800
Message-ID: <201001212127.o0LLRX8F030653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab0AUV20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: add kfifo_initialized
has been removed from the -mm tree.  Its filename was
     kfifo-add-kfifo_initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: add kfifo_initialized
From: Andi Kleen <andi@firstfloor.org>

Simple inline that checks if kfifo_init() has been executed on a fifo.

This is useful for walking all per CPU fifos, when some of them might not
have been brought up yet.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN include/linux/kfifo.h~kfifo-add-kfifo_initialized include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-kfifo_initialized
+++ a/include/linux/kfifo.h
@@ -116,6 +116,16 @@ extern __must_check unsigned int kfifo_o
 extern __must_check unsigned int kfifo_out_peek(struct kfifo *fifo,
 				void *to, unsigned int len, unsigned offset);
 
+/**
+ * kfifo_initialized - Check if kfifo is initialized.
+ * @fifo: fifo to check
+ * Return %true if FIFO is initialized, otherwise %false.
+ * Assumes the fifo was 0 before.
+ */
+static inline bool kfifo_initialized(struct kfifo *fifo)
+{
+	return fifo->buffer != 0;
+}
 
 /**
  * kfifo_reset - removes the entire FIFO contents
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
hardware-latency-detector-remove-default-m.patch
mm-add-swap-slot-free-callback-to-block_device_operations.patch
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

