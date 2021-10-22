Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9027CC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A0B61440
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhJVDAH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232606AbhJVDAG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:00:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD6E960E96;
        Fri, 22 Oct 2021 02:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634871470;
        bh=DVbU5BevYwvonJxrm1Lla/LpqduAp152WQ9EjEy4hmo=;
        h=Date:From:To:Subject:From;
        b=giLNP6NHy36MWf7f7rtwIsRno+YklH4DRW/qwQz+MwwgHij7KKTdSWWN437iHexmB
         /6A1RUPASFEHuKwd2QXL430+Vxe5rZ6ulX8xU2yZOk43l7+0b/rqqEaHQxzxdimfoo
         Zli62JuE3u9YwK7ZjHf/vXUmsIC9AGJfWlrX1lBs=
Date:   Thu, 21 Oct 2021 19:57:49 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jack@suse.cz, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, richard@nod.at, vigneshr@ti.com
Subject:  + mm-simplify-bdi-refcounting.patch added to -mm tree
Message-ID: <20211022025749.nQvWF4Jbo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify bdi refcounting
has been added to the -mm tree.  Its filename is
     mm-simplify-bdi-refcounting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-bdi-refcounting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-bdi-refcounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: simplify bdi refcounting

Move grabbing and releasing the bdi refcount out of the common
wb_init/wb_exit helpers into code that is only used for the non-default
memcg driven bdi_writeback structures.

Link: https://lkml.kernel.org/r/20211021124441.668816-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

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

mm-dont-include-linux-daxh-in-linux-mempolicyh.patch
mm-export-bdi_unregister.patch
mtd-call-bdi_unregister-explicitly.patch
fs-explicitly-unregister-per-superblock-bdis.patch
mm-dont-automatically-unregister-bdis.patch
mm-simplify-bdi-refcounting.patch
mm-unexport-folio_memcg_unlock.patch
mm-unexport-unlock_page_memcg.patch

