Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A07C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 00:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1D961ABF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 00:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbhKPA40 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245630AbhKOTU5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4947632E7;
        Mon, 15 Nov 2021 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637001502;
        bh=hSZ/4un2bLwzmRExKgVLSyWLXlf3FjUSDxKhmfcYVDc=;
        h=Date:From:To:Subject:From;
        b=YIoVSXAGfiGgbLsS76uHP4vyGdCk5laS7cRs9ouIDm3UOMrEpXlC1RqDZhpmv+JmK
         dbYwS5uC+CMA/X0tp5RCG/OSFXOEcbfLzBmPMnH3NcPW1qwtjtaRz5Aqe+JqUOQtSs
         AbwDFoQGjT8T7XVzmWfocxY3A1roFvIICs5NHnEQ=
Date:   Mon, 15 Nov 2021 10:38:21 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, david@redhat.com,
        dinghui@sangfor.com.cn, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        tony.luck@intel.com
Subject:  +
 mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch added to
 -mm tree
Message-ID: <20211115183821.HIcCZPmSV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: remove MF_MSG_BUDDY_2ND and MF_MSG_POISONED_HUGE
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3247,7 +3247,6 @@ enum mf_action_page_type {
 	MF_MSG_KERNEL_HIGH_ORDER,
 	MF_MSG_SLAB,
 	MF_MSG_DIFFERENT_COMPOUND,
-	MF_MSG_POISONED_HUGE,
 	MF_MSG_HUGE,
 	MF_MSG_FREE_HUGE,
 	MF_MSG_NON_PMD_HUGE,
@@ -3262,7 +3261,6 @@ enum mf_action_page_type {
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
@@ -722,7 +722,6 @@ static const char * const action_page_ty
 	[MF_MSG_KERNEL_HIGH_ORDER]	= "high-order kernel page",
 	[MF_MSG_SLAB]			= "kernel slab page",
 	[MF_MSG_DIFFERENT_COMPOUND]	= "different compound page after locking",
-	[MF_MSG_POISONED_HUGE]		= "huge page already hardware poisoned",
 	[MF_MSG_HUGE]			= "huge page",
 	[MF_MSG_FREE_HUGE]		= "free huge page",
 	[MF_MSG_NON_PMD_HUGE]		= "non-pmd-sized huge page",
@@ -737,7 +736,6 @@ static const char * const action_page_ty
 	[MF_MSG_CLEAN_LRU]		= "clean LRU page",
 	[MF_MSG_TRUNCATED_LRU]		= "already truncated LRU page",
 	[MF_MSG_BUDDY]			= "free buddy page",
-	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
 	[MF_MSG_UNKNOWN]		= "unknown page",
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-mf_mutex-for-soft-offline-and-unpoison.patch
mm-hwpoison-remove-mf_msg_buddy_2nd-and-mf_msg_poisoned_huge.patch
mm-hwpoison-fix-unpoison_memory.patch

