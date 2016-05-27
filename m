From: akpm@linux-foundation.org
Subject: [merged]
 dma-debug-avoid-spinlock-recursion-when-disabling-dma-debug.patch removed
 from -mm tree
Date: Fri, 27 May 2016 11:45:36 -0700
Message-ID: <574895d0.dLbPwQ4DdOco8bXn%akpm__36563.9787436978$1464374745$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42733 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0Sph (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ville.syrjala@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: avoid spinlock recursion when disabling dma-de=
bug
has been removed from the -mm tree.  Its filename was
     dma-debug-avoid-spinlock-recursion-when-disabling-dma-debug.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom:  Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
Subject: dma-debug: avoid spinlock recursion when disabling dma-debug

With netconsole (at least) the pr_err("...  disablingn") call can recur=
se
back into the dma-debug code, where it'll try to grab free_entries_lock
again.  Avoid the problem by doing the printk after dropping the lock.

Link: http://lkml.kernel.org/r/1463678421-18683-1-git-send-email-ville.=
syrjala@linux.intel.com
Signed-off-by: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dma-debug.c~dma-debug-avoid-spinlock-recursion-when-disab=
ling-dma-debug lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-avoid-spinlock-recursion-when-disabling=
-dma-debug
+++ a/lib/dma-debug.c
@@ -657,9 +657,9 @@ static struct dma_debug_entry *dma_entry
 	spin_lock_irqsave(&free_entries_lock, flags);
=20
 	if (list_empty(&free_entries)) {
-		pr_err("DMA-API: debugging out of memory - disabling\n");
 		global_disable =3D true;
 		spin_unlock_irqrestore(&free_entries_lock, flags);
+		pr_err("DMA-API: debugging out of memory - disabling\n");
 		return NULL;
 	}
=20
_

Patches currently in -mm which might be from ville.syrjala@linux.intel.=
com are


--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
