Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242EFC433E9
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D6A20770
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jan 2021 22:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbhAQWBX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jan 2021 17:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbhAQWBT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 17 Jan 2021 17:01:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 490EB208A9;
        Sun, 17 Jan 2021 22:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610920839;
        bh=/oeMGG+gm3/VSIZzFihAhiX1Dd/fqkthTN5EgDNPVI8=;
        h=Date:From:To:Subject:From;
        b=WMPyU/0KqJJ/cGd39WHi1cQ5nz38xuNmlRkDECYgQP0R5BUhKOFmfCKtsDiipfkG+
         PrUf9LmGWVe3wXn9JoXHSq/eUBOj8cvyKpMQmXT6/rYeKiqY8bhbmrRERJqLesnHL4
         DhylgMC2VjUL+hJDd5pHPFpBOh/+sSeAQuXPyIos=
Date:   Sun, 17 Jan 2021 14:00:37 -0800
From:   akpm@linux-foundation.org
To:     cai@lca.pw, dan.j.williams@intel.com, david@redhat.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de
Subject:  +
 mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch added to
 -mm tree
Message-ID: <20210117220037.PRsAuGrFo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: teach pfn_to_online_page() to consider subsection validity
has been added to the -mm tree.  Its filename is
     mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: teach pfn_to_online_page() to consider subsection validity

pfn_section_valid() determines pfn validity on subsection granularity
where pfn_valid() may be limited to coarse section granularity. 
Explicitly validate subsections after pfn_valid() succeeds.

Link: https://lkml.kernel.org/r/161058500148.1840162.4365921007820501696.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: b13bc35193d9 ("mm/hotplug: invalid PFNs from pfn_to_online_page()")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: David Hildenbrand <david@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
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

mm-fix-page-reference-leak-in-soft_offline_page.patch
mm-move-pfn_to_online_page-out-of-line.patch
mm-teach-pfn_to_online_page-to-consider-subsection-validity.patch
mm-teach-pfn_to_online_page-about-zone_device-section-collisions.patch
mm-fix-memory_failure-handling-of-dax-namespace-metadata.patch

