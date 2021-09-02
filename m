Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD743C00306
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D9D61185
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347741AbhIBVyL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347843AbhIBVyA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8660C61151;
        Thu,  2 Sep 2021 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619581;
        bh=vBOkoxaMZ3L6fYvAz0cv+i2rEEHul6A8wwII0QkKxdE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=klRAm3zk1rFBRfzBx/AS9ne5vAET9Zza3hZK4qom25UWiGshBt04XcazcanfO31nc
         Gy/VFUtRzIdM1Kr7rEgZL7E2dMMU3uEoEtQFrngL2TI9NpLxb2KeIYrkUzOS/A0x8l
         j4a0X2Ho5zbvw0WvCU/XlRAB3Ovrvs4lfIQxb0IU=
Date:   Thu, 02 Sep 2021 14:53:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, liuhailong@oppo.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 057/212] mm: add kernel_misc_reclaimable in
 show_free_areas
Message-ID: <20210902215301.Wf_oYDPc3%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
