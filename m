Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F9EC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLAAIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiLAAGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE1CE0A
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CED71B81D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731D5C433D6;
        Thu,  1 Dec 2022 00:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852952;
        bh=jgQbE7ebSSY1Zn9wSrCPdwdiUdqV2coZW2uezcOTARU=;
        h=Date:To:From:Subject:From;
        b=Gh3j9VT+IpRs6tNkdM3tSOXsZG4JwaBAzGevup3NtFb3Suh5igRUwLJTbLL+g+wf/
         bIPNE4F7LO/1zrRzljv4P6cdlK63e/+GyX62hYsMuK1MOpOou1wIM+UF1pijwmKBzy
         Vg54dpZGCbW0bq7Kv/JW6MYw4wVUF+2nvyeXTqi8=
Date:   Wed, 30 Nov 2022 16:02:31 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, vbabka@suse.cz,
        mtosatti@redhat.com, m.szyprowski@samsung.com, mhocko@kernel.org,
        hughd@google.com, mgorman@techsingularity.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-always-remove-pages-from-temporary-list.patch removed from -mm tree
Message-Id: <20221201000232.731D5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: always remove pages from temporary list
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-always-remove-pages-from-temporary-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3553,6 +3553,8 @@ void free_unref_page_list(struct list_he
 	list_for_each_entry_safe(page, next, list, lru) {
 		struct zone *zone = page_zone(page);
 
+		list_del(&page->lru);
+
 		/* Different zone, different pcp lock. */
 		if (zone != locked_zone) {
 			if (pcp)
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


