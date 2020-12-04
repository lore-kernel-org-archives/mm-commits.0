Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47091C4361B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EB022D50
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 22:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgLDWzv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Dec 2020 17:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725986AbgLDWzv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Dec 2020 17:55:51 -0500
Date:   Fri, 04 Dec 2020 14:55:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607122510;
        bh=HnGkgxfdz4j974cB8Xbm6D1j/qcU0oWlIR18KtzVbck=;
        h=From:To:Subject:From;
        b=GOZfVWLaa5vVDr/1xYj8DN09l24/4CK135J8+u9Jr4Kkh2R4TvChhYDHg0YvNj4A8
         7iltFrLiQ3kuik2+S+HjH3+RXVvgGxB1t8IdUViEoaqWbmiQsyYtXlmpSxBfnflfuD
         4RWQaJNH2HVAulQiizsAL8vjlNy51/8i9GeMQgic=
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged] mm-introduce-page-memcg-flags.patch removed from
 -mm tree
Message-ID: <20201204225510.LLUxMwTmE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page memcg flags
has been removed from the -mm tree.  Its filename was
     mm-introduce-page-memcg-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: introduce page memcg flags

The lowest bit in page->memcg_data is used to distinguish between struct
memory_cgroup pointer and a pointer to a objcgs array.  All checks and
modifications of this bit are open-coded.

Let's formalize it using page memcg flags, defined in enum
page_memcg_data_flags.

Additional flags might be added later.

Link: https://lkml.kernel.org/r/20201027001657.3398190-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-introduce-page-memcg-flags
+++ a/include/linux/memcontrol.h
@@ -337,6 +337,15 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+enum page_memcg_data_flags {
+	/* page->memcg_data is a pointer to an objcgs vector */
+	MEMCG_DATA_OBJCGS = (1UL << 0),
+	/* the next bit after the last actual flag */
+	__NR_MEMCG_DATA_FLAGS  = (1UL << 1),
+};
+
+#define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
+
 /*
  * page_memcg - get the memory cgroup associated with a page
  * @page: a pointer to the page struct
@@ -398,13 +407,7 @@ static inline struct mem_cgroup *page_me
 	 */
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
-	/*
-	 * The lowest bit set means that memcg isn't a valid
-	 * memcg pointer, but a obj_cgroups pointer.
-	 * In this case the page is shared and doesn't belong
-	 * to any specific memory cgroup.
-	 */
-	if (memcg_data & 0x1UL)
+	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
 	return (struct mem_cgroup *)memcg_data;
@@ -423,7 +426,11 @@ static inline struct mem_cgroup *page_me
  */
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
-	return (struct obj_cgroup **)(READ_ONCE(page->memcg_data) & ~0x1UL);
+	unsigned long memcg_data = READ_ONCE(page->memcg_data);
+
+	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -438,10 +445,10 @@ static inline struct obj_cgroup **page_o
 {
 	unsigned long memcg_data = READ_ONCE(page->memcg_data);
 
-	if (memcg_data && (memcg_data & 0x1UL))
-		return (struct obj_cgroup **)(memcg_data & ~0x1UL);
+	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
+		return NULL;
 
-	return NULL;
+	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
 /*
@@ -454,7 +461,8 @@ static inline struct obj_cgroup **page_o
 static inline bool set_page_objcgs(struct page *page,
 					struct obj_cgroup **objcgs)
 {
-	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs | 0x1UL);
+	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs |
+			MEMCG_DATA_OBJCGS);
 }
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-fix-obj_cgroup_charge-return-value-handling.patch
mm-memcg-fix-obsolete-code-comments.patch
mm-memcg-deprecate-the-non-hierarchical-mode.patch
docs-cgroup-v1-reflect-the-deprecation-of-the-non-hierarchical-mode.patch
cgroup-remove-obsoleted-broken_hierarchy-and-warned_broken_hierarchy.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch
mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-v2.patch

