From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
 added to -mm tree
Date: Mon, 24 Feb 2020 14:13:44 -0800
Message-ID: <20200224221344.bbVqA4LiG%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgBXWNq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:13:46 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/vma: replace all remaining open encodings with vma_is_anonymous()
has been added to the -mm tree.  Its filename is
     mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: replace all remaining open encodings with vma_is_anonymous()

This replaces all remaining open encodings with vma_is_anonymous().

Link: http://lkml.kernel.org/r/1582520593-30704-5-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
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
@@ -343,7 +343,8 @@ static struct page *no_page_table(struct
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

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
