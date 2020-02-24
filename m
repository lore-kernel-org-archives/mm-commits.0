From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 14:13:32 -0800
Message-ID: <20200224221332.iAWxU10Ih%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:13:35 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/vma: add missing VMA flag readable name for VM_SYNC
has been added to the -mm tree.  Its filename is
     mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch

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
Subject: mm/vma: add missing VMA flag readable name for VM_SYNC

Patch series "mm/vma: Use all available wrappers when possible", v2.

Apart from adding a VMA flag readable name for trace purpose, this series
does some open encoding replacements with availabe VMA specific wrappers. 
This skips VM_HUGETLB check in vma_migratable() as its already being done
with another patch (https://patchwork.kernel.org/patch/11347831/) which is
yet to be merged.


This patch (of 4):

This just adds the missing readable name for VM_SYNC.

Link: http://lkml.kernel.org/r/1582520593-30704-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/trace/events/mmflags.h~mm-vma-add-missing-vma-flag-readable-name-for-vm_sync
+++ a/include/trace/events/mmflags.h
@@ -154,6 +154,7 @@ IF_HAVE_PG_IDLE(PG_idle,		"idle"		)
 	{VM_ACCOUNT,			"account"	},		\
 	{VM_NORESERVE,			"noreserve"	},		\
 	{VM_HUGETLB,			"hugetlb"	},		\
+	{VM_SYNC,			"sync"		},		\
 	__VM_ARCH_SPECIFIC_1				,		\
 	{VM_WIPEONFORK,			"wipeonfork"	},		\
 	{VM_DONTDUMP,			"dontdump"	},		\
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
