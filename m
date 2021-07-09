Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE40C07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979BE613D6
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 21:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIVgq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 17:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhGIVgp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 17:36:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB67613C8;
        Fri,  9 Jul 2021 21:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625866441;
        bh=Q1Z8/LVfuVwFtyUEHjeSofObsiWqphHNuDs7PqXFCYY=;
        h=Date:From:To:Subject:From;
        b=qLWCMRX08BeqRtXi3ngjGU4ECYcJBaubC5g+f7rdKTIu/wXb8Op6hfPZ678rN4GQn
         RaB1bFvkOTif5IXWLStjBRAK4gVo9zks8uK2AG+fVgCK6XDrOEDA+Uavsu3ICoMrxn
         Z3mh5FU6zkhEXWOakjZrLgmE1kK1K0v+UpGFZPyw=
Date:   Fri, 09 Jul 2021 14:34:01 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        hughd@google.com, joel@joelfernandes.org, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, npiggin@gmail.com, sfr@canb.auug.org.au
Subject:  [merged]
 mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch
 removed from -mm tree
Message-ID: <20210709213401.a8XmWSPCB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: don't enable optimized PUD move if page table levels is 2
has been removed from the -mm tree.  Its filename was
     mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/mremap: don't enable optimized PUD move if page table levels is 2

With two level page table don't enable move_normal_pud.

Link: https://lkml.kernel.org/r/20210616045239.370802-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-dont-enable-optimized-pud-move-if-page-table-levels-is-2
+++ a/mm/mremap.c
@@ -276,7 +276,7 @@ static inline bool move_normal_pmd(struc
 }
 #endif
 
-#ifdef CONFIG_HAVE_MOVE_PUD
+#if CONFIG_PGTABLE_LEVELS > 2 && defined(CONFIG_HAVE_MOVE_PUD)
 static bool move_normal_pud(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pud_t *old_pud, pud_t *new_pud)
 {
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are


