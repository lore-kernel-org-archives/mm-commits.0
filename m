From: akpm@linux-foundation.org
Subject: [merged] kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch removed from -mm tree
Date: Thu, 21 Jan 2010 13:27:36 -0800
Message-ID: <201001212127.o0LLRaVf030656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38415 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755327Ab0AUV2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jan 2010 16:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, awalls@radix.net, dhillonv10@gmail.com, dmitry.torokhov@gmail.com, rdreier@cisco.com, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     kfifo: document everywhere that size has to be power of two
has been removed from the -mm tree.  Its filename was
     kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kfifo: document everywhere that size has to be power of two
From: Andi Kleen <andi@firstfloor.org>

On my first try using them I missed that the fifos need to be power of
two, resulting in a runtime bug.  Document that requirement everywhere
(and fix one grammar bug)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andy Walls <awalls@radix.net>
Cc: Vikram Dhillon <dhillonv10@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    4 ++--
 kernel/kfifo.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-document-everywhere-that-size-has-to-be-power-of-two include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-document-everywhere-that-size-has-to-be-power-of-two
+++ a/include/linux/kfifo.h
@@ -67,7 +67,7 @@ struct kfifo {
 /**
  * DECLARE_KFIFO - macro to declare a kfifo and the associated buffer
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used inside struct or union declaration
  * Note2: the macro creates two objects:
@@ -91,7 +91,7 @@ union { \
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo
  * @name: name of the declared kfifo datatype
- * @size: size of the fifo buffer
+ * @size: size of the fifo buffer. Must be a power of two.
  *
  * Note1: the macro can be used for global and local kfifo data type variables
  * Note2: the macro creates two objects:
diff -puN kernel/kfifo.c~kfifo-document-everywhere-that-size-has-to-be-power-of-two kernel/kfifo.c
--- a/kernel/kfifo.c~kfifo-document-everywhere-that-size-has-to-be-power-of-two
+++ a/kernel/kfifo.c
@@ -41,7 +41,7 @@ static void _kfifo_init(struct kfifo *fi
  * kfifo_init - initialize a FIFO using a preallocated buffer
  * @fifo: the fifo to assign the buffer
  * @buffer: the preallocated buffer to be used.
- * @size: the size of the internal buffer, this have to be a power of 2.
+ * @size: the size of the internal buffer, this has to be a power of 2.
  *
  */
 void kfifo_init(struct kfifo *fifo, void *buffer, unsigned int size)
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

