Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B19C56201
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF2E820809
	for <mm-commits@archiver.kernel.org>; Tue, 10 Nov 2020 21:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cbvl626R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgKJVjD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731955AbgKJVhb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Nov 2020 16:37:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01AEE20781;
        Tue, 10 Nov 2020 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605044250;
        bh=1HmP0MsVyZSBFZ9VbzYo0GhbjsBBMmLN8SbyvuYNad8=;
        h=Date:From:To:Subject:From;
        b=Cbvl626R36CVczCLk3BPqXl7PzzGTl4KAI6bdDgTC0Iwwln/+l6aMjV3hawmJM5uz
         lu0lrTHf/P8X816mvfGWEwtRx6G8bIW1A13uPcZ7YalGEaxeqkcM55xtEK9TrCpVBH
         YlDQlDl1G4ghujvBx7FfvG6bfZHlQZYG2dNrk0ak=
Date:   Tue, 10 Nov 2020 13:37:29 -0800
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        sh_def@163.com, shakeelb@google.com, vdavydov.dev@gmail.com
Subject:  + mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch
 added to -mm tree
Message-ID: <20201110213729.3_XCUtrrY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol:rewrite mem_cgroup_page_lruvec()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/memcontrol:rewrite mem_cgroup_page_lruvec()

mem_cgroup_page_lruvec() in memcontrol.c and mem_cgroup_lruvec() in
memcontrol.h is very similar except for the param(page and memcg) which
also can be convert to each other.

So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().

Link: https://lkml.kernel.org/r/20201108143731.GA74138@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   16 +++++++++++++--
 mm/memcontrol.c            |   37 -----------------------------------
 2 files changed, 14 insertions(+), 39 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-rewrite-mem_cgroup_page_lruvec
+++ a/include/linux/memcontrol.h
@@ -631,9 +631,10 @@ mem_cgroup_nodeinfo(struct mem_cgroup *m
 /**
  * mem_cgroup_lruvec - get the lru list vector for a memcg & node
  * @memcg: memcg of the wanted lruvec
+ * @pgdat: pglist_data
  *
  * Returns the lru list vector holding pages for a given @memcg &
- * @node combination. This can be the node lruvec, if the memory
+ * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
 static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
@@ -663,7 +664,18 @@ out:
 	return lruvec;
 }
 
-struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
+/**
+ * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
+ * @page: the page
+ * @pgdat: pgdat of the page
+ *
+ * This function relies on page->mem_cgroup being stable.
+ */
+static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
+						struct pglist_data *pgdat)
+{
+	return mem_cgroup_lruvec(page_memcg(page), pgdat);
+}
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-mem_cgroup_page_lruvec
+++ a/mm/memcontrol.c
@@ -1311,43 +1311,6 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 }
 
 /**
- * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
- * @page: the page
- * @pgdat: pgdat of the page
- *
- * This function relies on page's memcg being stable - see the
- * access rules in commit_charge().
- */
-struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
-{
-	struct mem_cgroup_per_node *mz;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	if (mem_cgroup_disabled()) {
-		lruvec = &pgdat->__lruvec;
-		goto out;
-	}
-
-	memcg = page_memcg(page);
-	VM_WARN_ON_ONCE_PAGE(!memcg, page);
-	if (!memcg)
-		memcg = root_mem_cgroup;
-
-	mz = mem_cgroup_page_nodeinfo(memcg, page);
-	lruvec = &mz->lruvec;
-out:
-	/*
-	 * Since a node can be onlined after the mem_cgroup was created,
-	 * we have to be prepared to initialize lruvec->zone here;
-	 * and if offlined then reonlined, we need to reinitialize it.
-	 */
-	if (unlikely(lruvec->pgdat != pgdat))
-		lruvec->pgdat = pgdat;
-	return lruvec;
-}
-
-/**
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
_

Patches currently in -mm which might be from sh_def@163.com are

mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch
mm-hugetlbc-just-use-put_page_testzero-instead-of-page_count.patch
mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch
acctc-use-elif-instead-of-end-and-elif.patch

