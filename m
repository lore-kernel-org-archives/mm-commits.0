Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4FAC43219
	for <mm-commits@archiver.kernel.org>; Tue, 19 Apr 2022 00:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiDSA3I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Apr 2022 20:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240479AbiDSA3D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Apr 2022 20:29:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782B9237EA
        for <mm-commits@vger.kernel.org>; Mon, 18 Apr 2022 17:26:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F5D4B81132
        for <mm-commits@vger.kernel.org>; Tue, 19 Apr 2022 00:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DB0C385A1;
        Tue, 19 Apr 2022 00:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650327966;
        bh=y0vl7K+Ww6rGSPRGNV78Ap1xhXILlY05Ziy1caO5GMc=;
        h=Date:To:From:Subject:From;
        b=SGmeZecbMtgWVOgEj8RmKqGzELGoo2SDXMngIt4o+2eO+mo23QMSqny7F0nJQ4eM/
         HnWLKFRi1JjEpY+bCAS5mLz6rOgOEvE5dLlW3RW55Y+Stq+BKRxaATjcV7RVhyI/hW
         SkT6oc8ownzfFMF4pUVgGaSG635HZMObX18+4Klw=
Date:   Mon, 18 Apr 2022 17:26:06 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nigupta@nvidia.com,
        lkp@intel.com, quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-compaction-fix-compiler-warning-when-config_compaction=n.patch removed from -mm tree
Message-Id: <20220419002606.C2DB0C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix compiler warning when CONFIG_COMPACTION=n
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-compiler-warning-when-config_compaction=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: compaction: fix compiler warning when CONFIG_COMPACTION=n

The below warning is reported when CONFIG_COMPACTION=n:

   mm/compaction.c:56:27: warning: 'HPAGE_FRAG_CHECK_INTERVAL_MSEC'
defined but not used [-Wunused-const-variable=]
      56 | static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC =
500;
         |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fix it by moving 'HPAGE_FRAG_CHECK_INTERVAL_MSEC' under
CONFIG_COMPACTION defconfig. Also since this is just a 'static const
int' type, use #define for it.

Link: https://lkml.kernel.org/r/1647608518-20924-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Nitin Gupta <nigupta@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-compiler-warning-when-config_compaction=n
+++ a/mm/compaction.c
@@ -26,6 +26,11 @@
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
+/*
+ * Fragmentation score check interval for proactive compaction purposes.
+ */
+#define HPAGE_FRAG_CHECK_INTERVAL_MSEC	(500)
+
 static inline void count_compact_event(enum vm_event_item item)
 {
 	count_vm_event(item);
@@ -51,11 +56,6 @@ static inline void count_compact_events(
 #define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
 
 /*
- * Fragmentation score check interval for proactive compaction purposes.
- */
-static const unsigned int HPAGE_FRAG_CHECK_INTERVAL_MSEC = 500;
-
-/*
  * Page order with-respect-to which proactive compaction
  * calculates external fragmentation, which is used as
  * the "fragmentation score" of a node/zone.
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


