Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D50A7C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A32764F26
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhBZBRc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhBZBRU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93C8D64F29;
        Fri, 26 Feb 2021 01:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302219;
        bh=o8sZJhdgF2BFQYUIqA5/Lpixjodnpi54u4woksp07Jk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xt0qOunrQ2wu5KtiJMKEmFbiXEoim6YGbx/7Om+s3H/BWLU9jHzrGYc/O5c5TRsM6
         OIMYJFaGb3cN+9BjhlpXS2e3pv0f9GkE/mN2XzgL9aKCkSP1Clp817NWaLuP9hgWyA
         jkjmp720+buPOC6N5UcGwQyPFQsDus7cm3z5UNv8=
Date:   Thu, 25 Feb 2021 17:16:57 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, dan.j.williams@intel.com,
        david@redhat.com, linux-mm@kvack.org, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 026/118] mm: move pfn_to_online_page() out of line
Message-ID: <20210226011657.kIfynJXc9%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: move pfn_to_online_page() out of line

Patch series "mm: Fix pfn_to_online_page() with respect to ZONE_DEVICE", v4.

A pfn-walker that uses pfn_to_online_page() may inadvertently translate a
pfn as online and in the page allocator, when it is offline managed by a
ZONE_DEVICE mapping (details in Patch 3: ("mm: Teach pfn_to_online_page()
about ZONE_DEVICE section collisions")).

The 2 proposals under consideration are teach pfn_to_online_page() to be
precise in the presence of mixed-zone sections, or teach the memory-add
code to drop the System RAM associated with ZONE_DEVICE collisions.  In
order to not regress memory capacity by a few 10s to 100s of MiB the
approach taken in this set is to add precision to pfn_to_online_page().

In the course of validating pfn_to_online_page() a couple other fixes
fell out:

1/ soft_offline_page() fails to drop the reference taken in the
   madvise(..., MADV_SOFT_OFFLINE) case.

2/ memory_failure() uses get_dev_pagemap() to lookup ZONE_DEVICE pages,
   however that mapping may contain data pages and metadata raw pfns.
   Introduce pgmap_pfn_valid() to delineate the 2 types and fail the
   handling of raw metadata pfns.


This patch (of 4);

pfn_to_online_page() is already too large to be a macro or an inline
function.  In anticipation of further logic changes / growth, move it out
of line.

No functional change, just code movement.

Link: https://lkml.kernel.org/r/161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/161058499608.1840162.10165648147615238793.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |   17 +----------------
 mm/memory_hotplug.c            |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 16 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-move-pfn_to_online_page-out-of-line
+++ a/include/linux/memory_hotplug.h
@@ -16,22 +16,7 @@ struct resource;
 struct vmem_altmap;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-/*
- * Return page for the valid pfn only if the page is online. All pfn
- * walkers which rely on the fully initialized page->flags and others
- * should use this rather than pfn_valid && pfn_to_page
- */
-#define pfn_to_online_page(pfn)					   \
-({								   \
-	struct page *___page = NULL;				   \
-	unsigned long ___pfn = pfn;				   \
-	unsigned long ___nr = pfn_to_section_nr(___pfn);	   \
-								   \
-	if (___nr < NR_MEM_SECTIONS && online_section_nr(___nr) && \
-	    pfn_valid_within(___pfn))				   \
-		___page = pfn_to_page(___pfn);			   \
-	___page;						   \
-})
+struct page *pfn_to_online_page(unsigned long pfn);
 
 /*
  * Types for free bootmem stored in page->lru.next. These have to be in
--- a/mm/memory_hotplug.c~mm-move-pfn_to_online_page-out-of-line
+++ a/mm/memory_hotplug.c
@@ -301,6 +301,22 @@ static int check_hotplug_memory_addressa
 }
 
 /*
+ * Return page for the valid pfn only if the page is online. All pfn
+ * walkers which rely on the fully initialized page->flags and others
+ * should use this rather than pfn_valid && pfn_to_page
+ */
+struct page *pfn_to_online_page(unsigned long pfn)
+{
+	unsigned long nr = pfn_to_section_nr(pfn);
+
+	if (nr < NR_MEM_SECTIONS && online_section_nr(nr) &&
+	    pfn_valid_within(pfn))
+		return pfn_to_page(pfn);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(pfn_to_online_page);
+
+/*
  * Reasonably generic function for adding memory.  It is
  * expected that archs that support memory hotplug will
  * call this function after deciding the zone to which to
_
