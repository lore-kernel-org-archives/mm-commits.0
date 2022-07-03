Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C9AC43334
	for <mm-commits@archiver.kernel.org>; Sun,  3 Jul 2022 20:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiGCU2J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 16:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGCU2I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 16:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8321AA
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 13:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5D64B80B1C
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 20:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FC2C341C6;
        Sun,  3 Jul 2022 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656880084;
        bh=2gxgzxoffhz+iTu5be9eh679gPbv4fy3hFT6/9DquvE=;
        h=Date:To:From:Subject:From;
        b=tGa7sskTe/UDgYSYqrgii0NqDQ28Vqo89nkrNSiwKZs/jUhYhs+D4el1S+y2uHsV/
         kDeJ1yS8MQE6RdtoclVN0tOMRu2haBLrEn8A9z/cD5gcvab8+s5KMKB5wiwk04jP0N
         mFpbB6pBEBkhoRgTtIwBgrR/VRlDVFqDy82Br/z0=
Date:   Sun, 03 Jul 2022 13:28:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + csky-drop-definition-of-pte_order.patch added to mm-unstable branch
Message-Id: <20220703202804.71FC2C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: csky: drop definition of PTE_ORDER
has been added to the -mm mm-unstable branch.  Its filename is
     csky-drop-definition-of-pte_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/csky-drop-definition-of-pte_order.patch

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
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: csky: drop definition of PTE_ORDER
Date: Sun, 3 Jul 2022 17:11:50 +0300

Patch series "arch: make PxD_ORDER generically available".

The question what does PxD_ORDER define raises from time to time and
there is still a conflict between MIPS and DAX definitions.

Some time ago Matthew Wilcox suggested to use PMD_TABLE_ORDER to define
the order of page table allocation: 

[1] https://lore.kernel.org/linux-arch/YPCJftSTUBEnq2lI@casper.infradead.org/

The parisc patch made it in, but mips didn't. 
Now mips defines from asm/include/pgtable.h were copied to loongarch which
made it worse.

Let's deal with it once and for all and rename PxD_ORDER defines to
PxD_TABLE_ORDER or just drop them when the only possible order of page
table is 0.


This patch (of 14):

This is the order of the page table allocation, not the order of a PTE. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220703141203.147893-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20220703141203.147893-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Xuerui Wang <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/include/asm/pgtable.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/csky/include/asm/pgtable.h~csky-drop-definition-of-pte_order
+++ a/arch/csky/include/asm/pgtable.h
@@ -19,11 +19,10 @@
  * C-SKY is two-level paging structure:
  */
 #define PGD_ORDER	0
-#define PTE_ORDER	0
 
 #define PTRS_PER_PGD	((PAGE_SIZE << PGD_ORDER) / sizeof(pgd_t))
 #define PTRS_PER_PMD	1
-#define PTRS_PER_PTE	((PAGE_SIZE << PTE_ORDER) / sizeof(pte_t))
+#define PTRS_PER_PTE	(PAGE_SIZE / sizeof(pte_t))
 
 #define pte_ERROR(e) \
 	pr_err("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, (e).pte_low)
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

csky-drop-definition-of-pte_order.patch
csky-drop-definition-of-pgd_order.patch
mips-rename-pud_order-to-pud_table_order.patch
mips-drop-definitions-of-pte_order.patch
mips-rename-pgd_order-to-pgd_table_order.patch
nios2-drop-definition-of-pte_order.patch
nios2-drop-definition-of-pgd_order.patch
loongarch-drop-definition-of-pte_order.patch
loongarch-drop-definition-of-pmd_order.patch
loongarch-drop-definition-of-pud_order.patch
loongarch-drop-definition-of-pgd_order.patch
parisc-rename-pgd_order-to-pgd_table_order.patch
xtensa-drop-definition-of-pgd_order.patch

