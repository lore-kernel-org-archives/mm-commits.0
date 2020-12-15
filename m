Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E36C3526C
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9796122D0A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgLOX7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbgLOXXa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:23:30 -0500
Date:   Tue, 15 Dec 2020 15:21:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074503;
        bh=9v2jRGxEpHCnK56up60GPY0Np79TfylIAjkhpl+h8jc=;
        h=From:To:Subject:From;
        b=XgwvXnCHftpykdO8jwWwflHYrgx5LwMAjmwAUoLTTsA5X/a7Yw/X5XJ/VbmPwvy9D
         Gv6viCrhah0wIJ9yOhJrawsWKXvLqLbxXG3qy4CGU5mH5BhE1tOSPLPNiwk/urfklw
         oVhdR+E4jv+aX3ofvNYdAVbxjBEkQpdjaIBiABoo=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, pasha.tatashin@soleen.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch removed
 from -mm tree
Message-ID: <20201215232143.-Y4as4VaV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: move draining pcplists to page isolation users
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: move draining pcplists to page isolation users

Currently, pcplists are drained during set_migratetype_isolate() which
means once per pageblock processed start_isolate_page_range().  This is
somewhat wasteful.  Moreover, the callers might need different guarantees,
and the draining is currently prone to races and does not guarantee that
no page from isolated pageblock will end up on the pcplist after the
drain.

Better guarantees are added by later patches and require explicit actions
by page isolation users that need them.  Thus it makes sense to move the
current imperfect draining to the callers also as a preparation step.

Link: https://lkml.kernel.org/r/20201111092812.11329-7-vbabka@suse.cz
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 ++++++-----
 mm/page_alloc.c     |    2 ++
 mm/page_isolation.c |   10 +++++-----
 3 files changed, 13 insertions(+), 10 deletions(-)

--- a/mm/memory_hotplug.c~mm-page_alloc-move-draining-pcplists-to-page-isolation-users
+++ a/mm/memory_hotplug.c
@@ -1500,6 +1500,8 @@ int __ref offline_pages(unsigned long st
 		goto failed_removal;
 	}
 
+	drain_all_pages(zone);
+
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
 	node_states_check_changes_offline(nr_pages, zone, &arg);
@@ -1550,11 +1552,10 @@ int __ref offline_pages(unsigned long st
 		}
 
 		/*
-		 * per-cpu pages are drained in start_isolate_page_range, but if
-		 * there are still pages that are not free, make sure that we
-		 * drain again, because when we isolated range we might
-		 * have raced with another thread that was adding pages to pcp
-		 * list.
+		 * per-cpu pages are drained after start_isolate_page_range, but
+		 * if there are still pages that are not free, make sure that we
+		 * drain again, because when we isolated range we might have
+		 * raced with another thread that was adding pages to pcp list.
 		 *
 		 * Forward progress should be still guaranteed because
 		 * pages on the pcp list can only belong to MOVABLE_ZONE
--- a/mm/page_alloc.c~mm-page_alloc-move-draining-pcplists-to-page-isolation-users
+++ a/mm/page_alloc.c
@@ -8528,6 +8528,8 @@ int alloc_contig_range(unsigned long sta
 	if (ret)
 		return ret;
 
+	drain_all_pages(cc.zone);
+
 	/*
 	 * In case of -EBUSY, we'd like to know which page causes problem.
 	 * So, just fall through. test_pages_isolated() has a tracepoint
--- a/mm/page_isolation.c~mm-page_alloc-move-draining-pcplists-to-page-isolation-users
+++ a/mm/page_isolation.c
@@ -49,7 +49,6 @@ static int set_migratetype_isolate(struc
 
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
 		spin_unlock_irqrestore(&zone->lock, flags);
-		drain_all_pages(zone);
 		return 0;
 	}
 
@@ -172,11 +171,12 @@ __first_valid_page(unsigned long pfn, un
  *
  * Please note that there is no strong synchronization with the page allocator
  * either. Pages might be freed while their page blocks are marked ISOLATED.
- * In some cases pages might still end up on pcp lists and that would allow
+ * A call to drain_all_pages() after isolation can flush most of them. However
+ * in some cases pages might still end up on pcp lists and that would allow
  * for their allocation even when they are in fact isolated already. Depending
- * on how strong of a guarantee the caller needs drain_all_pages might be needed
- * (e.g. __offline_pages will need to call it after check for isolated range for
- * a next retry).
+ * on how strong of a guarantee the caller needs, further drain_all_pages()
+ * might be needed (e.g. __offline_pages will need to call it after check for
+ * isolated range for a next retry).
  *
  * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
_

Patches currently in -mm which might be from vbabka@suse.cz are


