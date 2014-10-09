From: akpm@linux-foundation.org
Subject: [folded-merged] introduce-dump_vma-fix-2.patch removed from -mm
 tree
Date: Thu, 09 Oct 2014 13:39:10 -0700
Message-ID: <5436f26e.gmx+QgtDt9J6yxnP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaJIUjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swarren@nvidia.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix dump_vma() compilation
has been removed from the -mm tree.  Its filename was
     introduce-dump_vma-fix-2.patch

This patch was dropped because it was folded into introduce-dump_vma.patch

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: mm: fix dump_vma() compilation

dump_vma() was written to access fields within vma->vm_page_prot. However,
pgprot_t is sometimes a scalar and sometimes a struct (At least on ARM;
see arch/arm/include/asm/pgtable-2level-types.h). use macro pgprot_val()
to get the value, so the code is immune to these differences.

This fixes:
mm/page_alloc.c: In function `dump_vma':
mm/page_alloc.c:6742:46: error: request for member `pgprot' in something not a structure or union

The cast is required to avoid:

mm/page_alloc.c: In function `dump_vma':
mm/page_alloc.c:6745:3: warning: format `%lx' expects argument of type `long unsigned int', but argument 8 has type `pgprot_t' [-Wformat]

Fixes: 658f7da49d34 ("mm: introduce dump_vma")
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~introduce-dump_vma-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-dump_vma-fix-2
+++ a/mm/page_alloc.c
@@ -6734,7 +6734,8 @@ void dump_vma(const struct vm_area_struc
 		"prot %lx anon_vma %p vm_ops %p\n"
 		"pgoff %lx file %p private_data %p\n",
 		vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
-		vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
+		vma->vm_prev, vma->vm_mm,
+		(unsigned long)pgprot_val(vma->vm_page_prot),
 		vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
 		vma->vm_file, vma->vm_private_data);
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
_

Patches currently in -mm which might be from swarren@nvidia.com are

origin.patch
introduce-dump_vma.patch

