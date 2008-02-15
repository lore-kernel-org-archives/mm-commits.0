From: akpm@linux-foundation.org
Subject: - m68knommu-fix-coldfire-interrupt-exit-path.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:13 -0500
Message-ID: <200802150719.m1F7JZ7E025717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764032AbYBOH3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walter.t.gruczka@boeing.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: fix coldfire interrupt exit path
has been removed from the -mm tree.  Its filename was
     m68knommu-fix-coldfire-interrupt-exit-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
