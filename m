From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 14/35] mm: define pte_index as macro for x86
Date: Fri, 10 Apr 2020 14:32:58 -0700
Message-ID: <20200410213258.6ZdCCXWqN%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVdA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:00 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjunroy@google.com, davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca, linux-mm@kvack.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com, torvalds@linux-foundation.org, willy@infradead.org

From: Arjun Roy <arjunroy@google.com>
Subject: mm: define pte_index as macro for x86

pte_index() is either defined as a macro (e.g.  sparc64) or as an inlined
function (e.g.  x86).  vm_insert_pages() depends on pte_index but it is
not defined on all platforms (e.g.  m68k).

To fix compilation of vm_insert_pages() on architectures not providing
pte_index(), we perform the following fix:

0. For platforms where it is meaningful, and defined as a macro, no
    change is needed.
1. For platforms where it is meaningful and defined as an inlined
    function, and we want to use it with vm_insert_pages(), we define
    a degenerate macro of the form:  #define pte_index pte_index
2. vm_insert_pages() checks for the existence of a pte_index macro
   definition. If found, it implements a batched insert. If not found,
   it devolves to calling vm_insert_page() in a loop.

This patch implements step 1 for x86.

v3 of this patch fixes a compilation warning for an unused method.
v2 of this patch moved a macro definition to a more readable location.

Link: http://lkml.kernel.org/r/20200228054714.204424-1-arjunroy.kdev@gmail.com
Signed-off-by: Arjun Roy <arjunroy@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/include/asm/pgtable.h~mm-define-pte_index-as-macro-for-x86
+++ a/arch/x86/include/asm/pgtable.h
@@ -860,7 +860,10 @@ static inline unsigned long pmd_index(un
  *
  * this function returns the index of the entry in the pte page which would
  * control the given virtual address
+ *
+ * Also define macro so we can test if pte_index is defined for arch.
  */
+#define pte_index pte_index
 static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
_
