Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF7DC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B425223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgLODPj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727395AbgLODMu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:50 -0500
Date:   Mon, 14 Dec 2020 19:11:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001883;
        bh=N/kQNJ/80/2yieFnq5jLpb4aVnOmvncFIO6ozUltynY=;
        h=From:To:Subject:In-Reply-To:From;
        b=GTvftyTeC90MgUhDaUdpZ5CeeqZbq2BV/5dG3HMYkNmGglyWxDKde20+0tBSTEDAh
         TZHzQABOs8n9XwaAeObEURbYiT8HM1jS6LRmxMHmav7rsiby9DV06anlQ4PC8CrF8c
         +7HrpQ+Myn1WiUrdFIBTB7x1UjvY0f5Zz8S0Iu+Q=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, guro@fb.com,
        linux-mm@kvack.org, lstoakes@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 136/200] mm: page_alloc: refactor
 setup_per_zone_lowmem_reserve()
Message-ID: <20201215031122.WX7a8bg-5%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: page_alloc: refactor setup_per_zone_lowmem_reserve()

setup_per_zone_lowmem_reserve() iterates through each zone setting
zone->lowmem_reserve[j] = 0 (where j is the zone's index) then iterates
backwards through all preceding zones, setting
lower_zone->lowmem_reserve[j] = sum(managed pages of higher zones) /
lowmem_reserve_ratio[idx] for each (where idx is the lower zone's index).

If the lower zone has no managed pages or its ratio is 0 then all of its
lowmem_reserve[] entries are effectively zeroed.

As these arrays are only assigned here and all lowmem_reserve[] entries
for index < this zone's index are implicitly assumed to be 0 (as these are
specifically output in show_free_areas() and zoneinfo_show_print() for
example) there is no need to additionally zero index == this zone's index
too.  This patch avoids zeroing unnecessarily.

Rather than iterating through zones and setting lowmem_reserve[j] for each
lower zone this patch reverse the process and populates each zone's
lowmem_reserve[] values in ascending order.

This clarifies what is going on especially in the case of zero managed
pages or ratio which is now explicitly shown to clear these values.

Link: https://lkml.kernel.org/r/20201129162758.115907-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-refactor-setup_per_zone_lowmem_reserve
+++ a/mm/page_alloc.c
@@ -7862,31 +7862,24 @@ static void calculate_totalreserve_pages
 static void setup_per_zone_lowmem_reserve(void)
 {
 	struct pglist_data *pgdat;
-	enum zone_type j, idx;
+	enum zone_type i, j;
 
 	for_each_online_pgdat(pgdat) {
-		for (j = 0; j < MAX_NR_ZONES; j++) {
-			struct zone *zone = pgdat->node_zones + j;
-			unsigned long managed_pages = zone_managed_pages(zone);
+		for (i = 0; i < MAX_NR_ZONES - 1; i++) {
+			struct zone *zone = &pgdat->node_zones[i];
+			int ratio = sysctl_lowmem_reserve_ratio[i];
+			bool clear = !ratio || !zone_managed_pages(zone);
+			unsigned long managed_pages = 0;
 
-			zone->lowmem_reserve[j] = 0;
-
-			idx = j;
-			while (idx) {
-				struct zone *lower_zone;
-
-				idx--;
-				lower_zone = pgdat->node_zones + idx;
-
-				if (!sysctl_lowmem_reserve_ratio[idx] ||
-				    !zone_managed_pages(lower_zone)) {
-					lower_zone->lowmem_reserve[j] = 0;
-					continue;
+			for (j = i + 1; j < MAX_NR_ZONES; j++) {
+				if (clear) {
+					zone->lowmem_reserve[j] = 0;
 				} else {
-					lower_zone->lowmem_reserve[j] =
-						managed_pages / sysctl_lowmem_reserve_ratio[idx];
+					struct zone *upper_zone = &pgdat->node_zones[j];
+
+					managed_pages += zone_managed_pages(upper_zone);
+					zone->lowmem_reserve[j] = managed_pages / ratio;
 				}
-				managed_pages += zone_managed_pages(lower_zone);
 			}
 		}
 	}
_
