Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA62C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEDA064F14
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhBXUGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhBXUFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A5B364F08;
        Wed, 24 Feb 2021 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197056;
        bh=qpY4DySb6Qdg0r072i2zKud5TA2ga17Nkt0ocrLYpx4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PosR8Gnp70bvAUnt3yMyiJSKJ7/KDjCL+wpzAfG7mzl13WMpvDlK2XKh5k5Oa55Fj
         y7f+hCESUIeE+Rr1P9rClfevjxPgXMlw4ONI08oqV/1Jix3ZQ889mynw2d7MsStHiP
         hznNLx0MPNvRRtp8+M7mhOSdznGfP5sEqL8SPi4A=
Date:   Wed, 24 Feb 2021 12:04:15 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com,
        torvalds@linux-foundation.org
Subject:  [patch 072/173] fs: buffer: use raw page_memcg() on
 locked page
Message-ID: <20210224200415.uBhXwogkS%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: buffer: use raw page_memcg() on locked page

alloc_page_buffers() currently uses get_mem_cgroup_from_page() for
charging the buffers to the page owner, which does an rcu-protected
page->memcg lookup and acquires a reference.  But buffer allocation has
the page lock held throughout, which pins the page to the memcg and
thereby the memcg - neither rcu nor holding an extra reference during the
allocation are necessary.  Use a raw page_memcg() instead.

This was the last user of get_mem_cgroup_from_page(), delete it.

Link: https://lkml.kernel.org/r/20210209190126.97842-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                |    4 ++--
 include/linux/memcontrol.h |    7 -------
 mm/memcontrol.c            |   23 -----------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

--- a/fs/buffer.c~fs-buffer-use-raw-page_memcg-on-locked-page
+++ a/fs/buffer.c
@@ -847,7 +847,8 @@ struct buffer_head *alloc_page_buffers(s
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
-	memcg = get_mem_cgroup_from_page(page);
+	/* The page lock pins the memcg */
+	memcg = page_memcg(page);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -868,7 +869,6 @@ struct buffer_head *alloc_page_buffers(s
 	}
 out:
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
--- a/include/linux/memcontrol.h~fs-buffer-use-raw-page_memcg-on-locked-page
+++ a/include/linux/memcontrol.h
@@ -680,8 +680,6 @@ struct mem_cgroup *mem_cgroup_from_task(
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
-struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
-
 struct lruvec *lock_page_lruvec(struct page *page);
 struct lruvec *lock_page_lruvec_irq(struct page *page);
 struct lruvec *lock_page_lruvec_irqsave(struct page *page,
@@ -1190,11 +1188,6 @@ static inline struct mem_cgroup *get_mem
 {
 	return NULL;
 }
-
-static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
-{
-	return NULL;
-}
 
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
--- a/mm/memcontrol.c~fs-buffer-use-raw-page_memcg-on-locked-page
+++ a/mm/memcontrol.c
@@ -1047,29 +1047,6 @@ struct mem_cgroup *get_mem_cgroup_from_m
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-/**
- * get_mem_cgroup_from_page: Obtain a reference on given page's memcg.
- * @page: page from which memcg should be extracted.
- *
- * Obtain a reference on page->memcg and returns it if successful. Otherwise
- * root_mem_cgroup is returned.
- */
-struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	rcu_read_lock();
-	/* Page should not get uncharged and freed memcg under us. */
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
-	rcu_read_unlock();
-	return memcg;
-}
-EXPORT_SYMBOL(get_mem_cgroup_from_page);
-
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
 	if (in_interrupt())
_
