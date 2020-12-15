Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFAEC2BBD5
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E113322D2B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgLOX66 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgLOXUs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:20:48 -0500
Date:   Tue, 15 Dec 2020 15:19:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074370;
        bh=lF03VEVHInk0ePmJfoK+Gq1Kv2jEuGNMlDnkdplGxuc=;
        h=From:To:Subject:From;
        b=nEhJHvdp8x39vUZd6+KYShfpDoUaYQhX2usiHfuvXTagP8C/oTXYV/AFsW20BY/YX
         UvFvlNaVaMAwnP9pSS8ymlYrjHGvWyxrTLbyBaE6gbIy447q51maNinvkSDDMNaVR8
         Uw1rmkYSJzTb86kfp35PoW2YDFRTZFD3l9NcwBuM=
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, catalin.marinas@arm.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, dima@arista.com, hughd@google.com,
        jgg@ziepe.ca, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  [merged]
 mm-mremap-account-memory-on-do_munmap-failure.patch removed from -mm tree
Message-ID: <20201215231929.OqSmBLCaG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap: account memory on do_munmap() failure
has been removed from the -mm tree.  Its filename was
     mm-mremap-account-memory-on-do_munmap-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mm/mremap: account memory on do_munmap() failure

Patch series "mremap: move_vma() fixes".


This patch (of 6):

move_vma() copies VMA without adding it to account, then unmaps old part
of VMA.  On failure it unmaps the new VMA.  With hacks accounting in
munmap is disabled as it's a copy of existing VMA.

Account the memory on munmap() failure which was previously copied into
a new VMA.

Link: https://lkml.kernel.org/r/20201013013416.390574-1-dima@arista.com
Link: https://lkml.kernel.org/r/20201013013416.390574-2-dima@arista.com
Fixes: commit e2ea83742133 ("[PATCH] mremap: move_vma fixes and cleanup")
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-account-memory-on-do_munmap-failure
+++ a/mm/mremap.c
@@ -600,7 +600,8 @@ static unsigned long move_vma(struct vm_
 
 	if (do_munmap(mm, old_addr, old_len, uf_unmap) < 0) {
 		/* OOM: unable to split vma, just get accounts right */
-		vm_unacct_memory(excess >> PAGE_SHIFT);
+		if (vm_flags & VM_ACCOUNT)
+			vm_acct_memory(new_len >> PAGE_SHIFT);
 		excess = 0;
 	}
 
_

Patches currently in -mm which might be from dima@arista.com are


