From: akpm@linux-foundation.org
Subject: + 2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:08:59 -0800
Message-ID: <200803030808.m2388xem006020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbYCCIJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fchecconi@gmail.com, fabio@gandalf.sssup.it


The patch titled
     ioremap: fix off-by-one
has been added to the -mm tree.  Its filename is
     2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

2625-rc2-mm1-warning-at-arch-x86-mm-ioremapc129.patch

