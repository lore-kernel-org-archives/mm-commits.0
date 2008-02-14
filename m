From: akpm@linux-foundation.org
Subject: + m68knommu-fix-coldfire-interrupt-exit-path.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:07:52 -0800
Message-ID: <200802142107.m1EL7qX1002878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43054 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765221AbYBNVI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:08:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walter.t.gruczka@boeing.com, gerg@uclinux.org


The patch titled
     m68knommu: fix coldfire interrupt exit path
has been added to the -mm tree.  Its filename is
     m68knommu-fix-coldfire-interrupt-exit-path.patch

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
Subject: m68knommu: fix coldfire interrupt exit path
From: Walter T Gruczka <walter.t.gruczka@boeing.com>

Remove bogus conditional jump in return from interrupt path.  Reorder the code
path now that is not there.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/coldfire/entry.S |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/m68knommu/platform/coldfire/entry.S~m68knommu-fix-coldfire-interrupt-exit-path arch/m68knommu/platform/coldfire/entry.S
--- a/arch/m68knommu/platform/coldfire/entry.S~m68knommu-fix-coldfire-interrupt-exit-path
+++ a/arch/m68knommu/platform/coldfire/entry.S
@@ -197,14 +197,13 @@ ENTRY(fasthandler)
 	RESTORE_LOCAL
 
 ENTRY(ret_from_interrupt)
-	jeq	2f
-1:
-	RESTORE_ALL
-2:
 	moveb	%sp@(PT_SR),%d0
 	andl	#0x7,%d0
-	jhi	1b
+	jeq	1f
 
+	RESTORE_ALL
+
+1:
 	/* check if we need to do software interrupts */
 	movel	irq_stat+CPUSTAT_SOFTIRQ_PENDING,%d0
 	jeq	ret_from_exception
_

Patches currently in -mm which might be from walter.t.gruczka@boeing.com are

m68knommu-fix-coldfire-interrupt-exit-path.patch
