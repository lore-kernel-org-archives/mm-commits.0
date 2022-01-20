Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C80BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377880AbiATV1w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:27:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58704 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347854AbiATV1w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:27:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4283AB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3E2C340E0;
        Thu, 20 Jan 2022 21:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714070;
        bh=x7Q8tJDPu4F8i+tMn3863QnzzdAd+MJkoO6W1yqo+vc=;
        h=Date:From:To:Subject:From;
        b=Cm9jq1ASgzMJ49lR4AzrU8dCeFHp0Bj6KrOBf5/9H9w5JinWaf/W/ikllFqCg45gD
         4Rr1OD1K0glGOB27joZcN7kiwhmmKfs5jqcuvSd+UQaocXfp7MLQvsC73yRGamvJES
         2Ia+zAhSCXWpv8tRpYNlI96B7Q9xmMfAYINgpL6Q=
Date:   Thu, 20 Jan 2022 13:27:49 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, david@redhat.com,
        dinghui@sangfor.com.cn, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        tony.luck@intel.com
Subject:  [merged]
 mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch removed
 from -mm tree
Message-ID: <20220120212749.Wm5F-03uQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: remove MF_MSG_BUDDY_2ND and MF_MSG_POISONED_HUGE
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from naoya.horiguchi@nec.com are


