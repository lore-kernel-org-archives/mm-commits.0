From: akpm@linux-foundation.org
Subject: + alpha-use-printk_once.patch added to -mm tree
Date: Mon, 10 Aug 2009 22:45:06 -0700
Message-ID: <200908110545.n7B5j6H9015575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZHKLyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: use printk_once
has been added to the -mm tree.  Its filename is
     alpha-use-printk_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: use printk_once
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-use-printk_once arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-use-printk_once
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -268,11 +268,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	   assume it doesn't support sg mapping, and, since we tried to
 	   use direct_map above, it now must be considered an error. */
 	if (! alpha_mv.mv_pci_tbi) {
-		static int been_here = 0; /* Only print the message once. */
-		if (!been_here) {
-		    printk(KERN_WARNING "pci_map_single: no HW sg\n");
-		    been_here = 1;
-		}
+		printk_once(KERN_WARNING "pci_map_single: no HW sg\n");
 		return 0;
 	}
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
alpha-use-printk_once.patch

