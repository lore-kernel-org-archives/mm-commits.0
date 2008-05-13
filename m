From: akpm@linux-foundation.org
Subject: - mm-pdflushc-merge-the-same-code-in-two-path.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:31 -0700
Message-ID: <200805132133.m4DLXVPV000833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761731AbYEMVdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm/pdflush.c: merge the same code in two path
has been removed from the -mm tree.  Its filename was
     mm-pdflushc-merge-the-same-code-in-two-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/pdflush.c: merge the same code in two path
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pdflush.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/pdflush.c~mm-pdflushc-merge-the-same-code-in-two-path mm/pdflush.c
--- a/mm/pdflush.c~mm-pdflushc-merge-the-same-code-in-two-path
+++ a/mm/pdflush.c
@@ -207,7 +207,6 @@ int pdflush_operation(void (*fn)(unsigne
 
 	spin_lock_irqsave(&pdflush_lock, flags);
 	if (list_empty(&pdflush_list)) {
-		spin_unlock_irqrestore(&pdflush_lock, flags);
 		ret = -1;
 	} else {
 		struct pdflush_work *pdf;
@@ -219,8 +218,9 @@ int pdflush_operation(void (*fn)(unsigne
 		pdf->fn = fn;
 		pdf->arg0 = arg0;
 		wake_up_process(pdf->who);
-		spin_unlock_irqrestore(&pdflush_lock, flags);
 	}
+	spin_unlock_irqrestore(&pdflush_lock, flags);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch

