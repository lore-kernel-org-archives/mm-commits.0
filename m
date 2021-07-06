Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F214C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A6D60FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhGFTPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhGFTPh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D91660FE3;
        Tue,  6 Jul 2021 19:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598778;
        bh=S4QoKSZrwwh+eBl2/BMweDqPig/lN9XByOByinUvPtA=;
        h=Date:From:To:Subject:From;
        b=HyziUwfggrp33vCm3PLv3l2lwAbRow/8ltHFYkX2D9nNJljb7tqe0JKv7iNazBYe4
         x4ejtshCIEwM3ErqIw9X42zebJ+bwCFLVEpDLccQpa1CVx+B3MSCIm7zHY/SI0PPj/
         lgcj+3T+0pxtbuQsmbFWr+GsOD2sYqbi09vIRE5Q=
Date:   Tue, 06 Jul 2021 12:12:58 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-migrate-use-vma_lookup-in-do_pages_stat_array.patch removed from -mm
 tree
Message-ID: <20210706191258.7iyPIR_2E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: use vma_lookup() in do_pages_stat_array()
has been removed from the -mm tree.  Its filename was
     mm-migrate-use-vma_lookup-in-do_pages_stat_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: mm/migrate: use vma_lookup() in do_pages_stat_array()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-20-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-use-vma_lookup-in-do_pages_stat_array
+++ a/mm/migrate.c
@@ -1834,8 +1834,8 @@ static void do_pages_stat_array(struct m
 		struct page *page;
 		int err = -EFAULT;
 
-		vma = find_vma(mm, addr);
-		if (!vma || addr < vma->vm_start)
+		vma = vma_lookup(mm, addr);
+		if (!vma)
 			goto set_status;
 
 		/* FOLL_DUMP to ignore special (like zero) pages */
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


