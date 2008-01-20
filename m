From: akpm@linux-foundation.org
Subject: + git-x86-pat-fix.patch added to -mm tree
Date: Sun, 20 Jan 2008 11:43:44 -0800
Message-ID: <200801201943.m0KJhOIS032576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbYATToL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 14:44:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, ak@suse.de, balbir@linux.vnet.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     git-x86: PAT fix
has been added to the -mm tree.  Its filename is
     git-x86-pat-fix.patch

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
Subject: git-x86: PAT fix
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix the iounmap() to call free_matrr() unconditionally.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap_32.c |    7 +++----
 arch/x86/mm/ioremap_64.c |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/x86/mm/ioremap_32.c~git-x86-pat-fix arch/x86/mm/ioremap_32.c
--- a/arch/x86/mm/ioremap_32.c~git-x86-pat-fix
+++ a/arch/x86/mm/ioremap_32.c
@@ -219,12 +219,11 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
diff -puN arch/x86/mm/ioremap_64.c~git-x86-pat-fix arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c~git-x86-pat-fix
+++ a/arch/x86/mm/ioremap_64.c
@@ -190,12 +190,11 @@ void iounmap(volatile void __iomem *addr
 		return;
 	}
 
+	free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
+	           p->flags>>20);
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20) {
-		free_mattr(p->phys_addr, p->phys_addr + get_vm_area_size(p),
-		           p->flags>>20);
+	if (p->flags >> 20)
 		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
-	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

git-x86.patch
git-x86-pat-fix.patch
