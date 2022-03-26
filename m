Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C530C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 03:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiCZDtC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 23:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiCZDs6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 23:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202B5193172
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 20:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8C2B619F4
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 03:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078A8C340E8;
        Sat, 26 Mar 2022 03:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648266442;
        bh=RSTiIy6YZkVQ94bqE8i3yfa5a0O+Thw0yegMMoFf9xE=;
        h=Date:To:From:Subject:From;
        b=D2PFMdmdA2giojFy7USaJl5HrUdsxwhg2XucfKVi/idWzD8Go985011DkAYF+1DD6
         voWXzvHAiQ1r47LtkAhTrPPTK3mMgALpvGOQKQGow/rKheFZ9nr6Un+n5+7ILGsXve
         PTKlaZcn1OYtdzNHKfdzQnS65dg1VLC8Ep1w7RIA=
Date:   Fri, 25 Mar 2022 20:47:21 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, nigupta@nvidia.com,
        lkp@intel.com, quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-compiler-warning-when-config_compaction=n.patch added to -mm tree
Message-Id: <20220326034722.078A8C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: fix compiler warning when CONFIG_COMPACTION=n
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-compiler-warning-when-config_compaction=n.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-fix-compiler-warning-when-config_compaction=n.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-fix-compiler-warning-when-config_compaction=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-mm-madvise-skip-unmapped-vma-holes-passed-to-process_madvise.patch
mm-compaction-fix-compiler-warning-when-config_compaction=n.patch

