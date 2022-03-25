Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1500C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357319AbiCYBbU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345861AbiCYBbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F24228E2D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6DB61923
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66217C340ED;
        Fri, 25 Mar 2022 01:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171781;
        bh=zOz6QijkeCdJr8fArXLU9diC1tp6S4Gpwf5Iw+MS+sc=;
        h=Date:To:From:Subject:From;
        b=pp+GpA6ZF7aym4RcsPjCggUuJ7+a4C38Q2Ny3ER0HtQE9kiHJh8DQu+rMdaXHAJuH
         8SeNe1Vu0+u15UeWyIOt5jCNE89lvmtXffQmqbiAcgLvXMpB1tIAXNvBBdwONKdA+P
         At7EemdpoZQQH/9Ldo4cN8T7UhlgkGrdPcpfWxNA=
Date:   Thu, 24 Mar 2022 18:29:40 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, joseph.qi@linux.alibaba.com,
        jlbec@evilplan.org, ghe@suse.com, gechangwei@live.cn,
        hongnan.li@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-ocfs2-fix-comments-mentioning-i_mutex.patch removed from -mm tree
Message-Id: <20220325012941.66217C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2: fix comments mentioning i_mutex
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-fix-comments-mentioning-i_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: hongnanli <hongnan.li@linux.alibaba.com>
Subject: fs/ocfs2: fix comments mentioning i_mutex

inode->i_mutex has been replaced with inode->i_rwsem long ago.  Fix
comments still mentioning i_mutex.

Link: https://lkml.kernel.org/r/20220214031314.100094-1-hongnan.li@linux.alibaba.com
Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c               |    2 +-
 fs/ocfs2/aops.c                |    2 +-
 fs/ocfs2/cluster/nodemanager.c |    2 +-
 fs/ocfs2/dir.c                 |    4 ++--
 fs/ocfs2/file.c                |    4 ++--
 fs/ocfs2/inode.c               |    2 +-
 fs/ocfs2/localalloc.c          |    6 +++---
 fs/ocfs2/namei.c               |    2 +-
 fs/ocfs2/ocfs2.h               |    4 ++--
 fs/ocfs2/quota_global.c        |    2 +-
 fs/ocfs2/xattr.c               |    2 +-
 11 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/ocfs2/alloc.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/alloc.c
@@ -5981,7 +5981,7 @@ bail:
 	return status;
 }
 
