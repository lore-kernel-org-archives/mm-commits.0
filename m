Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBFCC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1560D20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816284;
	bh=HBgidZIBSKhm02N61qN8wLnnIq23T+fV1TubSu9maqs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Y0fBwjhWS3gSGGzLBQe7puvuKRQkDsF62jUw3lsOliBveauzbFRaGUHfjO1UgIVuH
	 3/irxds+fUajisCqFcRtiaPlJPnYfC/3jL386HaS5ziNUi4OSxusz94j3RUVVH+ZLO
	 S4ZOvF4tVtK+96UapFmoCj5Qz8Ztxv+9Qdb6ua0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393834AbgJPCon (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:44:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389682AbgJPCon (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:44:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75EB62087D;
        Fri, 16 Oct 2020 02:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816281;
        bh=HBgidZIBSKhm02N61qN8wLnnIq23T+fV1TubSu9maqs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=z/JV5ykUCPOcT2kMnxZ588e1mDylBs/JZ1XVfc+wHTENUeEfVAedyaS+Vnf16owg2
         SuK2td9+TyJbEnuV130KC7UzCxi/mxWr90sHzV7wYI9VKKEjaxXyVLQXt9mCCjkvme
         DNiTnVKIju6Lw1Gb4+FMne3bpmZA3k29iUhGyaYc=
Date:   Thu, 15 Oct 2020 19:44:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        linux-mm@kvack.org, logang@deltatee.com, mgorman@suse.de,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 060/156] mm/memory_hotplug: enforce section
 granularity when onlining/offlining
Message-ID: <20201016024440.h6U4hLFGZ%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
