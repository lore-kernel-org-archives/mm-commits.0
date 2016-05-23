From: akpm@linux-foundation.org
Subject: +
 dma-debug-avoid-spinlock-recursion-when-disabling-dma-debug.patch added to
 -mm tree
Date: Mon, 23 May 2016 15:08:23 -0700
Message-ID: <57437f57.a8zhFziT5HhQG5uZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbcEWWIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 18:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ville.syrjala@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-debug: avoid spinlock recursion when disabling dma-de=
bug
has been added to the -mm tree.  Its filename is
     dma-debug-avoid-spinlock-recursion-when-disabling-dma-debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-avoid-spinlock-r=
ecursion-when-disabling-dma-debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-avoid-spinlock-r=
ecursion-when-disabling-dma-debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
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

dma-debug-avoid-spinlock-recursion-when-disabling-dma-debug.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
