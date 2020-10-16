Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2DBC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E969214DB
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881414;
	bh=PeDONNqrbkOk6sIsmScVmi2RCgJ84ilBbA2Nq7OppJY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gH4xPRf+ir9XrWPJMMEQhQjjDb7XCaJyG+ViuBXO+nXOG6GsAcyliIQDnN9pf8SUu
	 fbVRRXv7Az++ovsBCIF/RuTp1vlPF/nDBEjd51PaFAAmrnBuNqgrZJpciaqc4HAkYz
	 sP7T2SkXWS1AJUn8WIs2un1dkrYFfaamgnidDq/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392734AbgJPUuO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:50:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUuN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:50:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FE620878;
        Fri, 16 Oct 2020 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881412;
        bh=PeDONNqrbkOk6sIsmScVmi2RCgJ84ilBbA2Nq7OppJY=;
        h=Date:From:To:Subject:From;
        b=ti+hFAiRvSw3udelsDzzj6EfJVggTjPfnmJx8OV0l4LnlpAnHlvxEc4WLblhigU9R
         9WH3OEmifd7h6e+bG8WMJH8gjozmcIPMaLHacGfKdlAqs3KL/1o8KtE+NLhFTTJ5z7
         EbCRwGQKato9GQl7wTKo3dAMGkqPXTl6sKC6/E3Q=
Date:   Fri, 16 Oct 2020 13:50:10 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  [merged]
 mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
 removed from -mm tree
Message-ID: <20201016205010.vtn-Ij6jv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: enforce section granularity when onlining/offlining
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: enforce section granularity when onlining/offlining

Already two people (including me) tried to offline subsections, because
the function looks like it can deal with it.  But we really can only
online/offline full sections that are properly aligned (e.g., we can only
mark full sections online/offline via SECTION_IS_ONLINE).

Add a simple safety net to document the restriction now.  Current users
(core and powernv/memtrace) respect these restrictions.

Link: https://lkml.kernel.org/r/20200819175957.28465-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining
+++ a/mm/memory_hotplug.c
@@ -809,6 +809,11 @@ int __ref online_pages(unsigned long pfn
 	int ret;
 	struct memory_notify arg;
 
+	/* We can only online full sections (e.g., SECTION_IS_ONLINE) */
+	if (WARN_ON_ONCE(!nr_pages ||
+			 !IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION)))
+		return -EINVAL;
+
 	mem_hotplug_begin();
 
 	/* associate pfn range with the zone */
@@ -1494,6 +1499,11 @@ int __ref offline_pages(unsigned long st
 	struct memory_notify arg;
 	char *reason;
 
+	/* We can only offline full sections (e.g., SECTION_IS_ONLINE) */
+	if (WARN_ON_ONCE(!nr_pages ||
+			 !IS_ALIGNED(start_pfn | nr_pages, PAGES_PER_SECTION)))
+		return -EINVAL;
+
 	mem_hotplug_begin();
 
 	/*
_

Patches currently in -mm which might be from david@redhat.com are


