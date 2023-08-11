Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93736C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjHKWXH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjHKWWt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EDB35BE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DF9967342
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0AC433C8;
        Fri, 11 Aug 2023 22:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691792545;
        bh=otYSPTusl4IhlR3YqGhDw2nV1gyXGs6NVs542ZHevRk=;
        h=Date:To:From:Subject:From;
        b=I2dCQq4GUFuzXNiNCjaj2kJ3MmUMVRXrV3WydqyeEgUhzo+DngEobEsWtQLAbcL3L
         z5oMACOzuUCIb+xe8C4Hi8+LshOnjjY82zMYEjCUaBNie8gIKnyguP9BqQJf40w55/
         hSC0WFLTgYAxqrbINt2EZtXbVauijlK6pSHWkP+o=
Date:   Fri, 11 Aug 2023 15:22:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch removed from -mm tree
Message-Id: <20230811222225.B0D0AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch

This patch was dropped because it was folded into mm-page_alloc-avoid-false-page-outside-zone-error-info.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
Date: Tue Jul  4 09:35:46 AM PDT 2023

code simplification, per Matthew

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-false-page-outside-zone-error-info-fix
+++ a/mm/page_alloc.c
@@ -468,10 +468,7 @@ static int page_outside_zone_boundaries(
 		seq = zone_span_seqbegin(zone);
 		start_pfn = zone->zone_start_pfn;
 		sp = zone->spanned_pages;
-		if (!zone_spans_pfn(zone, pfn))
-			ret = 1;
-		else
-			ret = 0;
+		ret = !zone_spans_pfn(zone, pfn);
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
mm-kfence-allocate-kfence_metadata-at-runtime-fix.patch
acpi-hmat-calculate-abstract-distance-with-hmat-checkpatch-fixes.patch
mm-remove-redundant-k-macro-definition-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch
drm-i915-move-abs_diff-to-mathh-fix-fix.patch
nmi_backtrace-allow-excluding-an-arbitrary-cpu-fix.patch

