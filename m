Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0659BCDB465
	for <mm-commits@archiver.kernel.org>; Sat, 14 Oct 2023 22:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbjJNWQM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Oct 2023 18:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJNWQL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 14 Oct 2023 18:16:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258C1D8
        for <mm-commits@vger.kernel.org>; Sat, 14 Oct 2023 15:16:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7FDC433C8;
        Sat, 14 Oct 2023 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697321769;
        bh=1N4JOwGXnvS6guB7XGxWwLpmWb5SHtkqCCnWHnf5ap0=;
        h=Date:To:From:Subject:From;
        b=2QLIO31QvnVYxXySOLUchdeEHdXjNrDIjUFBJ5ef40ah7C+ZMALEVVEGAkVjGTrya
         Del40MvLDjPEDwFpePOPINhF10AiosfM5JjJj/XW6qaMqURL9VfGcnngDaoirTtl97
         5QbO6NQbOd/+/RZSz/h+eOYKLiZAoO2YT5HI9iQ4=
Date:   Sat, 14 Oct 2023 15:16:05 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, raquini@redhat.com,
        djakov@kernel.org, audra@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-remove-free_ts-from-page_owner-output.patch added to mm-unstable branch
Message-Id: <20231014221609.1B7FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: remove free_ts from page_owner output
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-remove-free_ts-from-page_owner-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-remove-free_ts-from-page_owner-output.patch

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
From: Audra Mitchell <audra@redhat.com>
Subject: mm/page_owner: remove free_ts from page_owner output
Date: Fri, 13 Oct 2023 15:03:45 -0400

Patch series "Fix page_owner's use of free timestamps".

While page ower output is used to investigate memory utilization,
typically the allocation pathway, the introduction of timestamps to the
page owner records caused each record to become unique due to the
granularity of the nanosecond timestamp (for example):

  Page allocated via order 0 ... ts 5206196026 ns, free_ts 5187156703 ns
  Page allocated via order 0 ... ts 5206198540 ns, free_ts 5187162702 ns

Furthermore, the page_owner output only dumps the currently allocated
records, so having the free timestamps is nonsensical for the typical use
case.

In addition, the introduction of timestamps was not properly handled in
the page_owner_sort tool causing most use cases to be broken.  This series
is meant to remove the free timestamps from the page_owner output and fix
the page_owner_sort tool so proper collation can occur.


This patch (of 5):

When printing page_owner data via the sysfs interface, no free pages will
ever be dumped due to the series of checks in read_page_owner():

    /*
     * Although we do have the info about past allocation of free
     * pages, it's not relevant for current memory usage.
     */
     if (!test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags))

The free_ts values are still used when dump_page_owner() is called, so
keeping the field for other use cases but removing them for the typical
page_owner case.

Link: https://lkml.kernel.org/r/20231013190350.579407-1-audra@redhat.com
Link: https://lkml.kernel.org/r/20231013190350.579407-2-audra@redhat.com
Fixes: 866b48526217 ("mm/page_owner: record the timestamp of all pages during free")
Signed-off-by: Audra Mitchell <audra@redhat.com>
Cc: Georgi Djakov <djakov@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-remove-free_ts-from-page_owner-output
+++ a/mm/page_owner.c
@@ -408,11 +408,11 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns, free_ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
 			page_owner->tgid, page_owner->comm,
-			page_owner->ts_nsec, page_owner->free_ts_nsec);
+			page_owner->ts_nsec);
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
_

Patches currently in -mm which might be from audra@redhat.com are

mm-page_owner-remove-free_ts-from-page_owner-output.patch
tools-mm-remove-references-to-free_ts-from-page_owner_sort.patch
tools-mm-filter-out-timestamps-for-correct-collation.patch
tools-mm-fix-the-default-case-for-page_owner_sort.patch
tools-mm-update-the-usage-output-to-be-more-organized.patch

