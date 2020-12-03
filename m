Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC77C4361A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C82A221F4
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 20:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgLCUxM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgLCUxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 15:53:12 -0500
Date:   Thu, 03 Dec 2020 12:52:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607028751;
        bh=SVgCNT0eFBEO9LlFM9FAEsRrRFEBUnM6lNmjGWU/LlA=;
        h=From:To:Subject:From;
        b=XNS1N2m1OKkziqjXwIg88lSsDrK8il5xHV7mAWCx8d33zWEHlpGYLB5SblaRjYMJB
         fOw2I+6Vo+3VIiMHazqe3nkuWL+q08A+Ulm2lx0buGU42+DQV9cly9SysbBC/5K1Jb
         LtvXKYAPJssi6HwXeXoKduJvEq02tMdSHxnkv9HI=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vbabka@suse.cz
Subject:  [nacked]
 mm-page_alloc-speeding-up-the-iteration-of-max_order.patch removed from -mm
 tree
Message-ID: <20201203205230.CdOI0QUFH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: speed up the iteration of max_order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-speeding-up-the-iteration-of-max_order.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/page_alloc: speed up the iteration of max_order

When we free a page whose order is very close to MAX_ORDER and greater
than pageblock_order, it wastes some CPU cycles to increase max_order to
MAX_ORDER one by one and check the pageblock migratetype of that page
repeatedly especially when MAX_ORDER is much larger than pageblock_order.

Link: https://lkml.kernel.org/r/20201202121838.75218-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-speeding-up-the-iteration-of-max_order
+++ a/mm/page_alloc.c
@@ -1035,7 +1035,7 @@ continue_merging:
 		pfn = combined_pfn;
 		order++;
 	}
-	if (max_order < MAX_ORDER) {
+	if (max_order < MAX_ORDER && order < MAX_ORDER - 1) {
 		/* If we are here, it means order is >= pageblock_order.
 		 * We want to prevent merge between freepages on isolate
 		 * pageblock and normal pageblock. Without this, pageblock
@@ -1056,6 +1056,8 @@ continue_merging:
 						is_migrate_isolate(buddy_mt)))
 				goto done_merging;
 		}
+		if (unlikely(order != max_order - 1))
+			max_order = order + 1;
 		max_order++;
 		goto continue_merging;
 	}
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-unused-mod_memcg_obj_state.patch
mm-memcg-slab-fix-return-child-memcg-objcg-for-root-memcg.patch
mm-memcg-slab-fix-use-after-free-in-obj_cgroup_charge.patch
mm-memcg-slab-rename-_lruvec_slab_state-to-_lruvec_kmem_state.patch
mm-page_isolation-do-not-isolate-the-max-order-page.patch

