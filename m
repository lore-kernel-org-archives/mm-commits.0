From: akpm@linux-foundation.org
Subject: +
 nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch added to
 -mm tree
Date: Wed, 04 Feb 2015 14:04:13 -0800
Message-ID: <54d2975d.UbHLZKFXsWCFN3N5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46876 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965186AbbBDWEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:04:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix deadlock of segment constructor over I_SYNC flag
has been added to the -mm tree.  Its filename is
     nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Return-Path: <konishi.ryusuke@gmail.com>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00,FREEMAIL_FROM,
	T_DKIM_INVALID autolearn=ham version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id t14DWrvf001203
	for <akpm@localhost>; Wed, 4 Feb 2015 05:32:53 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Wed, 04 Feb 2015 05:32:53 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id D2ED4A54
	for <akpm@mail.linuxfoundation.org>; Wed,  4 Feb 2015 13:32:40 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-pa0-f48.google.com (mail-pa0-f48.google.com [209.85.220.48])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id F41F51F950
	for <akpm@mail.linuxfoundation.org>; Wed,  4 Feb 2015 13:32:39 +0000 (UTC)
Received: by mail-pa0-f48.google.com with SMTP id ey11so2806441pad.7
        for <akpm@mail.linuxfoundation.org>; Wed, 04 Feb 2015 05:32:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-gm-message-state:dkim-signature:sender:from:to:cc:subject:date
         :message-id:in-reply-to:references:lines:delivered-to;
        bh=S7h9kDubxxx3xEO44+527EA0fTScAol0QujzWGFYyGU=;
        b=VOKRX9SR3CziN9L2ltQviYvYk4pUu1Nc6PYe0N9dhg0w66+SHk4qgepmfTKO0KfopC
         iJCIweVD+xE2XgXmSaySG2/0WKAykVnQ5cdryFuugWipC8p8TbJWKwQDbGEIpXv3jJIl
         ManiDwniQ/7cErh+gkT3GMdLtPmg1CYnL2BNhL4J3en74Pid7v0ZzE+JB4o/VkNHOLZS
         ksSRzK37v+qe5AWnQqpAc4YTpK5BkFflAOx/4uG3C2D+DAurYDJgo35851LBQlJYMKzk
         EWT5/YLpj9pKxj/VNZU9spjFP30ilBFc1HpdrwHrYtqtdL/8hPtHMOUF/mmaMj6+oIOH
         THkA==
X-Received: by 10.68.162.130 with SMTP id ya2mr45667177pbb.113.1423056759867;
        Wed, 04 Feb 2015 05:32:39 -0800 (PST)
X-Gm-Message-State: ALoCoQkmj3pSYYsCj2stQYU3KN4oIHXXpRPdINMKrQDNbhFHsYOLFmrdLBGL1NJDG+IyXdy0uZ8fejuKm7JJDNi53a0u2StsR1An2wwFs77HQzgE5Vu8K9jHRH0KyplnMr06EY9363bduvvOtZ4h/FRqjwPP1WM3sAQMx4s5/5EmC6VUntCO+Rukk2V6fFdgBkHngAYCygmL
X-Received: by 10.68.162.130 with SMTP id ya2mr45667095pbb.113.1423056759089;
        Wed, 04 Feb 2015 05:32:39 -0800 (PST)
Received: from mail-pd0-f172.google.com (mail-pd0-f172.google.com. [209.85.192.172])
        by mx.google.com with ESMTPS id f3si2246317pas.51.2015.02.04.05.32.38
        for <akpm@linux-foundation.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Feb 2015 05:32:39 -0800 (PST)
Received-SPF: pass (google.com: domain of konishi.ryusuke@gmail.com designates 209.85.192.172 as permitted sender) client-ip=209.85.192.172;
Authentication-Results: mx.google.com;
       spf=pass (google.com: domain of konishi.ryusuke@gmail.com designates 209.85.192.172 as permitted sender) smtp.mail=konishi.ryusuke@gmail.com;
       dkim=pass header.i=@gmail.com
Received: by pdbft15 with SMTP id ft15so726762pdb.11
        for <akpm@linux-foundation.org>; Wed, 04 Feb 2015 05:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :lines;
        bh=S7h9kDubxxx3xEO44+527EA0fTScAol0QujzWGFYyGU=;
        b=Bsx7MeQgysQi0fr6Av8doQ1993+yft+EusYPN+VkFjhEQEUAR1JRL9b2G1PXhmhA9I
         +IOQaT8hY2MlvN/AwggMbDsFQWeeLBWkAzmmGH07CaZx8Ln6bmqTdghrgghzvqtBzizM
         kgMS8nPH/uhA9LOuNXql/R6hTQWt8Pbj7ykw70uAERU+/aFKP93pzfuBMTGBvrJUJOqx
         w8nF6EmLNYbCdogO21oU3CFIQl+fSBPQYDfgMENp99QrEZPmuWqSoRXy/A20feznhUkh
         3mV6XO3kvI7CdlM+bRvj/MIq7x5vOi2isKqV20JfLjh/NEsj0rcnz9RzREX8k49fd4kz
         9E1A==
