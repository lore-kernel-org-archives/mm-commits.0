Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5000C7EE29
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 22:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjEaWGB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 18:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjEaWGA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 18:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71913128
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 15:05:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0379963F75
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 22:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5700BC433D2;
        Wed, 31 May 2023 22:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685570750;
        bh=l0Jg4kSIs5ds9yval56GW3H2Z9RlbfDxO+Pv8W++yWg=;
        h=Date:To:From:Subject:From;
        b=SIHqKktmDjAx5WOM5KQPSKO/FHGaJX7P5DcO75N3kurCzBxyJXj2uSJf63V4x+pdi
         Z/ejj2yfEf+vmqLa5bgUs5xA/6QnBWQBPL65FYm9oRk0cjXKuo7b5A8Z0yuZOMUC4v
         v9k6PuvUzag1oWol74GmAcUTA2MdBbsLQnbSSU5g=
Date:   Wed, 31 May 2023 15:05:49 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        quic_pkondeti@quicinc.com, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-fix-uneven-accounting-of-psi.patch added to mm-unstable branch
Message-Id: <20230531220550.5700BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: madvise: fix uneven accounting of psi
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-fix-uneven-accounting-of-psi.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-fix-uneven-accounting-of-psi.patch

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
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: madvise: fix uneven accounting of psi
Date: Wed, 31 May 2023 16:39:34 +0530

A folio turns into a Workingset during:
1) shrink_active_list() placing the folio from active to inactive list.
2) When a workingset transition is happening during the folio refault.

And when Workingset is set on a folio, PSI for memory can be accounted
during a) That folio is being reclaimed and b) Refault of that folio.

There exists clients who can do the proactive reclaim using the system
calls like madvise(), whose folios can be safely treated as inactive
folios assuming the client knows that these folios are not needed in the
near future thus wanted to reclaim them.  For such folios psi is not
accounted uniformly:

a) A folio started at inactive and moved to active as part of accesses.
   Workingset is absent on the folio thus madvise(MADV_PAGEOUT) don't
   account such folios for PSI.

b) When the same folio transition from inactive->active and then to
   inactive through shrink_active_list().  Workingset is set on the folio
   thus madvise(MADV_PAGEOUT) account such folios for PSI.

c) When the same folio is part of active list directly as a result of
   folio refault and this was a workingset folio prior to eviction. 
   Workingset is set on the folio thus madvise(MADV_PAGEOUT) account such
   folios for PSI.

As said about the MADV_PAGEOUT on a folio is accounted in b) and c) but
not in a) which is inconsistent.  Remove this inconsistency by always not
considering the PSI for folios that are getting reclaimed through
madvise(MADV_PAGEOUT) by clearing the Workingset on a folio.  This
consistency of clearing the workingset was chosen under the assumption
that client knows these folios are not in active use thus reclaiming them
hence not eligible as workingset folios.  Probably it is the same reason
why workingset is not set on a folio through MADV_COLD but during the
shrink_active_list() though both the actions make the folio put onto the
inactive list.

This patch is tested on Android, Snapdragon SoC with 8Gb RAM, 4GB swap
mounted on zram which has 2GB of backingdev.  The test case involved
launching some memory hungry apps in an order and do the proactive reclaim
for the app that went to background using madvise(MADV_PAGEOUT).  We are
seeing ~40% less total values of psi mem some and full when this patch is
combined with [1].

[1]https://lore.kernel.org/all/20220214214921.419687-1-hannes@cmpxchg.org/T/#u

Link: https://lkml.kernel.org/r/1685531374-6091-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-fix-uneven-accounting-of-psi
+++ a/mm/madvise.c
@@ -409,8 +409,10 @@ static int madvise_cold_or_pageout_pte_r
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
-				else
+				else {
+					folio_clear_workingset(folio);
 					list_add(&folio->lru, &folio_list);
+				}
 			}
 		} else
 			folio_deactivate(folio);
@@ -503,8 +505,10 @@ regular_folio:
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
 					folio_putback_lru(folio);
-				else
+				else {
+					folio_clear_workingset(folio);
 					list_add(&folio->lru, &folio_list);
+				}
 			}
 		} else
 			folio_deactivate(folio);
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-madvise-fix-uneven-accounting-of-psi.patch

