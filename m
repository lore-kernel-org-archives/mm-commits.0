Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21C1C46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjATF3O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjATF2d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:28:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786786D363
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:23:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0AA6B821D9
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B4BC433EF;
        Thu, 19 Jan 2023 22:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168463;
        bh=pfl3TuCS2u+QqL4vCFa8i5BH5QHZTkDB6g40rr7Bz0o=;
        h=Date:To:From:Subject:From;
        b=z/SPV2Vhabuzm89afwDam3dqapFReaiP4J7ML1Ll7XBhy6ChAV24yO13ukychMS5G
         ecKUV+kS8wnhmsKB0uczimRcEWr7pzKD+JkGqwNp2pihcYiXcX7MwJvOXnBZ6ahpQT
         x2FR8iF0F3yoelH3TULoBqSkpxB8jXuo5PuGdKkQ=
Date:   Thu, 19 Jan 2023 14:47:43 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-section-for-working-set-protection.patch added to mm-unstable branch
Message-Id: <20230119224743.94B4BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: section for working set protection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-section-for-working-set-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-section-for-working-set-protection.patch

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
Subject: mm: multi-gen LRU: section for working set protection
Date: Wed, 18 Jan 2023 00:18:21 +0000

Patch series "mm: multi-gen LRU: improve".

This patch series improves a few MGLRU functions, collects related
functions, and adds additional documentation.


This patch (of 7):

Add a section for working set protection in the code and the design doc. 
The admin doc already contains its usage.

Link: https://lkml.kernel.org/r/20230118001827.1040870-1-talumbau@google.com
Link: https://lkml.kernel.org/r/20230118001827.1040870-2-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/mm/multigen_lru.rst~mm-multi-gen-lru-section-for-working-set-protection
+++ a/Documentation/mm/multigen_lru.rst
@@ -141,6 +141,21 @@ loop has detected outlying refaults from
 this end, the feedback loop uses the first tier as the baseline, for
 the reason stated earlier.
 
+Working set protection
+----------------------
+Each generation is timestamped at birth. If ``lru_gen_min_ttl`` is
+set, an ``lruvec`` is protected from the eviction when its oldest
+generation was born within ``lru_gen_min_ttl`` milliseconds. In other
+words, it prevents the working set of ``lru_gen_min_ttl`` milliseconds
+from getting evicted. The OOM killer is triggered if this working set
+cannot be kept in memory.
+
+This time-based approach has the following advantages:
+
+1. It is easier to configure because it is agnostic to applications
+   and memory sizes.
+2. It is more reliable because it is directly wired to the OOM killer.
+
 Summary
 -------
 The multi-gen LRU can be disassembled into the following parts:
--- a/mm/vmscan.c~mm-multi-gen-lru-section-for-working-set-protection
+++ a/mm/vmscan.c
@@ -4475,6 +4475,10 @@ done:
 	return true;
 }
 
+/******************************************************************************
+ *                          working set protection
+ ******************************************************************************/
+
 static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int gen, type, zone;
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch

