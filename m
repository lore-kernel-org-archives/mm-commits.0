From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch added
 to -mm tree
Date: Sat, 25 Apr 2020 17:09:18 -0700
Message-ID: <20200426000918.esQkyBxgf%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgDZAJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 25 Apr 2020 20:09:19 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix
has been added to the -mm tree.  Its filename is
     mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix

fix riscv nommu build

Cc: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix
+++ a/arch/riscv/include/asm/pgtable.h
@@ -472,9 +472,9 @@ static inline int ptep_clear_flush_young
 
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
+#define TASK_SIZE		0xffffffffUL
 #define VMALLOC_START		0