X-Received: by 10.66.65.108 with SMTP id w12mr46253257pas.115.1423056758727;
        Wed, 04 Feb 2015 05:32:38 -0800 (PST)
Received: from mx.localdomain (i60-34-193-209.s42.a014.ap.plala.or.jp. [60.34.193.209])
        by mx.google.com with ESMTPSA id s7sm2107162pdj.22.2015.02.04.05.32.36
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Feb 2015 05:32:37 -0800 (PST)
Sender: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Received: from localhost (localhost [127.0.0.1])
	by mx.localdomain (Postfix) with ESMTP id 9AD1A83CDAC6;
	Wed,  4 Feb 2015 22:32:29 +0900 (JST)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-nilfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: fix deadlock of segment constructor over I_SYNC flag
Date: Wed,  4 Feb 2015 22:26:23 +0900
Message-Id: <1423056383-24247-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1423056383-24247-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1423056383-24247-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Dispatcher: imput version 20110525(IM151)
Lines: 217
Delivered-To: akpm@linux-foundation.org

Nilfs2 eventually hangs in a stress test with fsstress program.
This issue was caused by the following deadlock over I_SYNC flag
between nilfs_segctor_thread() and writeback_sb_inodes():

  nilfs_segctor_thread()
    nilfs_segctor_thread_construct()
      nilfs_segctor_unlock()
        nilfs_dispose_list()
          iput()
            iput_final()
              evict()
                inode_wait_for_writeback()  * wait for I_SYNC flag

  writeback_sb_inodes()
     * set I_SYNC flag on inode->i_state
    __writeback_single_inode()
      do_writepages()
        nilfs_writepages()
          nilfs_construct_dsync_segment()
            nilfs_segctor_sync()
               * wait for completion of segment constructor
    inode_sync_complete()
       * clear I_SYNC flag after __writeback_single_inode() completed

writeback_sb_inodes() calls do_writepages() for dirty inodes after
setting I_SYNC flag on inode->i_state.  do_writepages() calls
nilfs_writepages(), which can run segment constructor and wait for its
completion.  On the other hand, segment constructor calls iput(),
which can call evict() and wait for the I_SYNC flag on
inode_wait_for_writeback().

