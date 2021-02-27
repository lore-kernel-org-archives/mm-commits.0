Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19715C433E9
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5FDD64F40
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhB0C37 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhB0C3x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB6564F36;
        Sat, 27 Feb 2021 02:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392955;
        bh=R9V+dE1AYYN8mSIKNQ1nVCaOAkR95DQqZuN7u21mFYQ=;
        h=Date:From:To:Subject:From;
        b=TI4klKgLvtK6R1EFS+01aqr22tEZMAoTYa5RelWHJkfhz3airmVLpyTI1zMmspJat
         JQe6Hlt/dPB/vlMAuZkcxXaDiFUUAqpSOwGiASnZ8IlZb0679PQXfyD+M/0SwfWIVC
         wCYn/AoUt8rPKt2Vt4u2wtBdhfvgwg+QlA3oPVzw=
Date:   Fri, 26 Feb 2021 18:29:15 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de
Subject:  [merged]
 mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch removed
 from -mm tree
Message-ID: <20210227022915._P_dRSATX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: teach pfn_to_online_page() to consider subsection validity
has been removed from the -mm tree.  Its filename was
     mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: teach pfn_to_online_page() to consider subsection validity

pfn_to_online_page is primarily used to filter out offline or fully
uninitialized pages.  pfn_valid resp.  online_section_nr have a coarse
per memory section granularity.  If a section shared with a partially
offline memory (e.g.  part of ZONE_DEVICE) then pfn_to_online_page
would lead to a false positive on some pfns.  Fix this by adding
pfn_section_valid check which is subsection aware.

[mhocko@kernel.org: changelog rewrite]
Link: https://lkml.kernel.org/r/161058500148.1840162.4365921007820501696.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: b13bc35193d9 ("mm/hotplug: invalid PFNs from pfn_to_online_page()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/memory_hotplug.c~mm-teach-pfn_to_online_page-to-consider-subsection-validity
+++ a/mm/memory_hotplug.c
@@ -308,11 +308,26 @@ static int check_hotplug_memory_addressa
 struct page *pfn_to_online_page(unsigned long pfn)
 {
 	unsigned long nr = pfn_to_section_nr(pfn);
+	struct mem_section *ms;
 
-	if (nr < NR_MEM_SECTIONS && online_section_nr(nr) &&
-	    pfn_valid_within(pfn))
-		return pfn_to_page(pfn);
-	return NULL;
+	if (nr >= NR_MEM_SECTIONS)
+		return NULL;
+
+	ms = __nr_to_section(nr);
+	if (!online_section(ms))
+		return NULL;
+
+	/*
+	 * Save some code text when online_section() +
+	 * pfn_section_valid() are sufficient.
+	 */
+	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
+		return NULL;
+
+	if (!pfn_section_valid(ms, pfn))
+		return NULL;
+
+	return pfn_to_page(pfn);
 }
 EXPORT_SYMBOL_GPL(pfn_to_online_page);
 
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


