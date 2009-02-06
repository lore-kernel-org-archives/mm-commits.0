From: akpm@linux-foundation.org
Subject: + liux-next-unbork.patch added to -mm tree
Date: Fri, 06 Feb 2009 15:41:15 -0800
Message-ID: <200902062341.n16NfFMi016601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbZBFXmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 18:42:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, mingo@elte.hu


The patch titled
     liux-next: unbork
has been added to the -mm tree.  Its filename is
     liux-next-unbork.patch

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
Subject: liux-next: unbork
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/fpu.h |    2 --
 include/linux/types.h       |    3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/ia64/include/asm/fpu.h~liux-next-unbork arch/ia64/include/asm/fpu.h
--- a/arch/ia64/include/asm/fpu.h~liux-next-unbork
+++ a/arch/ia64/include/asm/fpu.h
@@ -6,8 +6,6 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#include <linux/types.h>
-
 /* floating point status register: */
 #define FPSR_TRAP_VD	(1 << 0)	/* invalid op trap disabled */
 #define FPSR_TRAP_DD	(1 << 1)	/* denormal trap disabled */
diff -puN include/linux/types.h~liux-next-unbork include/linux/types.h
--- a/include/linux/types.h~liux-next-unbork
+++ a/include/linux/types.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_TYPES_H
 #define _LINUX_TYPES_H
 
+#ifndef __ASSEMBLY__
 #ifdef	__KERNEL__
 
 #define DECLARE_BITMAP(name,bits) \
@@ -212,5 +213,5 @@ struct ustat {
 };
 
 #endif	/* __KERNEL__ */
