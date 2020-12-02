Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56DBC6369E
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C07206E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Dec 2020 23:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgLBXVQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:21:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgLBXVQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 2 Dec 2020 18:21:16 -0500
Date:   Wed, 02 Dec 2020 15:20:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606951235;
        bh=6u95MvBAwmOmocX9mCE9JMUuC5DBcGNL95mDKEfuhUE=;
        h=From:To:Subject:From;
        b=UmG/4aWEfmgWUm5m5g7Sw5ySOVG99JtFg3qCIihpkKK3h7n+RY/jZQUR7PQnquR5r
         xK7e2uPu6er93wHH2hLO1lUi1zWp+gQVYkxdKCkPKwwSDcswrOy4831xBsIWnv46/d
         mTTDhkwFAyanvaXX5mkMLf2io9Q1mue3BYoyCzik=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-page_isolation-do-not-isolate-the-max-order-page.patch added to -mm tree
Message-ID: <20201202232034.N6dVQN7tb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: do not isolate the max order page
has been added to the -mm tree.  Its filename is
     mm-page_isolation-do-not-isolate-the-max-order-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-do-not-isolate-the-max-order-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-do-not-isolate-the-max-order-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_isolation: do not isolate the max order page

A max order page has no buddy page and never merges to another order.  So
isolating and then freeing it is pointless.

Link: https://lkml.kernel.org/r/20201202122114.75316-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_isolation.c~mm-page_isolation-do-not-isolate-the-max-order-page
+++ a/mm/page_isolation.c
@@ -88,7 +88,7 @@ static void unset_migratetype_isolate(st
 	 */
 	if (PageBuddy(page)) {
 		order = buddy_order(page);
-		if (order >= pageblock_order) {
+		if (order >= pageblock_order && order < MAX_ORDER - 1) {
 			pfn = page_to_pfn(page);
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch
mm-page_isolation-do-not-isolate-the-max-order-page.patch

