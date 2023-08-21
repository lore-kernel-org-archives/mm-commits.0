Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B5DEE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 18:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjHUS4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 14:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjHUS4S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 14:56:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37743A93
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 11:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15A2E6429C
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 18:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618FDC433C8;
        Mon, 21 Aug 2023 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692644094;
        bh=EqbwJMgx5mcw6jjS5CbqvVGTuka+3lm80XbDzPiGXEA=;
        h=Date:To:From:Subject:From;
        b=dcC8RQnL89u5NTkJo95rkubZqEDAHmR+z2EaD6LUaookUeY/SNFmf+RY/GBl9FkJj
         KATIdGoMecQ9+GrwW9V1fybY1Bl1nq8qaz9b3hH2dVWaRPFgVoCjFjOo3VFpxHI/Pq
         Hi/l0MNhOeRN4zvHWBPMtbAau6syz+f8v3uVLPo0=
Date:   Mon, 21 Aug 2023 11:54:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        rdunlap@infradead.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-get_mctgt_type-kernel-doc-fix.patch added to mm-unstable branch
Message-Id: <20230821185454.618FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-get_mctgt_type-kernel-doc-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-get_mctgt_type-kernel-doc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-get_mctgt_type-kernel-doc-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-get_mctgt_type-kernel-doc-fix
Date: Mon Aug 21 11:53:43 AM PDT 2023

changes suggested by Randy

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-fix-get_mctgt_type-kernel-doc-fix
+++ a/mm/memcontrol.c
@@ -5855,9 +5855,9 @@ out:
  * * MC_TARGET_NONE - If the pte is not a target for move charge.
  * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
  *   move charge. If @target is not NULL, the page is stored in target->page
- *   with extra refcnt got (Callers should handle it).
+ *   with extra refcnt taken (Callers should handle it).
  * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
- *   target for charge migration. if @target is not NULL, the entry is stored
+ *   target for charge migration.  If @target is not NULL, the entry is stored
  *   in target->ent.
  * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
  *   thus not on the lru.  For now such page is charged like a regular page
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-remove-redundant-k-macro-definition-fix.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch
mm-fix-get_mctgt_type-kernel-doc-fix.patch

