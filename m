Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01681C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiCaEbW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiCaE05 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F5EF7F77
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:16:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85904612AF
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4963C340F0;
        Thu, 31 Mar 2022 04:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648700214;
        bh=MwmeNTxY8m+grQbRwAGudJ0SWa1y5zXNUzQEREcStI4=;
        h=Date:To:From:Subject:From;
        b=tLM996t9MyW2m/zUjOm2OJqyPoVa++tchtoqGdebb/be1sbpZhCJkmkl+zvnep7vg
         mTXZyE4AR5qwYGF0R6hI2qhX11y0t741kbgtOmqZs+mQ+u20EMHyGV4tr/01QlYF81
         mSmxC1SsczR+OTxJ1bAnmUmK56DWDGrdSjuJNVAc=
Date:   Wed, 30 Mar 2022 21:16:54 -0700
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn,
        willy@infradead.org, saravanand@fb.com, ran.xiaokai@zte.com.cn,
        minchan@kernel.org, jhubbard@nvidia.com, david@redhat.com,
        dave.hansen@linux.intel.com, corbet@lwn.net,
        yang.yang29@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-add-events-for-ksm-cow.patch added to -mm tree
Message-Id: <20220331041654.D4963C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add events for ksm cow
has been added to the -mm tree.  Its filename is
     mm-vmstat-add-events-for-ksm-cow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmstat-add-events-for-ksm-cow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmstat-add-events-for-ksm-cow.patch

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
@@ -3332,6 +3332,10 @@ copy:
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

mm-vmstat-add-events-for-ksm-cow.patch

