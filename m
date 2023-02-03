Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649AFC6379F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjBCGnZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjBCGlw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5DE44A6
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E025AB82981
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73320C4339B;
        Fri,  3 Feb 2023 06:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406290;
        bh=ClNdCKg/DAo73XCzY5y+e7dOvDqsmHrWiTeyWEyoufQ=;
        h=Date:To:From:Subject:From;
        b=LqrmDYdKJyxKjvEvk58CjZ4TmDOqvjK1jfXeq6SWcCBhisEnX/ucvIPKmlY/JbMhY
         yvhF7gBu6ZLsIPJJnrgQ6w0Nb/+tSUTzxs2kbOT3RwKd8Fq/k6J7tsynb9agFaNSRG
         F0Hdv26g+GQZfwjFUhx2ayAXB6u4A7sESsA7Ph+w=
Date:   Thu, 02 Feb 2023 22:38:09 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch removed from -mm tree
Message-Id: <20230203063810.73320C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: section for rmap/PT walk feedback
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


