Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585B9C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 21:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiKRVhu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiKRVht (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 16:37:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA94AA4641
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 13:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8290CB8255A
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 21:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB79C433D6;
        Fri, 18 Nov 2022 21:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668807466;
        bh=nqKPHgra0aXh7rFB/f5YtSgjXcXM8UEziiCnEX0FdGY=;
        h=Date:To:From:Subject:From;
        b=vWTOAvZi1bKbh4tgzzEhOOyXzVsdqYo83pcCfCYo5ptasuoMZcADTwHa8tVSzvipt
         vN0P2jcbeK7Slq/dFQveSAUihd876NxWTs4fGYzq5rQRrbza9oZQUpOfIfU2QCAvlD
         BRdS0HCRBAuMNne7HUjkDFDjnjoF4JtQqQ6p7kgw=
Date:   Fri, 18 Nov 2022 13:37:45 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        mtosatti@redhat.com, m.szyprowski@samsung.com, mhocko@kernel.org,
        hughd@google.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-always-remove-pages-from-temporary-list.patch added to mm-unstable branch
Message-Id: <20221118213746.2CB79C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: always remove pages from temporary list
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-always-remove-pages-from-temporary-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-always-remove-pages-from-temporary-list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: always remove pages from temporary list
Date: Fri, 18 Nov 2022 10:17:13 +0000

Patch series "Leave IRQs enabled for per-cpu page allocations", v3.


This patch (of 2):

free_unref_page_list() has neglected to remove pages properly from the
list of pages to free since forever.  It works by coincidence because
list_add happened to do the right thing adding the pages to just the PCP
lists.  However, a later patch added pages to either the PCP list or the
zone list but only properly deleted the page from the list in one path
leading to list corruption and a subsequent failure.  As a preparation
patch, always delete the pages from one list properly before adding to
another.  On its own, this fixes nothing although it adds a fractional
amount of overhead but is critical to the next patch.

Link: https://lkml.kernel.org/r/20221118101714.19590-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20221118101714.19590-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-always-remove-pages-from-temporary-list
+++ a/mm/page_alloc.c
@@ -3568,6 +3568,8 @@ void free_unref_page_list(struct list_he
 	list_for_each_entry_safe(page, next, list, lru) {
 		struct zone *zone = page_zone(page);
 
+		list_del(&page->lru);
+
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
 			if (pcp)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-always-remove-pages-from-temporary-list.patch
mm-page_alloc-leave-irqs-enabled-for-per-cpu-page-allocations.patch

