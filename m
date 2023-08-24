Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE80C6FA8F
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbjHXXRw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244037AbjHXXRZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:17:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C461BFE
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5685668F6
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3560CC433CD;
        Thu, 24 Aug 2023 23:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919042;
        bh=FdorAWg3NFbi/DK7Ha1u2p7ahkYYNENAAY4eukBfCBs=;
        h=Date:To:From:Subject:From;
        b=GFBfSdflb/tR0OlZospu9sZEQ8eLlA5ae6Pv4Mm/yCL3rCmHJpSbZego/ruNV3KAo
         1roFzSx5zxRhUigAIBTnBVFGp+iUrgKt62+U0KyXONgDZrF/4RAxGzmAUAR8Tg1ew1
         tJ0QSN3BF4iVNw7fA7IXSxX/Ypxi4wUPsRjx2fbc=
Date:   Thu, 24 Aug 2023 16:17:21 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, rppt@kernel.org,
        rdunlap@infradead.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-get_mctgt_type-kernel-doc-fix.patch removed from -mm tree
Message-Id: <20230824231722.3560CC433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-fix-get_mctgt_type-kernel-doc-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-get_mctgt_type-kernel-doc-fix.patch

This patch was dropped because it was folded into mm-fix-get_mctgt_type-kernel-doc.patch

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
@@ -5867,9 +5867,9 @@ out:
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
mm-fix-get_mctgt_type-kernel-doc.patch

