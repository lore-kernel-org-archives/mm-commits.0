Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D24AC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7404060E76
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349941AbhICU47 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232927AbhICU4z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7831A610D2;
        Fri,  3 Sep 2021 20:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702555;
        bh=8mgIb0ehVrsUfdyZVeraD8c10IhgHq5Ml5HuTmca+So=;
        h=Date:From:To:Subject:From;
        b=pytO9/w2+2Ha+Ac4B0YMgogJPAkVWoc8hKZtKijfwakfTBkgBF9KC2jiyHMjDmBkV
         Ija1jbyj/hBh3VH1BTnbotOWHhxl0PNqcrn4BAp22W4Hrw1rTQe88Qkqa7AwgflVYa
         mLKSyZNTjb02AQuy17v5AZ8cTvc/jyYUVEJVbsD8=
Date:   Fri, 03 Sep 2021 13:55:55 -0700
From:   akpm@linux-foundation.org
To:     liuhailong@oppo.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-add-kernel_misc_reclaimable-in-show_free_areas.patch removed from -mm
 tree
Message-ID: <20210903205555.E1MR_3PAz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add kernel_misc_reclaimable in show_free_areas
has been removed from the -mm tree.  Its filename was
     mm-add-kernel_misc_reclaimable-in-show_free_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


