From: akpm@linux-foundation.org
Subject: - i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:57:16 -0700
Message-ID: <200708242057.l7OKvGJi014214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761434AbXHXVIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, jeremy@goop.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     i386: fix lazy mode vmalloc synchronization for paravirt
has been removed from the -mm tree.  Its filename was
     i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: fix lazy mode vmalloc synchronization for paravirt
From: Zachary Amsden <zach@vmware.com>

Found this looping Ubuntu installs with VMI.

If unlucky enough to hit a vmalloc sync fault during a lazy mode
operation (from an IRQ handler for a module which was not yet populated
in current page directory, or from inside copy_one_pte, which touches
swap_map, and hit in an unused 4M region), the required PDE update would
never get flushed, causing an infinite page fault loop.

This bug affects any paravirt-ops backend which uses lazy updates, I
believe that makes it a bug in Xen, VMI and lguest.  It only happens on
LOWMEM kernels.


Touching vmalloc memory in the middle of a lazy mode update can generate a
kernel PDE update, which must be flushed immediately.  The fix is to leave
lazy mode when doing a vmalloc sync.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mm/fault.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/i386/mm/fault.c~i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt arch/i386/mm/fault.c
--- a/arch/i386/mm/fault.c~i386-fix-lazy-mode-vmalloc-synchronization-for-paravirt
+++ a/arch/i386/mm/fault.c
@@ -249,9 +249,10 @@ static inline pmd_t *vmalloc_sync_one(pg
 	pmd_k = pmd_offset(pud_k, address);
 	if (!pmd_present(*pmd_k))
 		return NULL;
-	if (!pmd_present(*pmd))
+	if (!pmd_present(*pmd)) {
 		set_pmd(pmd, *pmd_k);
-	else
+		arch_flush_lazy_mmu_mode();
+	} else
 		BUG_ON(pmd_page(*pmd) != pmd_page(*pmd_k));
 	return pmd_k;
 }
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
