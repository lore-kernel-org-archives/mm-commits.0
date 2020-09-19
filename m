Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1420DC43463
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32C8221EC
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475085;
	bh=gW3MkLqE2sZHv4lQ/DwG9KbnpnNE5D4Zxw2pmHUDTUk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RZSPgDOqYtgNmovHIKNp5bJ4fXs8Nx8bVLjaYx20gFXFZUtojWhYY5T0RBph3YgNF
	 cFi7xo6OrerlKtyPHwEP9borWlIOcAVw9Mqn9TgcRlGgRpG2kZvfFLyhxCe06ePnda
	 5zOtiViepy+BZs2u1Ibx/bh8FLyw9rChd+AJK3Hc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgISAYp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:45 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 186F221D43;
        Sat, 19 Sep 2020 00:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475084;
        bh=gW3MkLqE2sZHv4lQ/DwG9KbnpnNE5D4Zxw2pmHUDTUk=;
        h=Date:From:To:Subject:From;
        b=XSGomvX8JshW7dty9qM1ey7RMwhs9vXElKTE+UJjG3yXoGnkE+z2+/bBkuVHRtCjT
         He4LgJ71aSZ/0hisDuBrEfjdJJmK2AMpuBDssXkN2r4zZMl/h392jithSQHF0zY3Os
         aVV9CEkvDPVq4i+e59opBgQUY0xAi44itElgyfHY=
Date:   Fri, 18 Sep 2020 17:24:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com,
        cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  [to-be-updated]
 mmhwpoison-introduce-mf_msg_unsplit_thp.patch removed from -mm tree
Message-ID: <20200919002443.WFaVw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: introduce MF_MSG_UNSPLIT_THP
has been removed from the -mm tree.  Its filename was
     mmhwpoison-introduce-mf_msg_unsplit_thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: introduce MF_MSG_UNSPLIT_THP

memory_failure() is supposed to call action_result() when it handles a
memory error event, but there's one missing case.  So let's add it.

I find that include/ras/ras_event.h has some other MF_MSG_* undefined, so
this patch also adds them.

Link: http://lkml.kernel.org/r/20200806184923.7007-12-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    1 +
 include/ras/ras_event.h |    3 +++
 mm/memory-failure.c     |    5 ++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mmhwpoison-introduce-mf_msg_unsplit_thp
+++ a/include/linux/mm.h
@@ -3054,6 +3054,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_BUDDY_2ND,
 	MF_MSG_DAX,
+	MF_MSG_UNSPLIT_THP,
 	MF_MSG_UNKNOWN,
 };
 
--- a/include/ras/ras_event.h~mmhwpoison-introduce-mf_msg_unsplit_thp
+++ a/include/ras/ras_event.h
@@ -361,6 +361,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_POISONED_HUGE, "huge page already hardware poisoned" )	\
 	EM ( MF_MSG_HUGE, "huge page" )					\
 	EM ( MF_MSG_FREE_HUGE, "free huge page" )			\
+	EM ( MF_MSG_NON_PMD_HUGE, "non-pmd-sized huge page" )		\
 	EM ( MF_MSG_UNMAP_FAILED, "unmapping failed page" )		\
 	EM ( MF_MSG_DIRTY_SWAPCACHE, "dirty swapcache page" )		\
 	EM ( MF_MSG_CLEAN_SWAPCACHE, "clean swapcache page" )		\
@@ -373,6 +374,8 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_TRUNCATED_LRU, "already truncated LRU page" )	\
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_BUDDY_2ND, "free buddy page (2nd try)" )		\
+	EM ( MF_MSG_DAX, "dax page" )					\
+	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
--- a/mm/memory-failure.c~mmhwpoison-introduce-mf_msg_unsplit_thp
+++ a/mm/memory-failure.c
@@ -584,6 +584,7 @@ static const char * const action_page_ty
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_BUDDY_2ND]		= "free buddy page (2nd try)",
 	[MF_MSG_DAX]			= "dax page",
+	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1372,8 +1373,10 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (PageTransHuge(hpage)) {
-		if (try_to_split_thp_page(p, "Memory Failure") < 0)
+		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			return -EBUSY;
+		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-double-check-page-count-in-__get_any_page.patch

