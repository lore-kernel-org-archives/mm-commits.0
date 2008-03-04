From: akpm@linux-foundation.org
Subject: - 2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:13 -0800
Message-ID: <200803042010.m24KADps026890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634AbYCDUTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fchecconi@gmail.com, fabio@gandalf.sssup.it, mm-commits@vger.kernel.org


The patch titled
     ioremap: fix off-by-one
has been removed from the -mm tree.  Its filename was
     2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ioremap: fix off-by-one
From: Fabio Checconi <fchecconi@gmail.com>

Fix "WARNING at arch/x86/mm/ioremap.c:129".

__ioremap() emits a warning if the pfn after the last one it's going to map is
of normal ram.  Correct this and emit the warning (once) only if one of the
asked pages is.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/ioremap.c~2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129 arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129
+++ a/arch/x86/mm/ioremap.c
@@ -109,7 +109,7 @@ static int ioremap_change_attr(unsigned 
 static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 			       enum ioremap_mode mode)
 {
-	unsigned long pfn, offset, last_addr, vaddr;
+	unsigned long pfn, offset, last_addr, vaddr, is_ram = 0;
 	struct vm_struct *area;
 	pgprot_t prot;
 
@@ -132,9 +132,10 @@ static void __iomem *__ioremap(unsigned 
 		if (page_is_ram(pfn) && pfn_valid(pfn) &&
 		    !PageReserved(pfn_to_page(pfn)))
 			return NULL;
+		is_ram |= page_is_ram(pfn);
 	}
 
-	WARN_ON_ONCE(page_is_ram(pfn));
+	WARN_ON_ONCE(is_ram);
 
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
_

Patches currently in -mm which might be from fchecconi@gmail.com are


