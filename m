Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363E8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AEBC22B43
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225944;
	bh=LqKpqXrLYXJfeqkm0sCHnlXtzc988B9nVz66A30Z9s0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=qmSQDFWSDfF3zFZK++oCVJWaRu0kDZOqLW8l3ZsOCsBjI69T5VFPxjMuY7oXp/RxE
	 aofA9p7mkDoYiZ6yDWwoUnR7uYCN+vl+9eKKEegpoqEctAjI7TXZFoo4cX0VgvP7ww
	 krwt4UDJhSdUC8WlxYjukqiFIRWB62+Eqbp6YawA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgGaUFn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGaUFn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:05:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC41622B42;
        Fri, 31 Jul 2020 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225942;
        bh=LqKpqXrLYXJfeqkm0sCHnlXtzc988B9nVz66A30Z9s0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TKC44xe4r2644cFA8i/35nT9Wxt4EXtieDxUjiow1AwhK9i1XsutSUQbROlugLrte
         RiBCLsc9n+CAB7aGP5t24wkrZ/VUBCY+7oYNO4ss0jKwhwrVLRJNUoUQb4lotdHuk9
         5dZ2w1usLa44k+GKLX5lWN6CG3+KOe/qVtBBVKkE=
Date:   Fri, 31 Jul 2020 13:05:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mm-hwpoison-remove-recalculating-hpage.patch added to
 -mm tree
Message-ID: <20200731200541.xBUIlKZxd%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: remove recalculating hpage
has been added to the -mm tree.  Its filename is
     mm-hwpoison-remove-recalculating-hpage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-remove-recalculating-hpage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-remove-recalculating-hpage.patch

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
Subject: mm, hwpoison: remove recalculating hpage

hpage is never used after try_to_split_thp_page() in memory_failure(), so
we don't have to update hpage.  So let's not recalculate/use hpage.

Link: http://lkml.kernel.org/r/20200731122112.11263-3-nao.horiguchi@gmail.com
Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-recalculating-hpage
+++ a/mm/memory-failure.c
@@ -1342,7 +1342,6 @@ int memory_failure(unsigned long pfn, in
 		}
 		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
-		hpage = compound_head(p);
 	}
 
 	/*
@@ -1414,11 +1413,8 @@ int memory_failure(unsigned long pfn, in
 	/*
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
-	 *
-	 * When the raw error page is thp tail page, hpage points to the raw
-	 * page after thp split.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &hpage)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

