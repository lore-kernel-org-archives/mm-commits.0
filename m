Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029FBC46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjATF2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjATF22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEC02278A
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A89B82763
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AC4C433D2;
        Thu, 19 Jan 2023 22:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168465;
        bh=Hpdz/I9MA9AKkpu2Zu+0Ro31idz2Ne7uUg7SYqnLQBk=;
        h=Date:To:From:Subject:From;
        b=SI18AmQa1XTNJxX4zQxUvqPXWTMMFZRLfKcqbS28UE/z0RMXYlTD8kug0PDk1W6h7
         gyR9/1BoB0xY4LPHCbr7slBh5LPtl6uFaT/b1GtrQczMn9pZSpu+OOtHD5u7QBqNjY
         oxRMxtt1y1DabUuapBdl24kkpsr14zdq2Bs5QAn0=
Date:   Thu, 19 Jan 2023 14:47:44 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch added to mm-unstable branch
Message-Id: <20230119224745.79AC4C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: section for rmap/PT walk feedback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: section for rmap/PT walk feedback
Date: Wed, 18 Jan 2023 00:18:22 +0000

Add a section for lru_gen_look_around() in the code and the design doc.

Link: https://lkml.kernel.org/r/20230118001827.1040870-3-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/multigen_lru.rst~mm-multi-gen-lru-section-for-rmap-pt-walk-feedback
+++ a/Documentation/mm/multigen_lru.rst
@@ -156,6 +156,20 @@ This time-based approach has the followi
    and memory sizes.
 2. It is more reliable because it is directly wired to the OOM killer.
 
+Rmap/PT walk feedback
+---------------------
+Searching the rmap for PTEs mapping each page on an LRU list (to test
+and clear the accessed bit) can be expensive because pages from
+different VMAs (PA space) are not cache friendly to the rmap (VA
+space). For workloads mostly using mapped pages, searching the rmap
+can incur the highest CPU cost in the reclaim path.
+
+``lru_gen_look_around()`` exploits spatial locality to reduce the
+trips into the rmap. It scans the adjacent PTEs of a young PTE and
+promotes hot pages. If the scan was done cacheline efficiently, it
+adds the PMD entry pointing to the PTE table to the Bloom filter. This
+forms a feedback loop between the eviction and the aging.
+
 Summary
 -------
 The multi-gen LRU can be disassembled into the following parts:
--- a/mm/vmscan.c~mm-multi-gen-lru-section-for-rmap-pt-walk-feedback
+++ a/mm/vmscan.c
@@ -4569,6 +4569,10 @@ static void lru_gen_age_node(struct pgli
 	}
 }
 
+/******************************************************************************
+ *                          rmap/PT walk feedback
+ ******************************************************************************/
+
 /*
  * This function exploits spatial locality when shrink_folio_list() walks the
  * rmap. It scans the adjacent PTEs of a young PTE and promotes hot pages. If
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch

