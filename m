Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FEC4338F
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA1226109E
	for <mm-commits@archiver.kernel.org>; Fri, 13 Aug 2021 20:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbhHMUOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234079AbhHMUOr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Aug 2021 16:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90348610CF;
        Fri, 13 Aug 2021 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628885658;
        bh=kXG9o51zjscosB4t+KA3jxO/f2XzreKBOJSidsQDgvw=;
        h=Date:From:To:Subject:From;
        b=x4CX5k6dVXsZFNp12KVrWm7gTmVDHMC4xCUbyJetan9UD4YizVuf+arHP0HRiBIHq
         m7ZSBDLFrFjkJW64eY3E703yd9T6Vk/8e8FCCuMmEYSbrxBcW1To9n+lSoNH50aVhF
         KKNMDhD6yWIegu755++paQcSLHCrAUMoc454zdd0=
Date:   Fri, 13 Aug 2021 13:14:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, liuhailong@oppo.com
Subject:  + mm-add-kernel_misc_reclaimable-in-show_free_areas.patch
 added to -mm tree
Message-ID: <20210813201418.V59yi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add kernel_misc_reclaimable in show_free_areas
has been added to the -mm tree.  Its filename is
     mm-add-kernel_misc_reclaimable-in-show_free_areas.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-kernel_misc_reclaimable-in-show_free_areas.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-kernel_misc_reclaimable-in-show_free_areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liuhailong <liuhailong@oppo.com>
Subject: mm: add kernel_misc_reclaimable in show_free_areas

Print NR_KERNEL_MISC_RECLAIMABLE stat from show_free_areas() so users can
check whether the shrinker is working correctly and to show the current
memory usage.

Link: https://lkml.kernel.org/r/20210813104725.4562-1-liuhailong@oppo.com
Signed-off-by: liuhailong <liuhailong@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-add-kernel_misc_reclaimable-in-show_free_areas
+++ a/mm/page_alloc.c
@@ -5903,6 +5903,7 @@ void show_free_areas(unsigned int filter
 		" unevictable:%lu dirty:%lu writeback:%lu\n"
 		" slab_reclaimable:%lu slab_unreclaimable:%lu\n"
 		" mapped:%lu shmem:%lu pagetables:%lu bounce:%lu\n"
+		" kernel_misc_reclaimable:%lu\n"
 		" free:%lu free_pcp:%lu free_cma:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
 		global_node_page_state(NR_INACTIVE_ANON),
@@ -5919,6 +5920,7 @@ void show_free_areas(unsigned int filter
 		global_node_page_state(NR_SHMEM),
 		global_node_page_state(NR_PAGETABLE),
 		global_zone_page_state(NR_BOUNCE),
+		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
 		global_zone_page_state(NR_FREE_CMA_PAGES));
_

Patches currently in -mm which might be from liuhailong@oppo.com are

mm-add-kernel_misc_reclaimable-in-show_free_areas.patch

