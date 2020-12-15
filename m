Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79193C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 540E2223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgLODP0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgLODMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:50 -0500
Date:   Mon, 14 Dec 2020 19:11:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001893;
        bh=C06etKsndvEsMopugbgO0z1/Z0SXXPpduZErB/5dfno=;
        h=From:To:Subject:In-Reply-To:From;
        b=aNR+vnt+IRyVR9pJ9ytMFddb/E3+nfMzd45jbu8mjtU6q/Fiafh5MJTtQc8h3kbQD
         9ja0losR/EhGZJmLcwn6JVAYrxPYT0aATyZD7zOr9AHxpSMQx4gdKCBSVOXOQppOiJ
         fV/lri5kUFsDhzeEO4YwiAcnvt3qPOeQLkPHuHig=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, torvalds@linux-foundation.org
Subject:  [patch 139/200] mm,hwpoison: take free pages off the
 buddy freelists
Message-ID: <20201215031132.f024gDC4p%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: take free pages off the buddy freelists

The crux of the matter is that historically we left poisoned pages in the
buddy system because we have some checks in place when allocating a page
that are gatekeeper for poisoned pages.  Unfortunately, we do have other
users (e.g: compaction [1]) that scan buddy freelists and try to get a
page from there without checking whether the page is HWPoison.

As I stated already, I think it is fundamentally wrong to keep HWPoison
pages within the buddy systems, checks in place or not.

Let us fix this the same way we did for soft_offline [2], taking the page
off the buddy freelist so it is completely unreachable.

Note that this is fairly simple to trigger, as we only need to poison free
buddy pages (madvise MADV_HWPOISON) and then run some sort of memory
stress system.

Just for a matter of reference, I put a dump_page() in compaction_alloc()
to trigger for HWPoison patches:

kernel: page:0000000012b2982b refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x1d5db
kernel: flags: 0xfffffc0800000(hwpoison)
kernel: raw: 000fffffc0800000 ffffea00007573c8 ffffc90000857de0 0000000000000000
kernel: raw: 0000000000000001 0000000000000000 00000001ffffffff 0000000000000000
kernel: page dumped because: compaction_alloc

kernel: CPU: 4 PID: 123 Comm: kcompactd0 Tainted: G            E     5.9.0-rc2-mm1-1-default+ #5
kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
kernel: Call Trace:
kernel:  dump_stack+0x6d/0x8b
kernel:  compaction_alloc+0xb2/0xc0
kernel:  migrate_pages+0x2a6/0x12a0
kernel:  ? isolate_freepages+0xc80/0xc80
kernel:  ? __ClearPageMovable+0xb0/0xb0
kernel:  compact_zone+0x5eb/0x11c0
kernel:  ? finish_task_switch+0x74/0x300
kernel:  ? lock_timer_base+0xa8/0x170
kernel:  proactive_compact_node+0x89/0xf0
kernel:  ? kcompactd+0x2d0/0x3a0
kernel:  kcompactd+0x2d0/0x3a0
kernel:  ? finish_wait+0x80/0x80
kernel:  ? kcompactd_do_work+0x350/0x350
kernel:  kthread+0x118/0x130
kernel:  ? kthread_associate_blkcg+0xa0/0xa0
kernel:  ret_from_fork+0x22/0x30

After that, if e.g: a process faults in the page,  it will get killed
unexpectedly.
Fix it by containing the page immediatelly.

Besides that, two more changes can be noticed:

* MF_DELAYED no longer suits as we are fixing the issue by containing
  the page immediately, so it does no longer rely on the allocation-time
  checks to stop HWPoison to be handed over.
  gain unless it is unpoisoned, so we fixed the situation.
  Because of that, let us use MF_RECOVERED from now on.

* The second block that handles PageBuddy pages is no longer needed:
  We call shake_page and then check whether the page is Buddy
  because shake_page calls drain_all_pages, which sends pcp-pages back to
  the buddy freelists, so we could have a chance to handle free pages.
  Currently, get_hwpoison_page already calls drain_all_pages, and we call
  get_hwpoison_page right before coming here, so we should be on the safe
  side.

[1] https://lore.kernel.org/linux-mm/20190826104144.GA7849@linux/T/#u
[2] https://patchwork.kernel.org/cover/11792607/

[osalvador@suse.de: take the poisoned subpage off the buddy frelists]
  Link: https://lkml.kernel.org/r/20201013144447.6706-4-osalvador@suse.de
Link: https://lkml.kernel.org/r/20201013144447.6706-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   46 +++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-take-free-pages-off-the-buddy-freelists
+++ a/mm/memory-failure.c
@@ -809,7 +809,7 @@ static int me_swapcache_clean(struct pag
  */
 static int me_huge_page(struct page *p, unsigned long pfn)
 {
-	int res = 0;
+	int res;
 	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
 
@@ -820,6 +820,7 @@ static int me_huge_page(struct page *p,
 	if (mapping) {
 		res = truncate_error_page(hpage, pfn, mapping);
 	} else {
+		res = MF_FAILED;
 		unlock_page(hpage);
 		/*
 		 * migration entry prevents later access on error anonymous
@@ -828,8 +829,10 @@ static int me_huge_page(struct page *p,
 		 */
 		if (PageAnon(hpage))
 			put_page(hpage);
-		dissolve_free_huge_page(p);
-		res = MF_RECOVERED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
 		lock_page(hpage);
 	}
 
@@ -1196,9 +1199,13 @@ static int memory_failure_hugetlb(unsign
 			}
 		}
 		unlock_page(head);
-		dissolve_free_huge_page(p);
-		action_result(pfn, MF_MSG_FREE_HUGE, MF_DELAYED);
-		return 0;
+		res = MF_FAILED;
+		if (!dissolve_free_huge_page(p) && take_page_off_buddy(p)) {
+			page_ref_inc(p);
+			res = MF_RECOVERED;
+		}
+		action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return res == MF_RECOVERED ? 0 : -EBUSY;
 	}
 
 	lock_page(head);
@@ -1339,6 +1346,7 @@ int memory_failure(unsigned long pfn, in
 	struct dev_pagemap *pgmap;
 	int res;
 	unsigned long page_flags;
+	bool retry = true;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -1356,6 +1364,7 @@ int memory_failure(unsigned long pfn, in
 		return -ENXIO;
 	}
 
+try_again:
 	if (PageHuge(p))
 		return memory_failure_hugetlb(pfn, flags);
 	if (TestSetPageHWPoison(p)) {
@@ -1380,8 +1389,21 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-			return 0;
+			if (take_page_off_buddy(p)) {
+				page_ref_inc(p);
+				res = MF_RECOVERED;
+			} else {
+				/* We lost the race, try again */
+				if (retry) {
+					ClearPageHWPoison(p);
+					num_poisoned_pages_dec();
+					retry = false;
+					goto try_again;
+				}
+				res = MF_FAILED;
+			}
+			action_result(pfn, MF_MSG_BUDDY, res);
+			return res == MF_RECOVERED ? 0 : -EBUSY;
 		} else {
 			action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 			return -EBUSY;
@@ -1405,14 +1427,6 @@ int memory_failure(unsigned long pfn, in
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
 	shake_page(p, 0);
-	/* shake_page could have turned it free. */
-	if (!PageLRU(p) && is_free_buddy_page(p)) {
-		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
-		return 0;
-	}
 
 	lock_page(p);
 
_
