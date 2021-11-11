Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C683C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03A066187A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhKKCoX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234019AbhKKCoV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:44:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7839161354;
        Thu, 11 Nov 2021 02:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598493;
        bh=u3x4Kj95ZV7clFU5N9qYvcz5ZlZtxxiDQLKTy3SCWts=;
        h=Date:From:To:Subject:From;
        b=aaSIGefIQSQFy/ZxEKgbzn1Hk6Mv93GpnfdQNGiv52ueg6lJ/OcXiImcv5H2ju9ur
         HwYEWlVCDCCz/W7PlWaHglWR60QeCQq/GndeXHWxG/3b2lcMBdhVu57B6b7YZJdj8T
         3wpWjV6bnsQ8b852PKy3SU3Tq6GUBfdnDUnI9mFI=
Date:   Wed, 10 Nov 2021 18:41:33 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  [merged] mm-simplify-bdi-refcounting.patch removed from
 -mm tree
Message-ID: <20211111024133.IsKp38a5U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify bdi refcounting
has been removed from the -mm tree.  Its filename was
     mm-simplify-bdi-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: simplify bdi refcounting

Move grabbing and releasing the bdi refcount out of the common
wb_init/wb_exit helpers into code that is only used for the non-default
memcg driven bdi_writeback structures.

[hch@lst.de: add comment]
  Link: https://lkml.kernel.org/r/20211027074207.GA12793@lst.de
[akpm@linux-foundation.org: fix typo]
Link: https://lkml.kernel.org/r/20211021124441.668816-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    3 +++
 mm/backing-dev.c                 |   13 +++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/backing-dev-defs.h~mm-simplify-bdi-refcounting
+++ a/include/linux/backing-dev-defs.h
@@ -103,6 +103,9 @@ struct wb_completion {
  * change as blkcg is disabled and enabled higher up in the hierarchy, a wb
  * is tested for blkcg after lookup and removed from index on mismatch so
  * that a new wb for the combination can be created.
+ *
+ * Each bdi_writeback that is not embedded into the backing_dev_info must hold
+ * a reference to the parent backing_dev_info.  See cgwb_create() for details.
  */
 struct bdi_writeback {
 	struct backing_dev_info *bdi;	/* our parent bdi */
--- a/mm/backing-dev.c~mm-simplify-bdi-refcounting
+++ a/mm/backing-dev.c
@@ -291,8 +291,6 @@ static int wb_init(struct bdi_writeback
 
 	memset(wb, 0, sizeof(*wb));
 
-	if (wb != &bdi->wb)
-		bdi_get(bdi);
 	wb->bdi = bdi;
 	wb->last_old_flush = jiffies;
 	INIT_LIST_HEAD(&wb->b_dirty);
@@ -316,7 +314,7 @@ static int wb_init(struct bdi_writeback
 
 	err = fprop_local_init_percpu(&wb->completions, gfp);
 	if (err)
-		goto out_put_bdi;
+		return err;
 
 	for (i = 0; i < NR_WB_STAT_ITEMS; i++) {
 		err = percpu_counter_init(&wb->stat[i], 0, gfp);
@@ -330,9 +328,6 @@ out_destroy_stat:
 	while (i--)
 		percpu_counter_destroy(&wb->stat[i]);
 	fprop_local_destroy_percpu(&wb->completions);
-out_put_bdi:
-	if (wb != &bdi->wb)
-		bdi_put(bdi);
 	return err;
 }
 
@@ -373,8 +368,6 @@ static void wb_exit(struct bdi_writeback
 		percpu_counter_destroy(&wb->stat[i]);
 
 	fprop_local_destroy_percpu(&wb->completions);
-	if (wb != &wb->bdi->wb)
-		bdi_put(wb->bdi);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -397,6 +390,7 @@ static void cgwb_release_workfn(struct w
 	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
 						release_work);
 	struct blkcg *blkcg = css_to_blkcg(wb->blkcg_css);
+	struct backing_dev_info *bdi = wb->bdi;
 
 	mutex_lock(&wb->bdi->cgwb_release_mutex);
 	wb_shutdown(wb);
@@ -416,6 +410,7 @@ static void cgwb_release_workfn(struct w
 
 	percpu_ref_exit(&wb->refcnt);
 	wb_exit(wb);
+	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	kfree_rcu(wb, rcu);
 }
@@ -497,6 +492,7 @@ static int cgwb_create(struct backing_de
 	INIT_LIST_HEAD(&wb->b_attached);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
 	set_bit(WB_registered, &wb->state);
+	bdi_get(bdi);
 
 	/*
 	 * The root wb determines the registered state of the whole bdi and
@@ -528,6 +524,7 @@ static int cgwb_create(struct backing_de
 	goto out_put;
 
 err_fprop_exit:
+	bdi_put(bdi);
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 err_ref_exit:
 	percpu_ref_exit(&wb->refcnt);
_

Patches currently in -mm which might be from hch@lst.de are

mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

