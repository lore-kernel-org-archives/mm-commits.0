From: akpm@linux-foundation.org
Subject: + uml-remove-unneeded-void-cast.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:57:13 -0700
Message-ID: <200709141057.l8EAvDO5001412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38317 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236AbXINK50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, jesper.juhl@gmail.com


The patch titled
     uml: remove unneeded void * cast
has been added to the -mm tree.  Its filename is
     uml-remove-unneeded-void-cast.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: remove unneeded void * cast
From: Jeff Dike <jdike@addtoit.com>

vmalloc() returns a void pointer, so casting to (void *) is pretty pointless.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-remove-unneeded-void-cast arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-remove-unneeded-void-cast
+++ a/arch/um/drivers/ubd_kern.c
@@ -615,7 +615,7 @@ static int ubd_open_dev(struct ubd *ubd_
 		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
-		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
+		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
 			printk(KERN_ERR "Failed to vmalloc COW bitmap\n");
 			goto error;
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-use-correct-type-in-blkgetsize-ioctl.patch
git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unneeded-void-cast.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
bitops-introduce-lock-ops.patch
