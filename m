From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:56:35 -0700
Message-ID: <20200408015635.tzgOquGuL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726436AbgDHB4i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/vma: replace all remaining open encodings with vma_is_anonymous()
has been removed from the -mm tree.  Its filename was
     mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: replace all remaining open encodings with vma_is_anonymous()

This replaces all remaining open encodings with vma_is_anonymous().

Link: http://lkml.kernel.org/r/1582520593-30704-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous
+++ a/mm/gup.c
@@ -351,7 +351,8 @@ static struct page *no_page_table(struct
 	 * But we can only make this optimization where a hole would surely
 	 * be zero-filled if handle_mm_fault() actually did handle it.
 	 */
-	if ((flags & FOLL_DUMP) && (!vma->vm_ops || !vma->vm_ops->fault))
+	if ((flags & FOLL_DUMP) &&
+			(vma_is_anonymous(vma) || !vma->vm_ops->fault))
 		return ERR_PTR(-EFAULT);
 	return NULL;
 }
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-vma-define-a-default-value-for-vm_data_default_flags.patch
mm-vma-introduce-vm_access_flags.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial.patch
mm-special-create-generic-fallbacks-for-pte_special-and-pte_mkspecial-v3.patch
mm-debug-add-tests-validating-architecture-page-table-helpers.patch