Since segment constructor doesn't know when I_SYNC will be set, it
cannot know whether iput() will block or not unless inode->i_nlink has
a non-zero count.  We can prevent evict() from being called in iput()
by implementing sop->drop_inode(), but it's not preferable to leave
inodes with i_nlink == 0 for long periods because it even defers file
truncation and inode deallocation.  So, this instead resolves the
deadlock by calling iput() asynchronously with a workqueue for inodes
with i_nlink == 0.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: stable@vger.kernel.org
---
 fs/nilfs2/nilfs.h   |  2 --
 fs/nilfs2/segment.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 fs/nilfs2/segment.h |  5 +++++
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 91093cd..3857040 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -141,7 +141,6 @@ enum {
  * @ti_save: Backup of journal_info field of task_struct
  * @ti_flags: Flags
  * @ti_count: Nest level
- * @ti_garbage:	List of inode to be put when releasing semaphore
  */
 struct nilfs_transaction_info {
 	u32			ti_magic;
@@ -150,7 +149,6 @@ struct nilfs_transaction_info {
 				   one of other filesystems has a bug. */
 	unsigned short		ti_flags;
 	unsigned short		ti_count;
-	struct list_head	ti_garbage;
 };
 
 /* ti_magic */
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 7ef18fc..469086b 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -305,7 +305,6 @@ static void nilfs_transaction_lock(struct super_block *sb,
 	ti->ti_count = 0;
 	ti->ti_save = cur_ti;
 	ti->ti_magic = NILFS_TI_MAGIC;
-	INIT_LIST_HEAD(&ti->ti_garbage);
 	current->journal_info = ti;
 
 	for (;;) {
@@ -332,8 +331,6 @@ static void nilfs_transaction_unlock(struct super_block *sb)
 
 	up_write(&nilfs->ns_segctor_sem);
 	current->journal_info = ti->ti_save;
-	if (!list_empty(&ti->ti_garbage))
-		nilfs_dispose_list(nilfs, &ti->ti_garbage, 0);
 }
 
 static void *nilfs_segctor_map_segsum_entry(struct nilfs_sc_info *sci,
@@ -746,6 +743,15 @@ static void nilfs_dispose_list(struct the_nilfs *nilfs,
 	}
 }
 
+static void nilfs_iput_work_func(struct work_struct *work)
+{
+	struct nilfs_sc_info *sci = container_of(work, struct nilfs_sc_info,
+						 sc_iput_work);
+	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
+
+	nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 0);
+}
+
 static int nilfs_test_metadata_dirty(struct the_nilfs *nilfs,
 				     struct nilfs_root *root)
 {
@@ -1900,8 +1906,8 @@ static int nilfs_segctor_collect_dirty_files(struct nilfs_sc_info *sci,
 static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 					     struct the_nilfs *nilfs)
 {
-	struct nilfs_transaction_info *ti = current->journal_info;
 	struct nilfs_inode_info *ii, *n;
+	int defer_iput = false;
 
 	spin_lock(&nilfs->ns_inode_lock);
 	list_for_each_entry_safe(ii, n, &sci->sc_dirty_files, i_dirty) {
@@ -1912,9 +1918,24 @@ static void nilfs_segctor_drop_written_files(struct nilfs_sc_info *sci,
 		clear_bit(NILFS_I_BUSY, &ii->i_state);
 		brelse(ii->i_bh);
 		ii->i_bh = NULL;
-		list_move_tail(&ii->i_dirty, &ti->ti_garbage);
+		list_del_init(&ii->i_dirty);
+		if (!ii->vfs_inode.i_nlink) {
+			/*
+			 * Defer calling iput() to avoid a deadlock
+			 * over I_SYNC flag for inodes with i_nlink == 0
+			 */
+			list_add_tail(&ii->i_dirty, &sci->sc_iput_queue);
+			defer_iput = true;
+		} else {
+			spin_unlock(&nilfs->ns_inode_lock);
+			iput(&ii->vfs_inode);
+			spin_lock(&nilfs->ns_inode_lock);
+		}
 	}
 	spin_unlock(&nilfs->ns_inode_lock);
+
+	if (defer_iput)
+		schedule_work(&sci->sc_iput_work);
 }
 
 /*
@@ -2583,6 +2604,8 @@ static struct nilfs_sc_info *nilfs_segctor_new(struct super_block *sb,
 	INIT_LIST_HEAD(&sci->sc_segbufs);
 	INIT_LIST_HEAD(&sci->sc_write_logs);
 	INIT_LIST_HEAD(&sci->sc_gc_inodes);
+	INIT_LIST_HEAD(&sci->sc_iput_queue);
+	INIT_WORK(&sci->sc_iput_work, nilfs_iput_work_func);
 	init_timer(&sci->sc_timer);
 
 	sci->sc_interval = HZ * NILFS_SC_DEFAULT_TIMEOUT;
@@ -2609,6 +2632,8 @@ static void nilfs_segctor_write_out(struct nilfs_sc_info *sci)
 		ret = nilfs_segctor_construct(sci, SC_LSEG_SR);
 		nilfs_transaction_unlock(sci->sc_super);
 
+		flush_work(&sci->sc_iput_work);
+
 	} while (ret && retrycount-- > 0);
 }
 
@@ -2633,6 +2658,9 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		|| sci->sc_seq_request != sci->sc_seq_done);
 	spin_unlock(&sci->sc_state_lock);
 
+	if (flush_work(&sci->sc_iput_work))
+		flag = true;
+
 	if (flag || !nilfs_segctor_confirm(sci))
 		nilfs_segctor_write_out(sci);
 
@@ -2642,6 +2670,12 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 		nilfs_dispose_list(nilfs, &sci->sc_dirty_files, 1);
 	}
 
+	if (!list_empty(&sci->sc_iput_queue)) {
+		nilfs_warning(sci->sc_super, __func__,
+			      "iput queue is not empty\n");
+		nilfs_dispose_list(nilfs, &sci->sc_iput_queue, 1);
+	}
+
 	WARN_ON(!list_empty(&sci->sc_segbufs));
 	WARN_ON(!list_empty(&sci->sc_write_logs));
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 38a1d00..a48d6de 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/workqueue.h>
 #include <linux/nilfs2_fs.h>
 #include "nilfs.h"
 
@@ -92,6 +93,8 @@ struct nilfs_segsum_pointer {
  * @sc_nblk_inc: Block count of current generation
  * @sc_dirty_files: List of files to be written
  * @sc_gc_inodes: List of GC inodes having blocks to be written
+ * @sc_iput_queue: list of inodes for which iput should be done
+ * @sc_iput_work: work struct to defer iput call
  * @sc_freesegs: array of segment numbers to be freed
  * @sc_nfreesegs: number of segments on @sc_freesegs
  * @sc_dsync_inode: inode whose data pages are written for a sync operation
@@ -135,6 +138,8 @@ struct nilfs_sc_info {
 
 	struct list_head	sc_dirty_files;
 	struct list_head	sc_gc_inodes;
+	struct list_head	sc_iput_queue;
+	struct work_struct	sc_iput_work;
 
 	__u64		       *sc_freesegs;
 	size_t			sc_nfreesegs;
-- 
1.8.3.1

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-deadlock-of-segment-constructor-over-i_sync-flag.patch
linux-next.patch

