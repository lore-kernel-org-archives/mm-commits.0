From: akpm@linux-foundation.org
Subject: - rewrite-rd-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:43:00 -0800
Message-ID: <200802080842.m188gfqw016096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49848 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbYBHInK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:43:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     rewrite-rd-fixes
has been removed from the -mm tree.  Its filename was
     rewrite-rd-fixes.patch

This patch was dropped because it was folded into rewrite-rd.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rewrite-rd-fixes
From: Andrew Morton <akpm@linux-foundation.org>

drivers/block/brd.c: In function 'copy_from_brd':
drivers/block/brd.c:230: warning: passing argument 1 of 'kunmap_atomic' discards qualifiers from pointer target type
drivers/block/brd.c:242: warning: passing argument 1 of 'kunmap_atomic' discards qualifiers from pointer target type

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~rewrite-rd-fixes drivers/block/brd.c
--- a/drivers/block/brd.c~rewrite-rd-fixes
+++ a/drivers/block/brd.c
@@ -218,7 +218,7 @@ static void copy_from_brd(void *dst, str
 			sector_t sector, size_t n)
 {
 	struct page *page;
-	const void *src;
+	void *src;
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
rewrite-rd.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
