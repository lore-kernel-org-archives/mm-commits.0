Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A91CA100D
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 20:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbjIEUIs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 16:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242809AbjIEUIr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 16:08:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC9A198
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 13:08:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4924C43397;
        Tue,  5 Sep 2023 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693937544;
        bh=lpB3AGbZ1FzP9ZE0sKACac9y0g4hr0H6QZziMPUjQKk=;
        h=Date:To:From:Subject:From;
        b=VGdb2ZQ4+vRWz6/BcSBAL8GQd6qK8xUx4KLlcxL3LE1WyA5kAFvzk7eiyelMjJd8p
         SBNahn30jEPkTPDQCaEvb78TBXtvoAVUIxT6RlXZ80EWhSm3JKbgZ5/62jFcaldYCh
         U2Vbydgie/5GNvf7fMmKEm+UXj4q6Q29JxzbPzZM=
Date:   Tue, 05 Sep 2023 11:12:24 -0700
To:     mm-commits@vger.kernel.org, linux@roeck-us.net, rppt@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch removed from -mm tree
Message-Id: <20230905181224.C4924C43397@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sparc64: add missing initialization of folio in tlb_batch_add()
has been removed from the -mm tree.  Its filename was
     sparc64-add-missing-initialization-of-folio-in-tlb_batch_add.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (IBM)" <rppt@kernel.org>
Subject: sparc64: add missing initialization of folio in tlb_batch_add()
Date: Mon, 4 Sep 2023 20:37:59 +0300

Commit 1a10a44dfc1d ("sparc64: implement the new page table range API")
missed initialization of folio variable in tlb_batch_add() which causes
boot tests to crash.

Add missing initialization.

Link: https://lkml.kernel.org/r/20230904174350.GF3223@kernel.org
Fixes: 1a10a44dfc1d ("sparc64: implement the new page table range API")
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/mm/tlb.c~sparc64-add-missing-initialization-of-folio-in-tlb_batch_add
+++ a/arch/sparc/mm/tlb.c
@@ -128,6 +128,7 @@ void tlb_batch_add(struct mm_struct *mm,
 			goto no_cache_flush;
 
 		/* A real file page? */
+		folio = page_folio(page);
 		mapping = folio_flush_mapping(folio);
 		if (!mapping)
 			goto no_cache_flush;
_

Patches currently in -mm which might be from rppt@kernel.org are


