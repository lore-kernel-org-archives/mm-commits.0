From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage.patch removed
 from -mm tree
Date: Wed, 13 Nov 2013 12:37:37 -0800
Message-ID: <5283e311.PCkcB47JG4Qa/5rI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KMUhh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, jack@suse.cz

Subject: [merged] ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage.patch removed from -mm tree
To: jack@suse.cz,jlbec@evilplan.org,mfasheh@suse.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:37 -0800


The patch titled
     Subject: ocfs2: simplify ocfs2_invalidatepage() and ocfs2_releasepage()
has been removed from the -mm tree.  Its filename was
     ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: ocfs2: simplify ocfs2_invalidatepage() and ocfs2_releasepage()

Ocfs2 doesn't do data journalling.  Thus its ->invalidatepage and
->releasepage functions never get called on buffers that have journal
heads attached.  So just use standard variants of functions from buffer.c.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-simplify-ocfs2_invalidatepage-and-ocfs2_releasepage
+++ a/fs/ocfs2/aops.c
@@ -594,26 +594,11 @@ static void ocfs2_dio_end_io(struct kioc
 	ocfs2_rw_unlock(inode, level);
 }
 
-/*
- * ocfs2_invalidatepage() and ocfs2_releasepage() are shamelessly stolen
- * from ext3.  PageChecked() bits have been removed as OCFS2 does not
- * do journalled data.
- */
-static void ocfs2_invalidatepage(struct page *page, unsigned int offset,
-				 unsigned int length)
-{
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
-
-	jbd2_journal_invalidatepage(journal, page, offset, length);
-}
-
 static int ocfs2_releasepage(struct page *page, gfp_t wait)
 {
-	journal_t *journal = OCFS2_SB(page->mapping->host->i_sb)->journal->j_journal;
-
 	if (!page_has_buffers(page))
 		return 0;
-	return jbd2_journal_try_to_free_buffers(journal, page, wait);
+	return try_to_free_buffers(page);
 }
 
 static ssize_t ocfs2_direct_IO(int rw,
@@ -2092,7 +2077,7 @@ const struct address_space_operations oc
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
 	.direct_IO		= ocfs2_direct_IO,
-	.invalidatepage		= ocfs2_invalidatepage,
+	.invalidatepage		= block_invalidatepage,
 	.releasepage		= ocfs2_releasepage,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate	= block_is_partially_uptodate,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
revert-softirq-add-support-for-triggering-softirq-work-on-softirqs.patch
kernel-remove-config_use_generic_smp_helpers.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
kernel-fix-generic_exec_single-indication.patch
llists-move-llist_reverse_order-from-raid5-to-llistc.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
rbtree-test-move-rb_node-to-the-middle-of-the-test-struct.patch
rbtree-test-test-rbtree_postorder_for_each_entry_safe.patch
net-netfilter-ipset-ip_set_hash_netifacec-use-rbtree-postorder-iteration-instead-of-opencoding.patch
fs-ubifs-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext4-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-jffs2-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
drivers-mtd-ubi-use-rbtree-postorder-iteration-helper-instead-of-opencoding.patch
arch-sh-kernel-dwarfc-use-rbtree-postorder-iteration-helper-instead-of-solution-using-repeated-rb_erase.patch

