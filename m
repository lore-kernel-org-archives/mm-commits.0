Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDD6C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  6 Dec 2023 20:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442865AbjLFUJs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 6 Dec 2023 15:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442877AbjLFUJr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Dec 2023 15:09:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC7CD7F
        for <mm-commits@vger.kernel.org>; Wed,  6 Dec 2023 12:09:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CCBC433C8;
        Wed,  6 Dec 2023 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701893392;
        bh=zy4VsPgWJNpbF+4Dz/jiIXXRqrbpmwUGGlbyqK7aw0A=;
        h=Date:To:From:Subject:From;
        b=PRpXnkEH6+kZMmtJZPq285r0PH5rH7SsIXTNGkkuQ+8rBBjZIde4AGVzPbFPfCOtz
         nrMM0U6d++mfUTN0LEhFqRni5md5jPemB4eaV8NH5LiEy4buOtcOVSfz3RcmerIioF
         uprugzBLnWAwq+n0VMniAZ6cccFQAbmx81CKwJrc=
Date:   Wed, 06 Dec 2023 12:09:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        v-songbaohua@oppo.com, shikemeng@huaweicloud.com,
        mgorman@techsingularity.net, huzhanyuan@oppo.com,
        hannes@cmpxchg.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, 21cnbao@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch added to mm-unstable branch
Message-Id: <20231206200952.D2CCBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: avoid fast_isolate_freepages blindly choose improper pageblock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm: compaction: avoid fast_isolate_freepages blindly choose improper pageblock
Date: Thu, 7 Dec 2023 00:00:54 +1300

Testing shows fast_isolate_freepages can blindly choose an unsuitable
pageblock from time to time particularly while the min mark is used from
XXX path:

 if (!page) {
         cc->fast_search_fail++;
         if (scan_start) {
                 /*
                  * Use the highest PFN found above min. If one was
                  * not found, be pessimistic for direct compaction
                  * and use the min mark.
                  */
                 if (highest >= min_pfn) {
                         page = pfn_to_page(highest);
                         cc->free_pfn = highest;
                 } else {
                         if (cc->direct_compaction && pfn_valid(min_pfn)) { /* XXX */
                                 page = pageblock_pfn_to_page(min_pfn,
                                         min(pageblock_end_pfn(min_pfn),
                                             zone_end_pfn(cc->zone)),
                                         cc->zone);
                                 cc->free_pfn = min_pfn;
                         }
                 }
         }
 }

The reason is that no code is doing any check on the min_pfn
 min_pfn = pageblock_start_pfn(cc->free_pfn - (distance >> 1));

In contrast, slow path of isolate_freepages() is always skipping
unsuitable pageblocks in a decent way.

This issue doesn't happen quite often.  When running 25 machines with
16GiB memory for one night, most of them can hit this unexpected code
path.  However the frequency isn't like many times per second.  It might
be one time in a couple of hours.  Thus, it is very hard to measure the
visible performance impact in my machines though the affection of choosing
the unsuitable migration_target should be negative in theory.

I feel it's still worth fixing this to at least make the code
theoretically self-explanatory as it is quite odd an unsuitable
migration_target can be still migration_target.

Link: https://lkml.kernel.org/r/20231206110054.61617-1-v-songbaohua@oppo.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reported-by: Zhanyuan Hu <huzhanyuan@oppo.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/compaction.c~mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock
+++ a/mm/compaction.c
@@ -1611,6 +1611,9 @@ static void fast_isolate_freepages(struc
 						min(pageblock_end_pfn(min_pfn),
 						    zone_end_pfn(cc->zone)),
 						cc->zone);
+					if (page && !suitable_migration_target(cc, page))
+						page = NULL;
+
 					cc->free_pfn = min_pfn;
 				}
 			}
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-page_owner-record-and-dump-free_pid-and-free_tgid.patch
mm-compaction-avoid-fast_isolate_freepages-blindly-choose-improper-pageblock.patch

