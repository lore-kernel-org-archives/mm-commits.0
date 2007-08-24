From: akpm@linux-foundation.org
Subject: - uml-fix-previous-request-size-limit-fix.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:49 -0700
Message-ID: <200708242056.l7OKun7t014100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763637AbXHXVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix previous request size limit fix
has been removed from the -mm tree.  Its filename was
     uml-fix-previous-request-size-limit-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix previous request size limit fix
From: Jeff Dike <jdike@addtoit.com>

The previous patch which limited the number of sectors in a single request
to a COWed device was correct in concept, but the limit was implemented in
the wrong place.

By putting it in ubd_add, it covered the cases where the COWing was
specified on the command line.  However, when the command line only has the
COW file specified, the fact that it's a COW file isn't known until it's
opened, so the limit is missed in these cases.

This patch moves the sector limit from ubd_add to ubd_open_dev.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-fix-previous-request-size-limit-fix arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-fix-previous-request-size-limit-fix
+++ a/arch/um/drivers/ubd_kern.c
@@ -612,6 +612,8 @@ static int ubd_open_dev(struct ubd *ubd_
 	ubd_dev->fd = fd;
 
 	if(ubd_dev->cow.file != NULL){
+		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
+
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = (void *) vmalloc(ubd_dev->cow.bitmap_len);
 		if(ubd_dev->cow.bitmap == NULL){
@@ -712,8 +714,6 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
-	if(ubd_dev->cow.file != NULL)
-		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
 	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-linker-script-alignment-bugs.patch
uml-fix-x86_64-core-dump-crash.patch
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
uml-use-64-bits-for-block-size-on-x86_64.patch
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
