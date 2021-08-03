Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531A4C4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED6361037
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhHCWAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 18:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230124AbhHCWAB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 18:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A819E6104F;
        Tue,  3 Aug 2021 21:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027989;
        bh=2rT+SGou5Qvn8+3q42OH/Xi5Z53E0QZdcWeJqbRtpQU=;
        h=Date:From:To:Subject:From;
        b=UK/PIr8UkzkSBgrzbOV0zfTuCUkQjmAt/qrEv4rJ4iUizmfO3IpkmQ2kh3oKCnSjX
         U50UVbvzqvmpvKXFn0tTJCO9SwW7Zp79Xpq1fie1pweHid/4Izzozhk2jeAhxVElLg
         6D0cziIsr7qEaIJlvYwZggQ9xqEJwud/wVXQMLCM=
Date:   Tue, 03 Aug 2021 14:59:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, vbabka@suse.cz,
        rientjes@google.com, rdunlap@infradead.org,
        mike.kravetz@oracle.com, mhocko@suse.com, mhocko@kernel.org,
        mgorman@techsingularity.net, dave.hansen@linux.intel.com,
        dan.j.williams@intel.com, ben.widawsky@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, feng.tang@intel.com
Subject:  +
 mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
 added to -mm tree
Message-ID: <20210803215948.1IqG4%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

Add a dedicated function alloc_pages_preferred_many() for it just like for
'interleave' policy, which will be used by 2 general memoory allocation
APIs: alloc_pages() and alloc_pages_vma()

Link: https://lore.kernel.org/r/20200630212517.308045-9-ben.widawsky@intel.com
Link: https://lkml.kernel.org/r/1627970362-61305-3-git-send-email-feng.tang@intel.com
Suggested-by: Michal Hocko <mhocko@suse.com>
Originally-by: Ben Widawsky <ben.widawsky@intel.com>
Co-developed-by: Ben Widawsky <ben.widawsky@intel.com>
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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/mm/mempolicy.c~mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy
+++ a/mm/mempolicy.c
@@ -2166,6 +2166,27 @@ static struct page *alloc_page_interleav
 	return page;
 }
 
+static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
+						int nid, struct mempolicy *pol)
+{
+	struct page *page;
+	gfp_t preferred_gfp;
+
+	/*
+	 * This is a two pass approach. The first pass will only try the
+	 * preferred nodes but skip the direct reclaim and allow the
+	 * allocation to fail, while the second pass will try all the
+	 * nodes in system.
+	 */
+	preferred_gfp = gfp | __GFP_NOWARN;
+	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
+	page = __alloc_pages(preferred_gfp, order, nid, &pol->nodes);
+	if (!page)
+		page = __alloc_pages(gfp, order, numa_node_id(), NULL);
+
+	return page;
+}
+
 /**
  * alloc_pages_vma - Allocate a page for a VMA.
  * @gfp: GFP flags.
@@ -2201,6 +2222,12 @@ struct page *alloc_pages_vma(gfp_t gfp,
 		goto out;
 	}
 
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, node, pol);
+		mpol_cond_put(pol);
+		goto out;
+	}
+
 	if (unlikely(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hugepage)) {
 		int hpage_node = node;
 
@@ -2278,6 +2305,9 @@ struct page *alloc_pages(gfp_t gfp, unsi
 	 */
 	if (pol->mode == MPOL_INTERLEAVE)
 		page = alloc_page_interleave(gfp, order, interleave_nodes(pol));
+	else if (pol->mode == MPOL_PREFERRED_MANY)
+		page = alloc_pages_preferred_many(gfp, order,
+				numa_node_id(), pol);
 	else
 		page = __alloc_pages(gfp, order,
 				policy_node(gfp, pol, numa_node_id()),
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

