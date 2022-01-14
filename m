Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B859BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiANWJL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiANWJK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3D7C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF615CE2497
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50BDC36AE9;
        Fri, 14 Jan 2022 22:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198147;
        bh=d6K5UYoNfBteh//DxGgqdVWBJmQMdSLVG9nyQrxvyWA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DQSQW6b3nU6Zoe5EQy1mNhG1Hksqn45qz/MOtNi3OmcIRh6P8n1VOn3zZEHBrPJjN
         7VTp4GbTCXfybP2mV12xLb2CoV1mLNqb3lj5fVNoBQVu4A5gcTgBxHvNIVhpqrms6D
         itWgpGRon7Wi8Ar6QwQ6goGpIKn12W9ZK2vWuIBk=
Date:   Fri, 14 Jan 2022 14:09:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        david@redhat.com, dinghui@sangfor.com.cn, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, peterx@redhat.com,
        shy828301@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org
Subject:  [patch 112/146] mm/hwpoison: remove MF_MSG_BUDDY_2ND and
 MF_MSG_POISONED_HUGE
Message-ID: <20220114220906.qMYr-bmbz%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: remove MF_MSG_BUDDY_2ND and MF_MSG_POISONED_HUGE

These action_page_types are no longer used, so remove them.

Link: https://lkml.kernel.org/r/20211115084006.3728254-3-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ding Hui <dinghui@sangfor.com.cn>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    2 --
 include/ras/ras_event.h |    2 --
 mm/memory-failure.c     |    2 --
 3 files changed, 6 deletions(-)

--- a/include/linux/mm.h~mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge
+++ a/include/linux/mm.h
@@ -3201,7 +3201,6 @@ enum mf_action_page_type {
 	MF_MSG_KERNEL_HIGH_ORDER,
 	MF_MSG_SLAB,
 	MF_MSG_DIFFERENT_COMPOUND,
-	MF_MSG_POISONED_HUGE,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
 	MF_MSG_NON_PMD_HUGE,
@@ -3216,7 +3215,6 @@ enum mf_action_page_type {
 	MF_MSG_CLEAN_LRU,
 	MF_MSG_TRUNCATED_LRU,
 	MF_MSG_BUDDY,
-	MF_MSG_BUDDY_2ND,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
 	MF_MSG_UNKNOWN,
--- a/include/ras/ras_event.h~mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge
+++ a/include/ras/ras_event.h
@@ -358,7 +358,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_KERNEL_HIGH_ORDER, "high-order kernel page" )	\
 	EM ( MF_MSG_SLAB, "kernel slab page" )				\
 	EM ( MF_MSG_DIFFERENT_COMPOUND, "different compound page after locking" ) \
-	EM ( MF_MSG_POISONED_HUGE, "huge page already hardware poisoned" )	\
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
 	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
@@ -373,7 +372,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_CLEAN_LRU, "clean LRU page" )			\
 	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
-	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
--- a/mm/memory-failure.c~mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge
+++ a/mm/memory-failure.c
@@ -723,7 +723,6 @@ static const char * const action_page_ty
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
 	[MF_MSG_SLAB]			= "kernel slab page",
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
-	[MF_MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
 	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
@@ -738,7 +737,6 @@ static const char * const action_page_ty
 	[MF_MSG_CLEAN_LRU]		= "clean LRU page",
 	[MF_MSG_TRUNCATED_LRU]		= "already truncated LRU page",
 	[MF_MSG_BUDDY]			= "free buddy page",
-	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
 	[MF_MSG_UNKNOWN]		= "unknown page",
_
