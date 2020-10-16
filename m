Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5951DC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A530208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816397;
	bh=TqIIrFjmgVR+6mtPAFdgaYQO/q+Rk75RQaO79pqgqr8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nDAXb6n8egLI67nK8HN0y8tQKYHNA4k0oz6C1pZGnBY/478T1kbcU4rrKST6AIHEL
	 nHdpC1C/Agkvd9pO7+n/BrMpWWQV6fVbcu5eOkSyzEZk2wWTPz4BWkvKkd2HTcHyfp
	 JT5EU3TgPFNansWdUt1ewL/SRhoapr1RcSvms8Cc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389513AbgJPCqg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgJPCqg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:36 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5594320878;
        Fri, 16 Oct 2020 02:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816394;
        bh=TqIIrFjmgVR+6mtPAFdgaYQO/q+Rk75RQaO79pqgqr8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kV0Oc9te+1cL91pqjVxyVMgV670gKMvbhOf214sr8cRN0TdT+8RzYl+KEFFzwj4Ji
         tjkDr7wcUw8gdI/phNAqVth93CIcmcbF+9zbQ+DGEDueq1oPf7nmbKKrr3X6XapHIl
         D+tn7y90TREKEIaA0sWIqNKOX5m3NnTskLQl53AI=
Date:   Thu, 15 Oct 2020 19:46:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cheloha@linux.ibm.com, dave.hansen@intel.com, david@redhat.com,
        haiyangz@microsoft.com, kys@microsoft.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  [patch 083/156] mm/memory_hotplug: update comment
 regarding zone shuffling
Message-ID: <20201016024632.0itHtzGC-%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: update comment regarding zone shuffling

As we no longer shuffle via generic_online_page() and when undoing
isolation, we can simplify the comment.

We now effectively shuffle only once (properly) when onlining new memory.

Link: https://lkml.kernel.org/r/20201005121534.15649-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-update-comment-regarding-zone-shuffling
+++ a/mm/memory_hotplug.c
@@ -858,13 +858,10 @@ int __ref online_pages(unsigned long pfn
 	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
 
 	/*
-	 * When exposing larger, physically contiguous memory areas to the
-	 * buddy, shuffling in the buddy (when freeing onlined pages, putting
-	 * them either to the head or the tail of the freelist) is only helpful
-	 * for maintaining the shuffle, but not for creating the initial
-	 * shuffle. Shuffle the whole zone to make sure the just onlined pages
-	 * are properly distributed across the whole freelist. Make sure to
-	 * shuffle once pageblocks are no longer isolated.
+	 * Freshly onlined pages aren't shuffled (e.g., all pages are placed to
+	 * the tail of the freelist when undoing isolation). Shuffle the whole
+	 * zone to make sure the just onlined pages are properly distributed
+	 * across the whole freelist - to create an initial shuffle.
 	 */
 	shuffle_zone(zone);
 
_
