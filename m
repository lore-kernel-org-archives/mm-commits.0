From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 004/128] arch/parisc/include/asm/pgtable.h: remove
 unused `old_pte'
Date: Tue, 02 Jun 2020 13:10:05 -0700
Message-ID: <20200602201005.C1oG2j4Oq%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUKH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:10:07 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com, torvalds@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/parisc/include/asm/pgtable.h: remove unused `old_pte'

parisc's set_pte_at() macro has set-but-not-used variable.

include/linux/pgtable.h: In function 'pte_clear_not_present_full':
arch/parisc/include/asm/pgtable.h:96:9: warning: variable 'old_pte' set but not used [-Wunused-but-set-variable]

Reported-by: kbuild test robot <lkp@intel.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/parisc/include/asm/pgtable.h~arch-parisc-include-asm-pgtableh-remove-unused-old_pte
+++ a/arch/parisc/include/asm/pgtable.h
@@ -93,10 +93,8 @@ static inline void purge_tlb_entries(str
 
 #define set_pte_at(mm, addr, ptep, pteval)			\
 	do {							\
-		pte_t old_pte;					\
 		unsigned long flags;				\
 		spin_lock_irqsave(pgd_spinlock((mm)->pgd), flags);\
-		old_pte = *ptep;				\
 		set_pte(ptep, pteval);				\
 		purge_tlb_entries(mm, addr);			\
 		spin_unlock_irqrestore(pgd_spinlock((mm)->pgd), flags);\
_
