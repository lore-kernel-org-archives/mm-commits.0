Return-Path: <SRS0=LO12=EO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFD7C388F9
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 00:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC89208FE
	for <mm-commits@archiver.kernel.org>; Sun,  8 Nov 2020 00:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604796309;
	bh=sDvbwvf1fMuhM8Rxqt7siEsuhnRbZWUY68dG2sNF5K0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NHap/+/6+JsYIkuY4SL+Qui7PtpMDmvBVJmSFHguHoCo35WU8dR/XchHHwvy6R4vC
	 N1WaLqBnXpbTSZnn2+MEJ+RN2X2wM9eu8PGmZCyU0OKITm7fqhXGs708qvmwpO1DH4
	 GcM2V94IPFrW9suifwUCQzt5sMC7ye/mAoEIEpkQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKHApI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 Nov 2020 19:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgKHApI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Nov 2020 19:45:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B382020702;
        Sun,  8 Nov 2020 00:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604796307;
        bh=sDvbwvf1fMuhM8Rxqt7siEsuhnRbZWUY68dG2sNF5K0=;
        h=Date:From:To:Subject:From;
        b=X7K0PpWGzIuCDzuzyg99Ljn7mWPNxhI27cNFVSpe7O+kvgvlTed4O08+3k+XjH8vi
         ZMOfhntcdLRSJgWcWsVIrgCbWVm8q0uOFE4RUWekPr14VPbOnZ0RTCtmICx5a9I5XZ
         E/6l8ON8GOMLiRJPXGVq25yuv4lF1lT6MYD0+1Zw=
Date:   Sat, 07 Nov 2020 16:45:07 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, richard.weiyang@gmail.com,
        shakeelb@google.com
Subject:  + mm-memcg-remove-unused-definitions.patch added to -mm
 tree
Message-ID: <20201108004507.F2bSdsImG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: remove unused definitions
has been added to the -mm tree.  Its filename is
     mm-memcg-remove-unused-definitions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-remove-unused-definitions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-remove-unused-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/memcg: remove unused definitions

Some definitions are left unused, just clean them.

Link: https://lkml.kernel.org/r/20201108003834.12669-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |  118 -----------------------------------
 1 file changed, 118 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-remove-unused-definitions
+++ a/include/linux/memcontrol.h
@@ -892,41 +892,6 @@ static inline void mod_memcg_state(struc
 	local_irq_restore(flags);
 }
 
-/**
- * mod_memcg_page_state - update page state statistics
- * @page: the page
- * @idx: page state item to account
- * @val: number of pages (positive or negative)
- *
- * The @page must be locked or the caller must use lock_page_memcg()
- * to prevent double accounting when the page is concurrently being
- * moved to another memcg:
- *
- *   lock_page(page) or lock_page_memcg(page)
- *   if (TestClearPageState(page))
- *     mod_memcg_page_state(page, state, -1);
- *   unlock_page(page) or unlock_page_memcg(page)
- *
- * Kernel pages are an exception to this, since they'll never move.
- */
-static inline void __mod_memcg_page_state(struct page *page,
-					  int idx, int val)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		__mod_memcg_state(memcg, idx, val);
-}
-
-static inline void mod_memcg_page_state(struct page *page,
-					int idx, int val)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		mod_memcg_state(memcg, idx, val);
-}
-
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
@@ -1381,18 +1346,6 @@ static inline void mod_memcg_state(struc
 {
 }
 
-static inline void __mod_memcg_page_state(struct page *page,
-					  int idx,
-					  int nr)
-{
-}
-
-static inline void mod_memcg_page_state(struct page *page,
-					int idx,
-					int nr)
-{
-}
-
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
@@ -1485,34 +1438,6 @@ void count_memcg_event_mm(struct mm_stru
 }
 #endif /* CONFIG_MEMCG */
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __inc_memcg_state(struct mem_cgroup *memcg,
-				     int idx)
-{
-	__mod_memcg_state(memcg, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __dec_memcg_state(struct mem_cgroup *memcg,
-				     int idx)
-{
-	__mod_memcg_state(memcg, idx, -1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __inc_memcg_page_state(struct page *page,
-					  int idx)
-{
-	__mod_memcg_page_state(page, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void __dec_memcg_page_state(struct page *page,
-					  int idx)
-{
-	__mod_memcg_page_state(page, idx, -1);
-}
-
 static inline void __inc_lruvec_state(struct lruvec *lruvec,
 				      enum node_stat_item idx)
 {
@@ -1547,34 +1472,6 @@ static inline void __dec_lruvec_slab_sta
 	__mod_lruvec_slab_state(p, idx, -1);
 }
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void inc_memcg_state(struct mem_cgroup *memcg,
-				   int idx)
-{
-	mod_memcg_state(memcg, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void dec_memcg_state(struct mem_cgroup *memcg,
-				   int idx)
-{
-	mod_memcg_state(memcg, idx, -1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void inc_memcg_page_state(struct page *page,
-					int idx)
-{
-	mod_memcg_page_state(page, idx, 1);
-}
-
-/* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void dec_memcg_page_state(struct page *page,
-					int idx)
-{
-	mod_memcg_page_state(page, idx, -1);
-}
-
 static inline void inc_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx)
 {
@@ -1743,21 +1640,6 @@ static inline void memcg_kmem_uncharge_p
 		__memcg_kmem_uncharge_page(page, order);
 }
 
-static inline int memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-				    unsigned int nr_pages)
-{
-	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge(memcg, gfp, nr_pages);
-	return 0;
-}
-
-static inline void memcg_kmem_uncharge(struct mem_cgroup *memcg,
-				       unsigned int nr_pages)
-{
-	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge(memcg, nr_pages);
-}
-
 /*
  * helper for accessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-memcg-remove-unused-definitions.patch

