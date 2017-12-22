From: akpm@linux-foundation.org
Subject: + mm-sparsec-wrong-allocation-for-mem_section.patch added to -mm
 tree
Date: Fri, 22 Dec 2017 14:20:42 -0800
Message-ID: <5a3d853a.rb3xa6WKKMLN1p5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46582 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755458AbdLVWUn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Dec 2017 17:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, ats-kumagai@wm.jp.nec.com, dyoung@redhat.com, kirill.shutemov@linux.intel.com, luto@amacapital.net, mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/sparse.c: wrong allocation for mem_section
has been added to the -mm tree.  Its filename is
     mm-sparsec-wrong-allocation-for-mem_section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-wrong-allocation-for-mem_section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-wrong-allocation-for-mem_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
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

mm-sparsec-wrong-allocation-for-mem_section.patch

