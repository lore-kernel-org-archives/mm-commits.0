From: akpm@linux-foundation.org
Subject: + reiser4-fix-for-new-aops-patches.patch added to -mm tree
Date: Tue, 26 Jun 2007 14:44:29 -0700
Message-ID: <200706262144.l5QLiTJm002733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40852 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906AbXFZVot (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 17:44:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, edward@namesys.com, vs@namesys.com


The patch titled
     reiser4: fix for new aops patches
has been added to the -mm tree.  Its filename is
     reiser4-fix-for-new-aops-patches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: fix for new aops patches
From: Nick Piggin <npiggin@suse.de>

Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/extent_file_ops.c |   26 ++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletion(-)

diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-for-new-aops-patches fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-fix-for-new-aops-patches
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -7,7 +7,6 @@
 
 #include <linux/quotaops.h>
 #include <linux/swap.h>
-#include "../../../../mm/filemap.h"
 
 static inline reiser4_extent *ext_by_offset(const znode *node, int offset)
 {
@@ -937,6 +936,31 @@ static int write_extent_reserve_space(st
 	return reiser4_grab_space(count, 0 /* flags */);
 }
 
+/*
+ * filemap_copy_from_user no longer exists in generic code, because it
+ * is deadlocky (copying from user while holding the page lock is bad).
+ * As a temporary fix for reiser4, just define it here.
+ */
+static inline size_t
+filemap_copy_from_user(struct page *page, unsigned long offset,
+			const char __user *buf, unsigned bytes)
+{
+	char *kaddr;
+	int left;
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	left = __copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	if (left != 0) {
+		/* Do it the slow way */
+		kaddr = kmap(page);
+		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+		kunmap(page);
+	}
+	return bytes - left;
+}
+
 /**
  * reiser4_write_extent - write method of extent item plugin
  * @file: file to write to
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-merge-nopfn-into-fault-spufs-fix.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-3.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-fix-4.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fix-read-truncate-race.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
