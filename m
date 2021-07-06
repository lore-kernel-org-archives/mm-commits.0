Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2E6C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D583D60FEE
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhGFTPc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231737AbhGFTPb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:15:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861526023F;
        Tue,  6 Jul 2021 19:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598772;
        bh=VpGKX3nwYt1QXgbs1nyLhGFppzNlUGr2cJQpsleI044=;
        h=Date:From:To:Subject:From;
        b=Bx7HZpnhzM60HqG2jy8o7Tolu+7TKp5UHkqFixrVm/J1oNW1gWOb+dy0zIRQ3tdSY
         2zT/S7JWydVThsTpyPnOcGCsFo1IWe/C1yrvEBrwvIZf7RxmNL8oNRCRXIHq3SatCx
         Y/Uea3w6lw30mHH/dMnHz9lqQGVYS5y6N6Z76xJU=
Date:   Tue, 06 Jul 2021 12:12:52 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dbueso@suse.de, geert@linux-m68k.org,
        ldufour@linux.ibm.com, Liam.Howlett@Oracle.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 kernel-events-uprobes-use-vma_lookup-in-find_active_uprobe.patch removed
 from -mm tree
Message-ID: <20210706191252.IFFW1R0xr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/events/uprobes: use vma_lookup() in find_active_uprobe()
has been removed from the -mm tree.  Its filename was
     kernel-events-uprobes-use-vma_lookup-in-find_active_uprobe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liam Howlett <liam.howlett@oracle.com>
Subject: kernel/events/uprobes: use vma_lookup() in find_active_uprobe()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-17-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/events/uprobes.c~kernel-events-uprobes-use-vma_lookup-in-find_active_uprobe
+++ a/kernel/events/uprobes.c
@@ -2046,8 +2046,8 @@ static struct uprobe *find_active_uprobe
 	struct vm_area_struct *vma;
 
 	mmap_read_lock(mm);
-	vma = find_vma(mm, bp_vaddr);
-	if (vma && vma->vm_start <= bp_vaddr) {
+	vma = vma_lookup(mm, bp_vaddr);
+	if (vma) {
 		if (valid_vma(vma, false)) {
 			struct inode *inode = file_inode(vma->vm_file);
 			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
_

Patches currently in -mm which might be from liam.howlett@oracle.com are


