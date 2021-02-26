Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85399C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E21264F24
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhBZAmx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhBZAmx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:42:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A24EC64F21;
        Fri, 26 Feb 2021 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300132;
        bh=aFPCtAxRUvvzigLkke4a6pGgym8HfIgK6ogYYg9V/ss=;
        h=Date:From:To:Subject:From;
        b=G1rpRncmUR0zXNg/XF7pqGa9GUoTc80GqwlB7rx2m1V+1u32is4YwjTepz11sTK3V
         TaZNRyQ4929H9qhr2O8BViS/bto86GwAUOHq5/HHsccafRmlpHSr34YpqglNab7w9S
         ORyliegQ/FkML5SYztdaelHp6OSa4JE3IGeQcUNQ=
Date:   Thu, 25 Feb 2021 16:42:12 -0800
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [folded-merged]
 mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix.patch
 removed from -mm tree
Message-ID: <20210226004212.COUlr4XsR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix
has been removed from the -mm tree.  Its filename was
     mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix.patch

This patch was dropped because it was folded into mm-teach-pfn_to_online_page-about-zone_device-section-collisions.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix

fix CONFIG_ZONE_DEVICE=n build

Link: https://lkml.kernel.org/r/CAPcyv4iX+7LAgAeSqx7Zw-Zd=ZV9gBv8Bo7oTbwCOOqJoZ3+Yg@mail.gmail.com
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   12 ++++++++++++
 mm/memory_hotplug.c    |    2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix
+++ a/include/linux/mmzone.h
@@ -918,6 +918,18 @@ static inline int local_memory_node(int
  */
 #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
 
+#ifdef CONFIG_ZONE_DEVICE
+static inline bool zone_is_zone_device(struct zone *zone)
+{
+	return zone_idx(zone) == ZONE_DEVICE;
+}
+#else
+static inline bool zone_is_zone_device(struct zone *zone)
+{
+	return false;
+}
+#endif
+
 /*
  * Returns true if a zone has pages managed by the buddy allocator.
  * All the reclaim decisions have to use this function rather than
--- a/mm/memory_hotplug.c~mm-teach-pfn_to_online_page-about-zone_device-section-collisions-fix
+++ a/mm/memory_hotplug.c
@@ -769,7 +769,7 @@ void __ref move_pfn_range_to_zone(struct
 	 * ZONE_DEVICE pages in an otherwise  ZONE_{NORMAL,MOVABLE}
 	 * section.
 	 */
-	if (zone_idx(zone) == ZONE_DEVICE) {
+	if (zone_is_zone_device(zone)) {
 		if (!IS_ALIGNED(start_pfn, PAGES_PER_SECTION))
 			section_taint_zone_device(start_pfn);
 		if (!IS_ALIGNED(start_pfn + nr_pages, PAGES_PER_SECTION))
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-move-pfn_to_online_page-out-of-line.patch
mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch
mm-teach-pfn_to_online_page-about-zone_device-section-collisions.patch
mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

