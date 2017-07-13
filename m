From: akpm@linux-foundation.org
Subject: [merged]
 mm-mark-create_huge_pmd-inline-to-prevent-build-failure.patch removed from
 -mm tree
Date: Thu, 13 Jul 2017 13:39:57 -0700
Message-ID: <20170713203957.Z1tagGMzB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753285AbdGMUj6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dan.j.williams@intel.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: mark create_huge_pmd() inline to prevent build failure
has been removed from the -mm tree.  Its filename was
     mm-mark-create_huge_pmd-inline-to-prevent-build-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mm/memory.c: mark create_huge_pmd() inline to prevent build failure

With gcc 4.1.2:

    mm/memory.o: In function `create_huge_pmd':
    memory.c:(.text+0x93e): undefined reference to `do_huge_pmd_anonymous_page'

Interestingly, create_huge_pmd() is emitted in the assembler output, but
never called.

Converting transparent_hugepage_enabled() from a macro to a static
inline function reduced the ability of the compiler to remove unused
code.

Fix this by marking create_huge_pmd() inline.

Fixes: 16981d763501c0e0 ("mm: improve readability of transparent_hugepage_enabled()")
Link: http://lkml.kernel.org/r/1499842660-10665-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-mark-create_huge_pmd-inline-to-prevent-build-failure mm/memory.c
--- a/mm/memory.c~mm-mark-create_huge_pmd-inline-to-prevent-build-failure
+++ a/mm/memory.c
@@ -3591,7 +3591,7 @@ out:
 	return 0;
 }
 
-static int create_huge_pmd(struct vm_fault *vmf)
+static inline int create_huge_pmd(struct vm_fault *vmf)
 {
 	if (vma_is_anonymous(vmf->vma))
 		return do_huge_pmd_anonymous_page(vmf);
_

Patches currently in -mm which might be from geert@linux-m68k.org are


