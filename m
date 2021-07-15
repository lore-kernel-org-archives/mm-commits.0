Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A13C12002
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07308613D0
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbhGOAT4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 20:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbhGOATy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 20:19:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02906613CB;
        Thu, 15 Jul 2021 00:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626308222;
        bh=zwZj4MFfEymVcP0BGSlccXxw2bFbz1S3pJ5bR7Dr3ms=;
        h=Date:From:To:Subject:From;
        b=AGy1f8dxHYPyJJHrg/zbbUojBf1Bq4g/OOhtYqzwxizNEq9pxaniTiYF8TGxR6iCb
         MWikGnTGt6VGH2ikHgkoDaQU3e5P4vQ38dGyqKv5RIGKH8Z+B1P9jOBpI0SjtzBUeS
         Jf3fX39F0tH0GGtdwDkvRSBRXKHVwQu3oayxJfG8=
Date:   Wed, 14 Jul 2021 17:17:01 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-mempolicy-enable-page-allocation-for-mpol=5Fpreferred=5F?=
 =?US-ASCII?Q?many-for-general-cases.patch?= added to -mm tree
Message-ID: <20210715001701.W_fVwxaTj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: enable page allocation for MPOL_PREFERRED_MANY for general cases
has been added to the -mm tree.  Its filename is
     mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/mempolicy: enable page allocation for MPOL_PREFERRED_MANY for general cases

In order to support MPOL_PREFERRED_MANY which is used by set_mempolicy(2),
mbind(2), enable both alloc_pages() and alloc_pages_vma() by using
alloc_page_preferred_many().

Link: https://lkml.kernel.org/r/1626077374-81682-4-git-send-email-feng.tang@intel.com
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases
+++ a/mm/mempolicy.c
@@ -2207,6 +2207,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		goto out;
 	}
 
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_page_preferred_many(gfp, order, pol);
+		mpol_cond_put(pol);
+		goto out;
+	}
+
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
 		int hpage_node = node;
 
@@ -2286,6 +2292,8 @@ struct page *alloc_pages(gfp_t gfp, unsi
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else if (pol->mode == MPOL_PREFERRED_MANY)
+		page = alloc_page_preferred_many(gfp, order, pol);
 	else
 		page = __alloc_pages(gfp, order,
 				policy_node(gfp, pol, numa_node_id()),
_

Patches currently in -mm which might be from ben.widawsky@intel.com are

mm-mempolicy-enable-page-allocation-for-mpol_preferred_many-for-general-cases.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many.patch
mm-mempolicy-advertise-new-mpol_preferred_many.patch

