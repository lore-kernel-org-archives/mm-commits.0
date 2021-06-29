Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D01AC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0262061D0F
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2Clg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Clg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C42A661D0C;
        Tue, 29 Jun 2021 02:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934349;
        bh=Lvp31VERETIxmt/MmCnb/z0wcM8n16r+oVg0cXrRj1Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Tu4BM0qFDKaG/xHPAJ9MqR/w0BwKTUDWKqPqlE3wNIWHv/xmVvSnIeOrAZqwYBJ+Q
         +8OX/RJI10K+l5aZigWN8xhVXVyueKhuSZmR9bbQebhL0fktEC8T0iZSRiCpOP0Xc3
         LIJBsydys5CSRQJ2xE/tQv39KykSkDKpW5JChSvI=
Date:   Mon, 28 Jun 2021 19:39:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 111/192] arch/mips/kernel/traps: use vma_lookup()
 instead of find_vma()
Message-ID: <20210629023908.YlXSWGkLN%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: arch/mips/kernel/traps: use vma_lookup() instead of find_vma()

Use vma_lookup() to find the VMA at a specific address.  As vma_lookup()
will return NULL if the address is not within any VMA, the start address
no longer needs to be validated.

Link: https://lkml.kernel.org/r/20210521174745.2219620-8-Liam.Howlett@Oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/traps.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/mips/kernel/traps.c~arch-mips-kernel-traps-use-vma_lookup-instead-of-find_vma
+++ a/arch/mips/kernel/traps.c
@@ -784,7 +784,6 @@ void force_fcr31_sig(unsigned long fcr31
 int process_fpemu_return(int sig, void __user *fault_addr, unsigned long fcr31)
 {
 	int si_code;
-	struct vm_area_struct *vma;
 
 	switch (sig) {
 	case 0:
@@ -800,8 +799,7 @@ int process_fpemu_return(int sig, void _
 
 	case SIGSEGV:
 		mmap_read_lock(current->mm);
-		vma = find_vma(current->mm, (unsigned long)fault_addr);
-		if (vma && (vma->vm_start <= (unsigned long)fault_addr))
+		if (vma_lookup(current->mm, (unsigned long)fault_addr))
 			si_code = SEGV_ACCERR;
 		else
 			si_code = SEGV_MAPERR;
_
