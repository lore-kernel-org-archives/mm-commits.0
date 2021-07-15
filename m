Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CF7C1B08C
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 203F2613CB
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 00:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhGOATv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Jul 2021 20:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbhGOATv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Jul 2021 20:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0636B61361;
        Thu, 15 Jul 2021 00:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626308219;
        bh=wq72dwMFSA6KB8dKZaq+hFOdmCXTEP/H6WKjw3MzTME=;
        h=Date:From:To:Subject:From;
        b=O9G4644RQMgaRhs5h1WC61k7Kvjm9Xtgs2WR5udNUBw+flr2mjHOcls5Eks1Y+uBj
         UhuACLKgzVYd7SKGv/+Ks//WEc5Nn+nNr9jlNcDORVwqabAgABvsQVyGuJQf80Po/I
         2hf6SwBdKzxnqA4AXpZCTff1uZfqiGbaIU1W5K7I=
Date:   Wed, 14 Jul 2021 17:16:58 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, ak@linux.intel.com, ben.widawsky@intel.com,
        dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        feng.tang@intel.com, mgorman@techsingularity.net,
        mhocko@kernel.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        rientjes@google.com, vbabka@suse.cz, ying.huang@intel.com
Subject:  +
 =?US-ASCII?Q?mm-memplicy-add-page-allocation-function-for-mpol=5Fpreferr?=
 =?US-ASCII?Q?ed=5Fmany-policy.patch?= added to -mm tree
Message-ID: <20210715001658.uvP-TAiyO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy
has been added to the -mm tree.  Its filename is
     mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/memplicy: add page allocation function for MPOL_PREFERRED_MANY policy

The semantics of MPOL_PREFERRED_MANY is similar to MPOL_PREFERRED, that it
will first try to allocate memory from the preferred node(s), and fallback
to all nodes in system when first try fails.

Add a dedicated function for it just like 'interleave' policy.

Link: https://lore.kernel.org/r/20200630212517.308045-9-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1626077374-81682-3-git-send-email-feng.tang@intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Co-developed-by: Ben Widawsky <ben.widawsky@intel.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/mempolicy.c~mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -2153,6 +2153,25 @@ static struct page *alloc_page_interleav
 	return page;
 }
 
+static struct page *alloc_page_preferred_many(gfp_t gfp, unsigned int order,
+						struct mempolicy *pol)
+{
+	struct page *page;
+
+	/*
+	 * This is a two pass approach. The first pass will only try the
+	 * preferred nodes but skip the direct reclaim and allow the
+	 * allocation to fail, while the second pass will try all the
+	 * nodes in system.
+	 */
+	page = __alloc_pages(((gfp | __GFP_NOWARN) & ~__GFP_DIRECT_RECLAIM),
+				order, first_node(pol->nodes), &pol->nodes);
+	if (!page)
+		page = __alloc_pages(gfp, order, numa_node_id(), NULL);
+
+	return page;
+}
+
 /**
  * alloc_pages_vma - Allocate a page for a VMA.
  * @gfp: GFP flags.
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

