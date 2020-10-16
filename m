Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE06C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6912087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816296;
	bh=23D3iXQprOrK9mjmKnujiotZehKcWfPT/m6Xy2QIwB4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eraPtZT3IV/vW1WtcXjfpj6iw1P8khwciT1DgAQp1Wvlpl9o8SfdsbmmdBTSqT1AY
	 lJG8Z5dOWQ9jU2ciQsqQiDlUek6S3AwXQgsHf/6Nshkp+kkoDJXvB77NtyO1ai5yjX
	 NLSQ/iCb1AExnprNqimxAAawkciKzK3OUpsnOOcM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393836AbgJPCoz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389682AbgJPCoz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:44:55 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C99F220E65;
        Fri, 16 Oct 2020 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816294;
        bh=23D3iXQprOrK9mjmKnujiotZehKcWfPT/m6Xy2QIwB4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JMglZidrrgRDKYHkRc+AfCMs5Km++VMIOuL4DUE5u70hX5dcw1/F85liBc1yj2d/i
         XAdXRBR22dOb6PTY2my7OB/q/Vv9T4sBpmpN9RxgrwkInFCEMnIXZmAhqMbibkinRd
         /MA4AZVYIyV4xqJLUjZrnNUwYl3Cr8WQGofTLBxo=
Date:   Thu, 15 Oct 2020 19:44:53 -0700
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
Subject:  [patch 063/156] mm/memory_hotplug: drop
 nr_isolate_pageblock in offline_pages()
Message-ID: <20201016024453.UOTCP0gPH%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: drop nr_isolate_pageblock in offline_pages()

We make sure that we cannot have any memory holes right at the beginning
of offline_pages() and we only support to online/offline full sections. 
Both, sections and pageblocks are a power of two in size, and sections
always span full pageblocks.

We can directly calculate the number of isolated pageblocks from nr_pages.

Link: https://lkml.kernel.org/r/20200819175957.28465-6-david@redhat.com
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

 mm/memory_hotplug.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages
+++ a/mm/memory_hotplug.c
@@ -1471,10 +1471,10 @@ int __ref offline_pages(unsigned long st
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn, system_ram_pages = 0;
-	int ret, node, nr_isolate_pageblock;
 	unsigned long flags;
 	struct zone *zone;
 	struct memory_notify arg;
+	int ret, node;
 	char *reason;
 
 	/* We can only offline full sections (e.g., SECTION_IS_ONLINE) */
@@ -1518,7 +1518,6 @@ int __ref offline_pages(unsigned long st
 		reason = "failure to isolate range";
 		goto failed_removal;
 	}
-	nr_isolate_pageblock = ret;
 
 	arg.start_pfn = start_pfn;
 	arg.nr_pages = nr_pages;
@@ -1596,7 +1595,7 @@ int __ref offline_pages(unsigned long st
 	 * pageblocks zone counter here.
 	 */
 	spin_lock_irqsave(&zone->lock, flags);
-	zone->nr_isolate_pageblock -= nr_isolate_pageblock;
+	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	/* removal success */
_