-/* Expects you to already be holding tl_inode->i_mutex */
+/* Expects you to already be holding tl_inode->i_rwsem */
 int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 {
 	int status;
--- a/fs/ocfs2/aops.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/aops.c
@@ -2311,7 +2311,7 @@ static int ocfs2_dio_end_io_write(struct
 
 	down_write(&oi->ip_alloc_sem);
 
-	/* Delete orphan before acquire i_mutex. */
+	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
 
--- a/fs/ocfs2/cluster/nodemanager.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -689,7 +689,7 @@ static struct config_group *o2nm_cluster
 	struct o2nm_node_group *ns = NULL;
 	struct config_group *o2hb_group = NULL, *ret = NULL;
 
-	/* this runs under the parent dir's i_mutex; there can be only
+	/* this runs under the parent dir's i_rwsem; there can be only
 	 * one caller in here at a time */
 	if (o2nm_single_cluster)
 		return ERR_PTR(-ENOSPC);
--- a/fs/ocfs2/dir.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/dir.c
@@ -1957,7 +1957,7 @@ bail_nolock:
 }
 
 /*
- * NOTE: this should always be called with parent dir i_mutex taken.
+ * NOTE: this should always be called with parent dir i_rwsem taken.
  */
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
@@ -2003,7 +2003,7 @@ int ocfs2_lookup_ino_from_name(struct in
  * Return 0 if the name does not exist
  * Return -EEXIST if the directory contains the name
  *
- * Callers should have i_mutex + a cluster lock on dir
+ * Callers should have i_rwsem + a cluster lock on dir
  */
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
--- a/fs/ocfs2/file.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/file.c
@@ -270,7 +270,7 @@ int ocfs2_update_inode_atime(struct inod
 
 	/*
 	 * Don't use ocfs2_mark_inode_dirty() here as we don't always
-	 * have i_mutex to guard against concurrent changes to other
+	 * have i_rwsem to guard against concurrent changes to other
 	 * inode fields.
 	 */
 	inode->i_atime = current_time(inode);
@@ -1065,7 +1065,7 @@ static int ocfs2_extend_file(struct inod
 	/*
 	 * The alloc sem blocks people in read/write from reading our
 	 * allocation until we're done changing it. We depend on
-	 * i_mutex to block other extend/truncate calls while we're
+	 * i_rwsem to block other extend/truncate calls while we're
 	 * here.  We even have to hold it for sparse files because there
 	 * might be some tail zeroing.
 	 */
--- a/fs/ocfs2/inode.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/inode.c
@@ -713,7 +713,7 @@ bail:
 /*
  * Serialize with orphan dir recovery. If the process doing
  * recovery on this orphan dir does an iget() with the dir
- * i_mutex held, we'll deadlock here. Instead we detect this
+ * i_rwsem held, we'll deadlock here. Instead we detect this
  * and exit early - recovery will wipe this inode for us.
  */
 static int ocfs2_check_orphan_recovery_state(struct ocfs2_super *osb,
--- a/fs/ocfs2/localalloc.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/localalloc.c
@@ -606,7 +606,7 @@ out:
 
 /*
  * make sure we've got at least bits_wanted contiguous bits in the
- * local alloc. You lose them when you drop i_mutex.
+ * local alloc. You lose them when you drop i_rwsem.
  *
  * We will add ourselves to the transaction passed in, but may start
  * our own in order to shift windows.
@@ -636,7 +636,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 
 	/*
 	 * We must double check state and allocator bits because
-	 * another process may have changed them while holding i_mutex.
+	 * another process may have changed them while holding i_rwsem.
 	 */
 	spin_lock(&osb->osb_lock);
 	if (!ocfs2_la_state_enabled(osb) ||
@@ -1029,7 +1029,7 @@ enum ocfs2_la_event {
 /*
  * Given an event, calculate the size of our next local alloc window.
  *
- * This should always be called under i_mutex of the local alloc inode
+ * This should always be called under i_rwsem of the local alloc inode
  * so that local alloc disabling doesn't race with processes trying to
  * use the allocator.
  *
--- a/fs/ocfs2/namei.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/namei.c
@@ -476,7 +476,7 @@ leave:
 		ocfs2_free_alloc_context(meta_ac);
 
 	/*
-	 * We should call iput after the i_mutex of the bitmap been
+	 * We should call iput after the i_rwsem of the bitmap been
 	 * unlocked in ocfs2_free_alloc_context, or the
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
--- a/fs/ocfs2/ocfs2.h~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/ocfs2.h
@@ -355,7 +355,7 @@ struct ocfs2_super
 	struct delayed_work		la_enable_wq;
 
 	/*
-	 * Must hold local alloc i_mutex and osb->osb_lock to change
+	 * Must hold local alloc i_rwsem and osb->osb_lock to change
 	 * local_alloc_bits. Reads can be done under either lock.
 	 */
 	unsigned int local_alloc_bits;
@@ -430,7 +430,7 @@ struct ocfs2_super
 	atomic_t			osb_tl_disable;
 	/*
 	 * How many clusters in our truncate log.
-	 * It must be protected by osb_tl_inode->i_mutex.
+	 * It must be protected by osb_tl_inode->i_rwsem.
 	 */
 	unsigned int truncated_clusters;
 
--- a/fs/ocfs2/quota_global.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/quota_global.c
@@ -36,7 +36,7 @@
  * should be obeyed by all the functions:
  * - any write of quota structure (either to local or global file) is protected
  *   by dqio_sem or dquot->dq_lock.
- * - any modification of global quota file holds inode cluster lock, i_mutex,
+ * - any modification of global quota file holds inode cluster lock, i_rwsem,
  *   and ip_alloc_sem of the global quota file (achieved by
  *   ocfs2_lock_global_qf). It also has to hold qinfo_lock.
  * - an allocation of new blocks for local quota file is protected by
--- a/fs/ocfs2/xattr.c~fs-ocfs2-fix-comments-mentioning-i_mutex
+++ a/fs/ocfs2/xattr.c
@@ -7205,7 +7205,7 @@ out:
  * Used for reflink a non-preserve-security file.
  *
  * It uses common api like ocfs2_xattr_set, so the caller
- * must not hold any lock expect i_mutex.
+ * must not hold any lock expect i_rwsem.
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,
_

Patches currently in -mm which might be from hongnan.li@linux.alibaba.com are


