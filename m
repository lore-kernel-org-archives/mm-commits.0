From: akpm@linux-foundation.org
Subject: [merged]
 c6x-asm-pgtable-define-dummy-pgprot_writecombine-for-mmu.patch removed from -mm tree
Date: Mon, 16 Mar 2015 11:02:44 -0700
Message-ID: <55071ac4.01bdV608epvJAguM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125AbbCPSCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 762976180@qq.com, a-jacquiot@ti.com, gang.chen.5i5j@gmail.com, kirill@shutemov.name, msalter@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/c6x/include/asm/pgtable.h: define dummy pgprot_writecombine for !MMU
has been removed from the -mm tree.  Its filename was
     c6x-asm-pgtable-define-dummy-pgprot_writecombine-for-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <762976180@qq.com>
Subject: arch/c6x/include/asm/pgtable.h: define dummy pgprot_writecombine for !MMU

When !MMU, asm-generic will not define default pgprot_writecombine, so c6x
needs to define it by itself.  The related error:

    CC [M]  fs/pstore/ram_core.o
  fs/pstore/ram_core.c: In function 'persistent_ram_vmap':
  fs/pstore/ram_core.c:399:10: error: implicit declaration of function 'pgprot_writecombine' [-Werror=implicit-function-declaration]
     prot = pgprot_writecombine(PAGE_KERNEL);
            ^
  fs/pstore/ram_core.c:399:8: error: incompatible types when assigning to type 'pgprot_t {aka struct <anonymous>}' from type 'int'
     prot = pgprot_writecombine(PAGE_KERNEL);
          ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/c6x/include/asm/pgtable.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN arch/c6x/include/asm/pgtable.h~c6x-asm-pgtable-define-dummy-pgprot_writecombine-for-mmu arch/c6x/include/asm/pgtable.h
--- a/arch/c6x/include/asm/pgtable.h~c6x-asm-pgtable-define-dummy-pgprot_writecombine-for-mmu
+++ a/arch/c6x/include/asm/pgtable.h
@@ -67,6 +67,11 @@ extern unsigned long empty_zero_page;
  */
 #define pgtable_cache_init()   do { } while (0)
 
+/*
+ * c6x is !MMU, so define the simpliest implementation
+ */
+#define pgprot_writecombine pgprot_noncached
+
 #include <asm-generic/pgtable.h>
 
 #endif /* _ASM_C6X_PGTABLE_H */
_

Patches currently in -mm which might be from 762976180@qq.com are

mm-memcontrol-let-mem_cgroup_move_account-have-effect-only-if-mmu-enabled.patch

