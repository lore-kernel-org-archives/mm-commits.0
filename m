Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B267C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjHKW60 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233844AbjHKW6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671252684
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F36A264E63
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49292C433C8;
        Fri, 11 Aug 2023 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794704;
        bh=RT1PPv6O/krsrcBxaeoNBjA259/ry83EaAj1HxH0s04=;
        h=Date:To:From:Subject:From;
        b=D89yUJfoaXN1BcUK4yd++X7beDk4RfYpz2VrYcaJ0j2EwxsBZZ5AtaKBIRusJccEV
         eFMDiFPzFJ9ShL3u3rBITo1OMVopqmBYG2SVSrIyMM1kxoNRopf7kJk59ObzSo1sqF
         LMwAlYt7XzfYvA+TP0cwYWLwpKjW+3Nhz/0UsEMY=
Date:   Fri, 11 Aug 2023 15:58:23 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        quic_smanapra@quicinc.com, quic_pkondeti@quicinc.com,
        minchan@kernel.org, hannes@cmpxchg.org, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-fix-uneven-accounting-of-psi.patch removed from -mm tree
Message-Id: <20230811225824.49292C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: madvise: fix uneven accounting of psi
has been removed from the -mm tree.  Its filename was
     mm-madvise-fix-uneven-accounting-of-psi.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: madvise: fix uneven accounting of psi
Date: Mon, 3 Jul 2023 19:36:41 +0530

A folio turns into a Workingset during:
1) shrink_active_list() placing the folio from active to inactive list.
2) When a workingset transition is happening during the folio refault.

And when Workingset is set on a folio, PSI for memory can be accounted
during a) That folio is being reclaimed and b) Refault of that folio,
for usual reclaims.

This accounting of PSI for memory is not consistent for reclaim +
refault operation between usual reclaim and madvise(COLD/PAGEOUT) which
deactivate or proactively reclaim a folio:
a) A folio started at inactive and moved to active as part of accesses.
Workingset is absent on the folio thus refault of it when reclaimed
through MADV_PAGEOUT operation doesn't account for PSI.

b) When the same folio transition from inactive->active and then to
inactive through shrink_active_list(). Workingset is set on the folio
thus refault of it when reclaimed through MADV_PAGEOUT operation
accounts for PSI.

c) When the same folio is part of active list directly as a result of
folio refault and this was a workingset folio prior to eviction.
Workingset is set on the folio thus the refault of it when reclaimed
through MADV_PAGEOUT/MADV_COLD operation accounts for PSI.

d) MADV_COLD transfers the folio from active list to inactive
list. Such folios may not have the Workingset thus refault operation on
such folio doesn't account for PSI.

As said above, refault operation caused because of MADV_PAGEOUT on a
folio is accounts for memory PSI in b) and c) but not in a). Refault
caused by the reclaim of a folio on which MADV_COLD is performed
accounts memory PSI in c) but not in d). These behaviours are
inconsistent w.r.t usual reclaim + refault operation. Make this PSI
accounting always consistent by turning a folio into a workingset one
whenever it is leaving the active list. Also, accounting of PSI on a
folio whenever it leaves the active list as part of the
MADV_COLD/PAGEOUT operation helps the users whether they are operating
on proper folios[1].

[1] https://lore.kernel.org/all/20230605180013.GD221380@cmpxchg.org/

Link: https://lkml.kernel.org/r/1688393201-11135-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Sai Manobhiram Manapragada <quic_smanapra@quicinc.com>
Reported-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/madvise.c~mm-madvise-fix-uneven-accounting-of-psi
+++ a/mm/madvise.c
@@ -413,6 +413,8 @@ static int madvise_cold_or_pageout_pte_r
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
@@ -510,6 +512,8 @@ regular_folio:
 		 */
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
+		if (folio_test_active(folio))
+			folio_set_workingset(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
 				if (folio_test_unevictable(folio))
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch

