Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821C8C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4672820705
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 02:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgLOCSh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 21:18:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgLOCS3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 21:18:29 -0500
Date:   Mon, 14 Dec 2020 18:17:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607998669;
        bh=khZiqQGfsG1EGv8/NR87FCe5DWPrcqd5UcYrBRJlP7s=;
        h=From:To:Subject:From;
        b=09A1/qg2BQEoFq40OUzw88ftVJY3EmgnqsySk/n+52zqAP4C4ZMT8KaVi0fw7Pmen
         QR/+xaYRk5tC3Cr2GC8DQiCzuy0ntoxOKHceYXE/r5r2v8jVUFBGh8FFhGwomdk3qH
         NLacw+NfCsHIRmVvOgMC9z2jKA1W/cdfQD1EsFDM=
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  [folded-merged]
 mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch removed from
 -mm tree
Message-ID: <20201215021748.F4eXx8Iki%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-disable-pcplists-during-memory-offline-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

This patch was dropped because it was folded into mm-page_alloc-disable-pcplists-during-memory-offline.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-disable-pcplists-during-memory-offline-fix

add comment, per David

Link: https://lkml.kernel.org/r/527480ef-ed72-e1c1-52a0-1c5b0113df45@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-disable-pcplists-during-memory-offline-fix
+++ a/mm/page_alloc.c
@@ -3025,6 +3025,16 @@ static void drain_local_pages_wq(struct
 	preempt_enable();
 }
 
+/*
+ * The implementation of drain_all_pages(), exposing an extra parameter to
+ * drain on all cpus.
+ *
+ * drain_all_pages() is optimized to only execute on cpus where pcplists are
+ * not empty. The check for non-emptiness can however race with a free to
+ * pcplist that has not yet increased the pcp->count from 0 to 1. Callers
+ * that need the guarantee that every CPU has drained can disable the
+ * optimizing racy check.
+ */
 void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slab-slub-clear-the-slab_cache-field-when-freeing-page.patch
mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

