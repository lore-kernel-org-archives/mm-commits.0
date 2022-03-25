Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDE7C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348374AbiCYBfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357424AbiCYBeu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A821BF53A
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BB89B82725
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA13EC340EC;
        Fri, 25 Mar 2022 01:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171947;
        bh=cRcJxBEIdgmlUPakGPtBqBjYAl1klzpCyKW124vego8=;
        h=Date:To:From:Subject:From;
        b=LO3wG2tV83gURM1hQi0A1pcZI5ClXbuEAbV8ScBheATSh/oCtXHauXJEwHrbOxana
         E3fUKNxbLPAInWwzY0Tiqy6FFZB8d3E97iN86pdg/hUwpbUo9iRQMb6IaSQ2y8HYJI
         GPdKXjcNSDykKPfgLXN2Ae0dbai29/rMd8latI8k=
Date:   Thu, 24 Mar 2022 18:32:27 -0700
To:     mm-commits@vger.kernel.org, yang.shi@linux.alibaba.com,
        saravanand@fb.com, ran.xiaokai@zte.com.cn, hughd@google.com,
        dave.hansen@linux.intel.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmstat-add-event-for-ksm-swapping-in-copy.patch removed from -mm tree
Message-Id: <20220325013227.BA13EC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add event for ksm swapping in copy
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-event-for-ksm-swapping-in-copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/vmstat: add event for ksm swapping in copy

When faults in from swap what used to be a KSM page and that page had been
swapped in before, system has to make a copy, and leaves remerging the
pages to a later pass of ksmd.

That is not good for performace, we'd better to reduce this kind of copy. 
There are some ways to reduce it, for example lessen swappiness or
madvise(, , MADV_MERGEABLE) range.  So add this event to support doing
this tuning.  Just like this patch: "mm, THP, swap: add THP swapping out
fallback counting".

Link: https://lkml.kernel.org/r/20220113023839.758845-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Saravanan D <saravanand@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    3 +++
 mm/ksm.c                      |    3 +++
 mm/vmstat.c                   |    3 +++
 3 files changed, 9 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vmstat-add-event-for-ksm-swapping-in-copy
+++ a/include/linux/vm_event_item.h
@@ -129,6 +129,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_SWAP
 		SWAP_RA,
 		SWAP_RA_HIT,
+#ifdef CONFIG_KSM
+		KSM_SWPIN_COPY,
+#endif
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
--- a/mm/ksm.c~mm-vmstat-add-event-for-ksm-swapping-in-copy
+++ a/mm/ksm.c
@@ -2595,6 +2595,9 @@ struct page *ksm_might_need_to_copy(stru
 		SetPageDirty(new_page);
 		__SetPageUptodate(new_page);
 		__SetPageLocked(new_page);
+#ifdef CONFIG_SWAP
+		count_vm_event(KSM_SWPIN_COPY);
+#endif
 	}
 
 	return new_page;
--- a/mm/vmstat.c~mm-vmstat-add-event-for-ksm-swapping-in-copy
+++ a/mm/vmstat.c
@@ -1388,6 +1388,9 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_SWAP
 	"swap_ra",
 	"swap_ra_hit",
+#ifdef CONFIG_KSM
+	"ksm_swpin_copy",
+#endif
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


