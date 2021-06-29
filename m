Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80806C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B1EE61D0D
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhF2Clk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Clj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7EC461D08;
        Tue, 29 Jun 2021 02:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934352;
        bh=ZQdyrP5Xw5lVQICMHU1juDlPd/tNAfxTL2m+vVJ7ur4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Kx8qMF1cnxlM5ZeqAV8aAT6QoEZV3SVhYLD+FF9PoZpMFDUqSqebVc/qxFy9PBvKm
         DSYuCgYU7RA3M0K8uaV36A4XQ26KxJws8qF5uaQ8mf6e4ufERZnduLTLS3/S4wvcXY
         HIrhqNozf/xjD3IR727DTQ76kB+Ayns2bBk4w8qM=
Date:   Mon, 28 Jun 2021 19:39:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 112/192] arch/m68k/kernel/sys_m68k: use
 vma_lookup() in sys_cacheflush()
Message-ID: <20210629023911.Oo4EVosUL%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/m68k/kernel/sys_m68k: use vma_lookup() in sys_cacheflush()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-9-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/sys_m68k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/m68k/kernel/sys_m68k.c~arch-m68k-kernel-sys_m68k-use-vma_lookup-in-sys_cacheflush
+++ a/arch/m68k/kernel/sys_m68k.c
@@ -402,8 +402,8 @@ sys_cacheflush (unsigned long addr, int
 		 * to this process.
 		 */
 		mmap_read_lock(current->mm);
-		vma = find_vma(current->mm, addr);
-		if (!vma || addr < vma->vm_start || addr + len > vma->vm_end)
+		vma = vma_lookup(current->mm, addr);
+		if (!vma || addr + len > vma->vm_end)
 			goto out_unlock;
 	}
 
_
