Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192D4C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiCVVs0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiCVVsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:48:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1F45F8FC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5590F615B1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEE2C340F4;
        Tue, 22 Mar 2022 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985593;
        bh=5ErEVaDZfioISIDZcZyTLyPEkR5qz3X0E6do+82rk+c=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=u3MA7BHsUpbtzI1r2JqwI7icG5yAnsbZnyUZWf/c4lWDiUDJCGTS0KXDQAlaTNEAG
         mkb2RPqtOcvkOLGodpPgtNpM5BSxne3KSg3NyofHHW1447kU84jUSIj1nIOjAaXE0T
         eqjdcpL68SONtWD7FkpQmXAUym9TsKxTYuwtvodc=
Date:   Tue, 22 Mar 2022 14:46:33 -0700
To:     yang.shi@linux.alibaba.com, saravanand@fb.com,
        ran.xiaokai@zte.com.cn, hughd@google.com,
        dave.hansen@linux.intel.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 158/227] mm/vmstat: add event for ksm swapping in copy
Message-Id: <20220322214633.AAEE2C340F4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
