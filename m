From: akpm@linux-foundation.org
Subject: [merged] liux-next-unbork.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:04:59 -0800
Message-ID: <200902092004.n19K4xoT023884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbZBIUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:06:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     liux-next: unbork
has been removed from the -mm tree.  Its filename was
     liux-next-unbork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
