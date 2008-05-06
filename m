From: akpm@linux-foundation.org
Subject: + mm-pdflushc-merge-the-same-code-in-two-path.patch added to -mm tree
Date: Mon, 05 May 2008 23:14:12 -0700
Message-ID: <200805060614.m466ECaw025227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbYEFGOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 02:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com


The patch titled
     mm/pdflush.c: merge the same code in two path
has been added to the -mm tree.  Its filename is
     mm-pdflushc-merge-the-same-code-in-two-path.patch

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

mm-pdflushc-merge-the-same-code-in-two-path.patch

