Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B58C433DB
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 21:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E06260C41
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 21:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbhBIVuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 16:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhBIVHv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Feb 2021 16:07:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06BA264EC4;
        Tue,  9 Feb 2021 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612898052;
        bh=NEmkFrCRflqU+dfjfnsiuhIAmr1jdsmq749nchR3yoM=;
        h=Date:From:To:Subject:From;
        b=HPpIvJ/TeAAMpzpPFHWx07pFFnpQjSvZvxn9WTuPu1Q6ZyP6PsjC3nGtca3yS3bqj
         iipgOPC+C+CrP6PF3xfe8aEGGEA7YGOn5qFVS5C29x8JQVT3e8IXMJ/Z80cURBbgEA
         KX2xZopYZUG7vgy+2E0gDVZlzT2meUxZZtNFOQRg=
Date:   Tue, 09 Feb 2021 11:14:11 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com
Subject:  + fs-buffer-use-raw-page_memcg-on-locked-page.patch added
 to -mm tree
Message-ID: <20210209191411.2ynO-Ocbj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: buffer: use raw page_memcg() on locked page
has been added to the -mm tree.  Its filename is
     fs-buffer-use-raw-page_memcg-on-locked-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-buffer-use-raw-page_memcg-on-locked-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-buffer-use-raw-page_memcg-on-locked-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

revert-mm-memcontrol-avoid-workload-stalls-when-lowering-memoryhigh.patch
fs-buffer-use-raw-page_memcg-on-locked-page.patch
mm-vmstat-fix-nohz-wakeups-for-node-stat-changes.patch
mm-vmstat-add-some-comments-on-internal-storage-of-byte-items.patch

