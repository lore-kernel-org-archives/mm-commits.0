From: akpm@linux-foundation.org
Subject: + mm-memblock-make-memblock_remove_range-static.patch added to
 -mm tree
Date: Tue, 15 Sep 2015 15:28:24 -0700
Message-ID: <55f89b88.wDKHOFTeEzdCuwLz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbIOW2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Sep 2015 18:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: make memblock_remove_range() static
has been added to the -mm tree.  Its filename is
     mm-memblock-make-memblock_remove_range-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-make-memblock_remove_range-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-make-memblock_remove_range-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock: make memblock_remove_range() static

memblock_remove_range() is only used in the mm/memblock.c, so we can make
it static.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ----
 mm/memblock.c            |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-make-memblock_remove_range-static include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-make-memblock_remove_range-static
+++ a/include/linux/memblock.h
@@ -89,10 +89,6 @@ int memblock_add_range(struct memblock_t
 		       phys_addr_t base, phys_addr_t size,
 		       int nid, unsigned long flags);
 
-int memblock_remove_range(struct memblock_type *type,
-			  phys_addr_t base,
-			  phys_addr_t size);
-
 void __next_mem_range(u64 *idx, int nid, ulong flags,
 		      struct memblock_type *type_a,
 		      struct memblock_type *type_b, phys_addr_t *out_start,
diff -puN mm/memblock.c~mm-memblock-make-memblock_remove_range-static mm/memblock.c
--- a/mm/memblock.c~mm-memblock-make-memblock_remove_range-static
+++ a/mm/memblock.c
@@ -706,7 +706,7 @@ static int __init_memblock memblock_isol
 	return 0;
 }
 
-int __init_memblock memblock_remove_range(struct memblock_type *type,
+static int __init_memblock memblock_remove_range(struct memblock_type *type,
 					  phys_addr_t base, phys_addr_t size)
 {
 	int start_rgn, end_rgn;
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-msync-use-offset_in_page-macro.patch
mm-nommu-use-offset_in_page-macro.patch
mm-mincore-use-offset_in_page-macro.patch
mm-early_ioremap-use-offset_in_page-macro.patch
mm-percpu-use-offset_in_page-macro.patch
mm-util-use-offset_in_page-macro.patch
mm-mlock-use-offset_in_page-macro.patch
mm-vmalloc-use-offset_in_page-macro.patch
mm-mmap-use-offset_in_page-macro.patch
mm-mremap-use-offset_in_page-macro.patch
mm-memblock-make-memblock_remove_range-static.patch
lib-halfmd4-use-rol32-inline-function-in-the-round-macro.patch

