From: akpm@linux-foundation.org
Subject: + introduce-dump_vma-fix-2.patch added to -mm tree
Date: Wed, 03 Sep 2014 11:22:04 -0700
Message-ID: <54075c4c.jZ3wW5LmPb2ELl1m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaICSWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 14:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swarren@nvidia.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix dump_vma() compilation
has been added to the -mm tree.  Its filename is
     introduce-dump_vma-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/introduce-dump_vma-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/introduce-dump_vma-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -6736,7 +6736,8 @@ void dump_vma(const struct vm_area_struc
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

introduce-dump_vma-fix-2.patch
linux-next.patch

