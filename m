From: akpm@linux-foundation.org
Subject: [merged] mm-sparsec-wrong-allocation-for-mem_section.patch
 removed from -mm tree
Date: Fri, 12 Jan 2018 13:44:02 -0800
Message-ID: <20180112214402.M0x7r0dYs%akpm__3463.76484162665$1515793338$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965253AbeALVoK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 16:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ats-kumagai@wm.jp.nec.com, bhe@redhat.com, dyoung@redhat.com, kirill.shutemov@linux.intel.com, luto@amacapital.net, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de


The patch titled
     Subject: mm/sparse.c: wrong allocation for mem_section
has been removed from the -mm tree.  Its filename was
     mm-sparsec-wrong-allocation-for-mem_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: wrong allocation for mem_section

In 83e3c48729 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y") mem_section is allocated at runtime to save memory. While it allocates
the first dimension of array with sizeof(struct mem_section). It costs
extra memory, should be sizeof(struct mem_section*).

Fix it.

Link: http://lkml.kernel.org/r/1513932498-20350-1-git-send-email-bhe@redhat.com
Fixes: 83e3c48729 ("mm/sparsemem: Allocate mem_section at runtime for CONFIG_SPARSEMEM_EXTREME=y")
Signed-off-by: Baoquan He <bhe@redhat.com>
Tested-by: Dave Young <dyoung@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-sparsec-wrong-allocation-for-mem_section mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-wrong-allocation-for-mem_section
+++ a/mm/sparse.c
@@ -211,7 +211,7 @@ void __init memory_present(int nid, unsi
 	if (unlikely(!mem_section)) {
 		unsigned long size, align;
 
-		size = sizeof(struct mem_section) * NR_SECTION_ROOTS;
+		size = sizeof(struct mem_section*) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
 		mem_section = memblock_virt_alloc(size, align);
 	}
_

Patches currently in -mm which might be from bhe@redhat.com are


