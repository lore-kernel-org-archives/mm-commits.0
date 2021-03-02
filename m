Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28BBC433E0
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE2164E38
	for <mm-commits@archiver.kernel.org>; Wed,  3 Mar 2021 13:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378765AbhCCN1b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 08:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232372AbhCBX5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Mar 2021 18:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A3CD64F4E;
        Tue,  2 Mar 2021 23:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614728782;
        bh=8ux2Xq/3bk6HQTLdiGu/Czu51sddYS08Jn8zGcfbzWQ=;
        h=Date:From:To:Subject:From;
        b=JFfhG8+SWmcQrT+pLtRpQFet1mE1izS8aHYQP4XpwwT59tAgFO9XLmm/++9saWDa/
         mmNqR1ylCnJTdRm/mcLBAhsYBuF12etbNAd6K784zb+fQ8M/T5hcyk+ryzj/uNywPR
         ela4pfiYBjxQIGgT0SNLBsW2/XSAAxNI4VOVBS28=
Date:   Tue, 02 Mar 2021 15:46:21 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, osalvador@suse.de, vbabka@suse.cz,
        ziy@nvidia.com
Subject:  +
 mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch added to
 -mm tree
Message-ID: <20210302234621.tH3PZjrL9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: drop pr_info_ratelimited() in alloc_contig_range()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: drop pr_info_ratelimited() in alloc_contig_range()

The information that some PFNs are busy is:

a) not helpful for ordinary users: we don't even know *who* called
   alloc_contig_range(). This is certainly not worth a pr_info.*().

b) not really helpful for debugging: we don't have any details *why*
   these PFNs are busy, and that is what we usually care about.

c) not complete: there are other cases where we fail alloc_contig_range()
   using different paths that are not getting recorded.

For example, we reach this path once we succeeded in isolating pageblocks,
but failed to migrate some pages - which can happen easily on ZONE_NORMAL
(i.e., has_unmovable_pages() is racy) but also on ZONE_MOVABLE i.e., we
would have to retry longer to migrate).

For example via virtio-mem when unplugging memory, we can create quite
some noise (especially with ZONE_NORMAL) that is not of interest to users
- it's expected that some allocations may fail as memory is busy.

Let's just drop that pr_info_ratelimit() and rather implement a dynamic
debugging mechanism in the future that can give us a better reason why
alloc_contig_range() failed on specific pages.

Link: https://lkml.kernel.org/r/20210301150945.77012-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range
+++ a/mm/page_alloc.c
@@ -8624,8 +8624,6 @@ int alloc_contig_range(unsigned long sta
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, 0)) {
-		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
-			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
 	}
_

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-drop-pr_info_ratelimited-in-alloc_contig_range.patch

