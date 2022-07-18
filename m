Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790AAC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbiGRAUk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiGRATK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:19:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC4F13F89
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6935560F4E
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB6BC341CA;
        Mon, 18 Jul 2022 00:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103488;
        bh=ztxGb1emLr8kAQy2p62YSdbn2CudtN6HGcwzeU/xlIs=;
        h=Date:To:From:Subject:From;
        b=J/NgiRY4btbw/CenJJXGfQZltCorskDQG7Ec/FieorEmhrD0Ppi25HBNKY4DbiRjC
         EdqOFgS4iPp2NRgQHNAqjTZiPLe4t0+1CtO4VnkNwIgNr9bPa/J1w/qZ1kWSMDp0B7
         BNryL5JN5v4qtJaQJMjr0ZxlQWjRBvgQCbmPVShY=
Date:   Sun, 17 Jul 2022 17:18:08 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsbogend@alpha.franken.de, kernel@xen0n.name, jcmvbkbc@gmail.com,
        James.Bottomley@HansenPartnership.com, guoren@kernel.org,
        dinguyen@kernel.org, deller@gmx.de, chenhuacai@kernel.org,
        arnd@arndb.de, rppt@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] csky-drop-definition-of-pte_order.patch removed from -mm tree
Message-Id: <20220718001808.BCB6BC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: csky: drop definition of PTE_ORDER
has been removed from the -mm tree.  Its filename was
     csky-drop-definition-of-pte_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: csky: drop definition of PTE_ORDER
Date: Sun, 3 Jul 2022 17:11:50 +0300

Patch series "arch: make PxD_ORDER generically available", v2.

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


This patch (of 15):

This is the order of the page table allocation, not the order of a PTE. 
Since its always hardwired to 0, simply drop it.

Link: https://lkml.kernel.org/r/20220705154708.181258-1-rppt@kernel.org
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


