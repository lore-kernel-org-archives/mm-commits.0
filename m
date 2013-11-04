From: akpm@linux-foundation.org
Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch added to -mm tree
Date: Mon, 04 Nov 2013 12:36:44 -0800
Message-ID: <5278055c.WOYvBMi56DWoB0bd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3KDUgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 15:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz

Subject: + writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch added to -mm tree
To: jack@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 12:36:44 -0800


The patch titled
     Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-3
has been added to the -mm tree.  Its filename is
     writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: writeback-do-not-sync-data-dirtied-after-sync-start-fix-3

Fixup sync_inodes_sb() comment

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-3 fs/fs-writeback.c
--- a/fs/fs-writeback.c~writeback-do-not-sync-data-dirtied-after-sync-start-fix-3
+++ a/fs/fs-writeback.c
@@ -1353,10 +1353,11 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb
 
 /**
  * sync_inodes_sb	-	sync sb inode pages
- * @sb: the superblock
+ * @sb:			the superblock
+ * @older_than_this:	timestamp
  *
  * This function writes and waits on any dirty inode belonging to this
- * super_block.
+ * superblock that has been dirtied before given timestamp.
  */
 void sync_inodes_sb(struct super_block *sb, unsigned long older_than_this)
 {
_

Patches currently in -mm which might be from jack@suse.cz are

ocfs2-dont-spam-on-edquot.patch
writeback-do-not-sync-data-dirtied-after-sync-start.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-2.patch
writeback-do-not-sync-data-dirtied-after-sync-start-fix-3.patch
linux-next.patch
revert-softirq-add-support-for-triggering-softirq-work-on-softirqs.patch
kernel-remove-config_use_generic_smp_helpers.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
kernel-fix-generic_exec_single-indication.patch
llists-move-llist_reverse_order-from-raid5-to-llistc.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch

