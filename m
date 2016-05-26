From: akpm@linux-foundation.org
Subject: [patch 08/10] dma-debug: avoid spinlock recursion when disabling
 dma-debug
Date: Thu, 26 May 2016 15:16:25 -0700
Message-ID: <574775b9.1raGhE6zdmCwsBoE%akpm__22300.9024667137$1464300994$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbcEZWQ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ville.syrjala@linux.intel.com, stable@vger.kernel.org

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
--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
