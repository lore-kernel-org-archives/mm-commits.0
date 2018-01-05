From: akpm@linux-foundation.org
Subject: [patch 7/9] mm/sparse.c: wrong allocation for mem_section
Date: Thu, 04 Jan 2018 16:18:06 -0800
Message-ID: <5a4ec43e.NzgH5NYPUn1j4q0D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEASH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bhe@redhat.com, ats-kumagai@wm.jp.nec.com, dyoung@redhat.com, kirill.shutemov@linux.intel.com, luto@amacapital.net, mingo@kernel.org, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de

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
