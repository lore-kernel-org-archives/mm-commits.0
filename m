Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4771FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbiEJESM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiEJEQy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:16:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7580243106
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44CCEB81B03
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6FEC385C5;
        Tue, 10 May 2022 04:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155937;
        bh=xjMC6itd71FYL97EnqsGtpfdVHy/mLiThqjnWhbIVgQ=;
        h=Date:To:From:Subject:From;
        b=lAZD8GK6w26vo2Cnjh1WA0xbxcsoKS96hSCBUsxPgjKbbY0R/0ED+D97LnKn+gdQF
         tThASz+gOsulA4AIQ8P2JqVqxIj1TAZxjH8UpZjkulUSdRn8eX4D7CPLVpAITzPb0b
         VNxvQZgBt+qsWI/+8M0lGB3IgJLmTBUPhGHpcBsQ=
Date:   Mon, 09 May 2022 21:12:16 -0700
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn,
        willy@infradead.org, saravanand@fb.com, ran.xiaokai@zte.com.cn,
        minchan@kernel.org, jhubbard@nvidia.com, david@redhat.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmstat-add-events-for-ksm-cow.patch removed from -mm tree
Message-Id: <20220510041216.DD6FEC385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmstat: add events for ksm cow
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-ksm-cow.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmstat: add events for ksm cow

Users may use ksm by calling madvise(, , MADV_MERGEABLE) when they want to
save memory, it's a tradeoff by suffering delay on ksm cow.  Users can get
to know how much memory ksm saved by reading
/sys/kernel/mm/ksm/pages_sharing, but they don't know what's the costs of
ksm cow, and this is important of some delay sensitive tasks.

So add ksm cow events to help users evaluate whether or how to use ksm. 
Also update Documentation/admin-guide/mm/ksm.rst with new added events.

Link: https://lkml.kernel.org/r/20220331035616.2390805-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Saravanan D <saravanand@fb.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/ksm.rst |   18 ++++++++++++++++++
 include/linux/vm_event_item.h        |    3 +++
 mm/memory.c                          |    4 ++++
 mm/vmstat.c                          |    3 +++
 4 files changed, 28 insertions(+)

--- a/Documentation/admin-guide/mm/ksm.rst~mm-vmstat-add-events-for-ksm-cow
+++ a/Documentation/admin-guide/mm/ksm.rst
@@ -184,6 +184,24 @@ The maximum possible ``pages_sharing/pag
 ``max_page_sharing`` tunable. To increase the ratio ``max_page_sharing`` must
 be increased accordingly.
 
+Monitoring KSM events
+=====================
+
+There are some counters in /proc/vmstat that may be used to monitor KSM events.
+KSM might help save memory, it's a tradeoff by may suffering delay on KSM COW
+or on swapping in copy. Those events could help users evaluate whether or how
+to use KSM. For example, if cow_ksm increases too fast, user may decrease the
+range of madvise(, , MADV_MERGEABLE).
+
+cow_ksm
+	is incremented every time a KSM page triggers copy on write (COW)
+	when users try to write to a KSM page, we have to make a copy.
+
+ksm_swpin_copy
+	is incremented every time a KSM page is copied when swapping in
+	note that KSM page might be copied when swapping in because do_swap_page()
+	cannot do all the locking needed to reconstitute a cross-anon_vma KSM page.
+
 --
 Izik Eidus,
 Hugh Dickins, 17 Nov 2009
--- a/include/linux/vm_event_item.h~mm-vmstat-add-events-for-ksm-cow
+++ a/include/linux/vm_event_item.h
@@ -133,6 +133,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		KSM_SWPIN_COPY,
 #endif
 #endif
+#ifdef CONFIG_KSM
+		COW_KSM,
+#endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
 		DIRECT_MAP_LEVEL3_SPLIT,
--- a/mm/memory.c~mm-vmstat-add-events-for-ksm-cow
+++ a/mm/memory.c
@@ -3331,6 +3331,10 @@ copy:
 	get_page(vmf->page);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
+#ifdef CONFIG_KSM
+	if (PageKsm(vmf->page))
+		count_vm_event(COW_KSM);
+#endif
 	return wp_page_copy(vmf);
 }
 
--- a/mm/vmstat.c~mm-vmstat-add-events-for-ksm-cow
+++ a/mm/vmstat.c
@@ -1393,6 +1393,9 @@ const char * const vmstat_text[] = {
 	"ksm_swpin_copy",
 #endif
 #endif
+#ifdef CONFIG_KSM
+	"cow_ksm",
+#endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
 	"direct_map_level3_splits",
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are

delayacct-track-delays-from-write-protect-copy.patch

