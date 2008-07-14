From: akpm@linux-foundation.org
Subject: + x86-remove-init_mm-export-as-planned-for-2626.patch added to -mm tree
Date: Sun, 13 Jul 2008 21:34:17 -0700
Message-ID: <200807140434.m6E4YH7l022377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbYGNEfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 00:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davej@redhat.com, hch@lst.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: remove init_mm export as planned for 2.6.26
has been added to the -mm tree.  Its filename is
     x86-remove-init_mm-export-as-planned-for-2626.patch

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
Subject: x86: remove init_mm export as planned for 2.6.26
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 ------------
 arch/x86/kernel/init_task.c                |    1 -
 2 files changed, 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~x86-remove-init_mm-export-as-planned-for-2626 Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~x86-remove-init_mm-export-as-planned-for-2626
+++ a/Documentation/feature-removal-schedule.txt
@@ -263,18 +263,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	init_mm export
-When:	2.6.26
-Why:	Not used in-tree. The current out-of-tree users used it to
-	work around problems in the CPA code which should be resolved
-	by now. One usecase was described to provide verification code
-	of the CPA operation. That's a good idea in general, but such
-	code / infrastructure should be in the kernel and not in some
-	out-of-tree driver.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
-----------------------------
