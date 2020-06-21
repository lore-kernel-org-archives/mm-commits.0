From: akpm@linux-foundation.org
Subject: +
 mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx.patch added to -mm
 tree
Date: Sat, 20 Jun 2020 17:43:22 -0700
Message-ID: <20200621004322.CCrzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgFUAnY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 20:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org, paulus@samba.org, mpe@ellerman.id.au, benh@kernel.crashing.org, anshuman.khandual@arm.com, christophe.leroy@csgroup.eu


The patch titled
     Subject: mm/debug_vm_pgtable: fix build failure with powerpc 8xx
has been added to the -mm tree.  Its filename is
     mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/debug_vm_pgtable: fix build failure with powerpc 8xx

Since commit 9e343b467c70 ("READ_ONCE: Enforce atomicity for
{READ,WRITE}_ONCE() memory accesses"), READ_ONCE() cannot be used anymore
to read complex page table entries.  This leads to:

  CC      mm/debug_vm_pgtable.o
In file included from ./include/asm-generic/bug.h:5,
                 from ./arch/powerpc/include/asm/bug.h:109,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/mmdebug.h:5,
                 from ./include/linux/gfp.h:5,
                 from mm/debug_vm_pgtable.c:13:
In function 'pte_clear_tests',
    inlined from 'debug_vm_pgtable' at mm/debug_vm_pgtable.c:363:2:
./include/linux/compiler.h:392:38: error: call to '__compiletime_assert_210' declared with attribute error: Unsupported access size for {READ,WRITE}_ONCE().
  392 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |                                      ^
./include/linux/compiler.h:373:4: note: in definition of macro '__compiletime_assert'
  373 |    prefix ## suffix();    \
      |    ^~~~~~
./include/linux/compiler.h:392:2: note: in expansion of macro '_compiletime_assert'
  392 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
      |  ^~~~~~~~~~~~~~~~~~~
./include/linux/compiler.h:405:2: note: in expansion of macro 'compiletime_assert'
  405 |  compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long), \
      |  ^~~~~~~~~~~~~~~~~~
./include/linux/compiler.h:291:2: note: in expansion of macro 'compiletime_assert_rwonce_type'
  291 |  compiletime_assert_rwonce_type(x);    \
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/debug_vm_pgtable.c:249:14: note: in expansion of macro 'READ_ONCE'
  249 |  pte_t pte = READ_ONCE(*ptep);
      |              ^~~~~~~~~
make[2]: *** [mm/debug_vm_pgtable.o] Error 1

Fix it by using the recently added ptep_get() helper.

Link: http://lkml.kernel.org/r/6ca8c972e6c920dc4ae0d4affbed9703afa4d010.1592490570.git.christophe.leroy@csgroup.eu
Fixes: 9e343b467c70 ("READ_ONCE: Enforce atomicity for {READ,WRITE}_ONCE() memory accesses")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx
+++ a/mm/debug_vm_pgtable.c
@@ -246,13 +246,13 @@ static void __init pgd_populate_tests(st
 static void __init pte_clear_tests(struct mm_struct *mm, pte_t *ptep,
 				   unsigned long vaddr)
 {
-	pte_t pte = READ_ONCE(*ptep);
+	pte_t pte = ptep_get(ptep);
 
 	pte = __pte(pte_val(pte) | RANDOM_ORVALUE);
 	set_pte_at(mm, vaddr, ptep, pte);
 	barrier();
 	pte_clear(mm, vaddr, ptep);
-	pte = READ_ONCE(*ptep);
+	pte = ptep_get(ptep);
 	WARN_ON(!pte_none(pte));
 }
 
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-debug_vm_pgtable-fix-build-failure-with-powerpc-8xx.patch
