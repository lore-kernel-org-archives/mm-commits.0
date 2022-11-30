Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF85C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiK3XqH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3XqG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:46:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF194442EB
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DCB061E4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833AEC433D7;
        Wed, 30 Nov 2022 23:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851964;
        bh=FIZhzyeeY10nF5pljazbcciPU8PmDOAXwx5GP+sP6tk=;
        h=Date:To:From:Subject:From;
        b=iI/pPVgk+5eV9VwHw/f75i5QAZJfe65QQ7CUPJafFqF4vDSuap3MzQo//ft+qHaya
         I+BeI2wUAJlM1204sZ3wgFnrXgAeZVHTo24R0w8w+dCAdxO6TGg+PbXztFoXVxYgPY
         ojWcdN1vbf48DRysmnTpUugqmY72x0/Jjtovbm5E=
Date:   Wed, 30 Nov 2022 15:46:03 -0800
To:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        nadav.amit@gmail.com, hughd@google.com, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch removed from -mm tree
Message-Id: <20221130234604.833AEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
has been removed from the -mm tree.  Its filename was
     mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch

This patch was dropped because it was folded into mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
Date: Wed Nov  9 04:07:36 PM PST 2022

Fix UP build, per Linus
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mmu_gather.c~mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix
+++ a/mm/mmu_gather.c
@@ -48,6 +48,7 @@ static bool tlb_next_batch(struct mmu_ga
 	return true;
 }
 
+#ifdef CONFIG_SMP
 /**
  * tlb_flush_rmaps - do pending rmap removals after we have flushed the TLB
  * @tlb: the current mmu_gather
@@ -72,6 +73,7 @@ void tlb_flush_rmaps(struct mmu_gather *
 
 	tlb->delayed_rmap = 0;
 }
+#endif
 
 static void tlb_batch_pages_flush(struct mmu_gather *tlb)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

