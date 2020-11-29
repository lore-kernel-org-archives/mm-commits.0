Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD6FC3E8C5
	for <mm-commits@archiver.kernel.org>; Sun, 29 Nov 2020 23:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94B1206F9
	for <mm-commits@archiver.kernel.org>; Sun, 29 Nov 2020 23:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ScYjQU/o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgK2X4q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Nov 2020 18:56:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgK2X4q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 29 Nov 2020 18:56:46 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BC7206F9;
        Sun, 29 Nov 2020 23:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606694165;
        bh=kn5rajJ5upjRMN4j9nXrTWGb9zMjRqqey8AkZ1Up1b4=;
        h=Date:From:To:Subject:From;
        b=ScYjQU/oZFMvjbSPtXNwQCEm31g4JMKPs+H6ZZA3wzejQG8awJeQdES1XXfcX0QTq
         QKLjn4VVcQxvQA9T/ZRkXvmLcCFWJ+7bQV1r+eNsZK7JHUTrwvNja2OKpaprnC42Dq
         +u6JEOJvC4etNrMn/uXfnwAtmS08O8uk37JGeHpQ=
Date:   Sun, 29 Nov 2020 15:56:04 -0800
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, guro@fb.com, lstoakes@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, vbabka@suse.cz
Subject:  +
 mm-page_alloc-refactor-setup_per_zone_lowmem_reserve.patch added to -mm
 tree
Message-ID: <20201129235604.iTlLgfap4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: refactor setup_per_zone_lowmem_reserve()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-refactor-setup_per_zone_lowmem_reserve.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-refactor-setup_per_zone_lowmem_reserve.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-refactor-setup_per_zone_lowmem_reserve.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm: page_alloc: refactor setup_per_zone_lowmem_reserve()

setup_per_zone_lowmem_reserve() iterates through each zone setting
zone->lowmem_reserve[j] = 0 (where j is the zone's index) then iterates
backwards through all proceeding zones, setting
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
@@ -7861,31 +7861,24 @@ static void calculate_totalreserve_pages
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

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-page_alloc-refactor-setup_per_zone_lowmem_reserve.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec-fix-fix.patch

