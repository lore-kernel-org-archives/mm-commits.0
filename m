Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065DBC61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjBCGnW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBCGlv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:41:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26037AD2E
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2420B82980
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741DEC433A0;
        Fri,  3 Feb 2023 06:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406289;
        bh=EerRRdZcT8YlkoMK2P92OE4mLrwUxIKTGy2EzPARf+A=;
        h=Date:To:From:Subject:From;
        b=p73HO0FAEVTcnJNCt+pmN8quB6Rztd7mfuKq+a+WqlHWAhpCbFjvCbic6OOumGeYz
         IV5+vqpVAOsgCdaIhIqS86MUpaSK/T0sZQhEe3/WHOv2/o/kgWXGeHfLmNtnmmlvPX
         YSlAnCzXlzt+okC/eTN7F0ulZkQJnP6feMIx7afM=
Date:   Thu, 02 Feb 2023 22:38:08 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-section-for-working-set-protection.patch removed from -mm tree
Message-Id: <20230203063809.741DEC433A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: section for working set protection
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-section-for-working-set-protection.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


