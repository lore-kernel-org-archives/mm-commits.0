Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39384C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 02:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbiA0C3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:29:21 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40106 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiA0C3V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jan 2022 21:29:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49BB1B820F5
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 02:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D0CC340E7;
        Thu, 27 Jan 2022 02:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643250559;
        bh=lWtHLZZ/bPwbfRFrXFv48hsKkRMGBhDOPcs/lN5oPi4=;
        h=Date:From:To:Subject:From;
        b=B+R2ve8id4IqIKkb6JfXGjuiKos9XrGlAhWoxibuvVMv1+QjUwwMSUk03p4vUnaud
         74FjPQfjiGCyNcwJWIxBDZ4zHxiGWAeBwkrjMJhM+0pvi3Gt0oVBsfjhWEsBt1lEsb
         /buDjuJcFx7VFP3BKrTCnbUPF5EavIHUPqnSTJpw=
Date:   Wed, 26 Jan 2022 18:29:18 -0800
From:   akpm@linux-foundation.org
To:     dave.hansen@linux.intel.com, hughd@google.com,
        mm-commits@vger.kernel.org, ran.xiaokai@zte.com.cn,
        saravanand@fb.com, yang.shi@linux.alibaba.com,
        yang.yang29@zte.com.cn
Subject:  + mm-vmstat-add-event-for-ksm-swapping-in-copy.patch
 added to -mm tree
Message-ID: <20220127022918.Ldvl5-7ii%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add event for ksm swapping in copy
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-event-for-ksm-swapping-in-copy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-event-for-ksm-swapping-in-copy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-event-for-ksm-swapping-in-copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1385,6 +1385,9 @@ const char * const vmstat_text[] = {
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

mm-vmstat-add-event-for-ksm-swapping-in-copy.patch

