From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 005/166] mm/vma: add missing VMA flag readable
 name for VM_SYNC
Date: Mon, 06 Apr 2020 20:03:43 -0700
Message-ID: <20200407030343.fQ5woGR9q%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGDDr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:03:47 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, arnd@arndb.de, benh@kernel.crashing.org, dalias@libc.org, dave.hansen@linux.intel.com, geert@linux-m68k.org, guoren@kernel.org, linux-mm@kvack.org, luto@kernel.org, mgorman@suse.de, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com, paulburton@kernel.org, paulus@ozlabs.org, paulus@samba.org, peterz@infradead.org, ralf@linux-mips.org, rostedt@goodmis.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, viro@zeniv.linux.org.uk, will@kernel.org, ysato@users.sourceforge.jp

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
Cc: Vlastimil Babka <vbabka@suse.cz>
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
