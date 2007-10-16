From: akpm@linux-foundation.org
Subject: - mm-restore-kernel_ds-optimisations.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:23 -0700
Message-ID: <200710162032.l9GKWNhP014593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965926AbXJPViF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: restore KERNEL_DS optimisations
has been removed from the -mm tree.  Its filename was
     mm-restore-kernel_ds-optimisations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: restore KERNEL_DS optimisations
From: Nick Piggin <npiggin@suse.de>

Restore the KERNEL_DS optimisation, especially helpful to the 2copy write
path.

This may be a pretty questionable gain in most cases, especially after the
legacy 2copy write path is removed, but it doesn't cost much.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-restore-kernel_ds-optimisations mm/filemap.c
--- a/mm/filemap.c~mm-restore-kernel_ds-optimisations
+++ a/mm/filemap.c
@@ -2061,7 +2061,7 @@ static ssize_t generic_perform_write_2co
 		 * cannot take a pagefault with the destination page locked.
 		 * So pin the source page to copy it.
 		 */
-		if (!PageUptodate(page)) {
+		if (!PageUptodate(page) && !segment_eq(get_fs(), KERNEL_DS)) {
 			unlock_page(page);
 
 			src_page = alloc_page(GFP_KERNEL);
@@ -2186,6 +2186,13 @@ static ssize_t generic_perform_write(str
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	long status = 0;
 	ssize_t written = 0;
+	unsigned int flags = 0;
+
+	/*
+	 * Copies from kernel address space cannot fail (NFSD is a big user).
+	 */
+	if (segment_eq(get_fs(), KERNEL_DS))
+		flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
 	do {
 		struct page *page;
@@ -2217,7 +2224,7 @@ again:
 			break;
 		}
 
-		status = a_ops->write_begin(file, mapping, pos, bytes, 0,
+		status = a_ops->write_begin(file, mapping, pos, bytes, flags,
 						&page, &fsdata);
 		if (unlikely(status))
 			break;
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
