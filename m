Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F062C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36C8208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816223;
	bh=rWmAolaxr1XUYqz0jyTGHhrwEsjidd9ZgOZa/Xkwvds=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=mghB24uaAtHtxTVeUrgIScyzuJ6iMNPN/iRMEi4kdOVMnbfMksGXyztzgBkCFaroN
	 TOY8YITuU6IOaD+lmLMFc3EKzWrsuLFQJfoW8+nrK06dobz3UENKCxTmDtMeaS4IH2
	 /ciE3TrqzW+yx3cvxxy4AWs8pTmO+9ZeCe3vu1lY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393826AbgJPCnm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393825AbgJPCnm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B139C2087D;
        Fri, 16 Oct 2020 02:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816220;
        bh=rWmAolaxr1XUYqz0jyTGHhrwEsjidd9ZgOZa/Xkwvds=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2UdyYP/j+7El2KqnxLTCGyMz9sutG9tdyWIGX+jbp+6Nmk4mSvLVp7elxYShCJ3ER
         C1etUBbcbDMHcu0mWzZykwZ+EvNAEmEWQ25xH1R0/8HluZccdQfwwaMfKh+QQjDcni
         vlBr0JVVdmJz4SkDqur9va0yiEzH6zorpzxu43OA=
Date:   Thu, 15 Oct 2020 19:43:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, zeil@yandex-team.ru
Subject:  [patch 045/156] mm,hwpoison: refactor
 madvise_inject_error
Message-ID: <20201016024339.YXcYwwUKV%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: refactor madvise_inject_error

Make a proper if-else condition for {hard,soft}-offline.

Link: https://lkml.kernel.org/r/20200908075626.11976-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/mm/madvise.c~mmhwpoison-refactor-madvise_inject_error
+++ a/mm/madvise.c
@@ -872,7 +872,6 @@ static long madvise_remove(struct vm_are
 static int madvise_inject_error(int behavior,
 		unsigned long start, unsigned long end)
 {
-	struct page *page;
 	struct zone *zone;
 	unsigned long size;
 
@@ -882,6 +881,7 @@ static int madvise_inject_error(int beha
 
 	for (; start < end; start += size) {
 		unsigned long pfn;
+		struct page *page;
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &page);
@@ -903,25 +903,21 @@ static int madvise_inject_error(int beha
 
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
-					pfn, start);
-
+				 pfn, start);
 			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
-			if (ret)
-				return ret;
-			continue;
+		} else {
+			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
+				 pfn, start);
+			/*
+			 * Drop the page reference taken by get_user_pages_fast(). In
+			 * the absence of MF_COUNT_INCREASED the memory_failure()
+			 * routine is responsible for pinning the page to prevent it
+			 * from being released back to the page allocator.
+			 */
+			put_page(page);
+			ret = memory_failure(pfn, 0);
 		}
 
-		pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
-				pfn, start);
-
-		/*
-		 * Drop the page reference taken by get_user_pages_fast(). In
-		 * the absence of MF_COUNT_INCREASED the memory_failure()
-		 * routine is responsible for pinning the page to prevent it
-		 * from being released back to the page allocator.
-		 */
-		put_page(page);
-		ret = memory_failure(pfn, 0);
 		if (ret)
 			return ret;
 	}
_
