Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B45EB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 17 Jul 2023 18:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjGQSRy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Jul 2023 14:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjGQSRx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Jul 2023 14:17:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5695198B
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 11:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 535F460FD4
        for <mm-commits@vger.kernel.org>; Mon, 17 Jul 2023 18:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F46C433C8;
        Mon, 17 Jul 2023 18:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689617851;
        bh=dsHAiTlgN0czuRk2tEXgnkBaoLtz4Eh6icmrIYDHI50=;
        h=Date:To:From:Subject:From;
        b=1xCquF7P9cfnA0mQhDISBA1U00Gx89HEGBOK5rtk5dNNexVbzwbrZdslA0EOwdz1V
         eatB1xR7IT0pa1IC3HppOxym0Ywo1KA+S50X5dszNr+CQu8djgP0p5WhvABobF2Qlg
         cxasugv/1G+Yg5KM/6azjQsCv9QkQXzu/dsyvmxY=
Date:   Mon, 17 Jul 2023 11:17:31 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, david@redhat.com,
        haifeng.xu@shopee.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch added to mm-unstable branch
Message-Id: <20230717181731.A6F46C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: drop node_start_pfn from adjust_zone_range_for_zone_movable()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch

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
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm/mm_init.c: drop node_start_pfn from adjust_zone_range_for_zone_movable()
Date: Mon, 17 Jul 2023 06:58:11 +0000

node_start_pfn is not used in adjust_zone_range_for_zone_movable(), so it
is pointless to waste a function argument.  Drop the parameter.

Link: https://lkml.kernel.org/r/20230717065811.1262-1-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable
+++ a/mm/mm_init.c
@@ -1105,7 +1105,6 @@ void __ref memmap_init_zone_device(struc
  */
 static void __init adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
-					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
 					unsigned long *zone_start_pfn,
 					unsigned long *zone_end_pfn)
@@ -1222,9 +1221,8 @@ static unsigned long __init zone_spanned
 	/* Get the start and end of the zone */
 	*zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	*zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
-	adjust_zone_range_for_zone_movable(nid, zone_type,
-				node_start_pfn, node_end_pfn,
-				zone_start_pfn, zone_end_pfn);
+	adjust_zone_range_for_zone_movable(nid, zone_type, node_end_pfn,
+					   zone_start_pfn, zone_end_pfn);
 
 	/* Check that this node has pages within the zone's required range */
 	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are

mm-mm_initc-mark-check_for_memory-as-__init.patch
mm-mm_initc-drop-node_start_pfn-from-adjust_zone_range_for_zone_movable.patch

