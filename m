Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8DFC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76662145D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881121;
	bh=vUtsYJG07McnMeYAPyi2Z8mQRYujDNxHJgsigeArQtc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BWBZqJ9GSOOWBux6i2IhbqATVau5n5uA/0um19Q6zt1uclyFZntfKv7R/1eZdN0eP
	 W80KeT+9yPplgAISjLbaI+aprlhAn25XmSeKrnaAWJC83ZparDs/6RzKU50YtQE4qW
	 B3FynHjHpWl5VQvHbrmBfojr7O4BrzDoDAAdHZgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407398AbgJPUpV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:45:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403763AbgJPUpV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:45:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E802B20878;
        Fri, 16 Oct 2020 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881119;
        bh=vUtsYJG07McnMeYAPyi2Z8mQRYujDNxHJgsigeArQtc=;
        h=Date:From:To:Subject:From;
        b=ADbFc6s+XUTOYbIxXWZTIlZNkDTnVaf/Nmkju8gSYkBlWXhcUQXvMNwhG/EGdqOoi
         rYSNL2MExYuBuuZVsymnZtOCsog+4nNJnMFImmzdoAUvW1GHjgUzwJnsyKprCHP3MX
         Uz3hZ2OHIuILqtF5QOsRSiUc6KXTutDcPlVwA4Bs=
Date:   Fri, 16 Oct 2020 13:45:18 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20201016204518._8Utvtn1F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    6 +++--
 arch/riscv/mm/init.c                            |   15 ++++----------
 lib/Makefile                                    |    1 
 mm/filemap.c                                    |    8 +++----
 4 files changed, 14 insertions(+), 16 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~linux-next-rejects
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -622,11 +622,13 @@ static int dlpar_add_lmb(struct drmem_lm
 		return rc;
 	}
 
-	lmb_set_nid(lmb);
 	block_sz = memory_block_size_bytes();
 
+	/* Find the node id for this address. */
+	nid = memory_add_physaddr_to_nid(lmb->base_addr);
+
 	/* Add the memory */
-	rc = __add_memory(lmb->nid, lmb->base_addr, block_sz, MHP_NONE);
+	rc = __add_memory(nid, lmb->base_addr, block_sz, MHP_NONE);
 	if (rc) {
 		invalidate_lmb_associativity_index(lmb);
 		return rc;
--- a/mm/filemap.c~linux-next-rejects
+++ a/mm/filemap.c
@@ -827,10 +827,10 @@ int replace_page_cache_page(struct page
 }
 EXPORT_SYMBOL_GPL(replace_page_cache_page);
 
-static int __add_to_page_cache_locked(struct page *page,
-				      struct address_space *mapping,
-				      pgoff_t offset, gfp_t gfp,
-				      void **shadowp)
+static noinline int __add_to_page_cache_locked(struct page *page,
+					       struct address_space *mapping,
+					       pgoff_t offset, gfp_t gfp,
+					       void **shadowp)
 {
 	XA_STATE(xas, &mapping->i_pages, offset);
 	int huge = PageHuge(page);


Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

