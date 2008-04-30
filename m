From: akpm@linux-foundation.org
Subject: - s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:24 -0700
Message-ID: <200804300550.m3U5oO7D030110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106AbYD3Ful (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use kbuild.h instead of defining macros in asm-offsets.c
has been removed from the -mm tree.  Its filename was
     s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390: use kbuild.h instead of defining macros in asm-offsets.c
From: Christoph Lameter <clameter@sgi.com>

s390 has a strange marker in DEFINE.  Undefine the DEFINE from kbuild.h and
define it the way s390 wants it to preserve things as they were.

May be good if the arch maintainer could go over this and check if this
workaround is really necessary.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/asm-offsets.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc arch/s390/kernel/asm-offsets.c
--- a/arch/s390/kernel/asm-offsets.c~s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc
+++ a/arch/s390/kernel/asm-offsets.c
@@ -5,14 +5,13 @@
  */
 
 #include <linux/sched.h>
+#include <linux/kbuild.h>
 
 /* Use marker if you need to separate the values later */
-
+#undef DEFINE
 #define DEFINE(sym, val, marker) \
 	asm volatile("\n->" #sym " %0 " #val " " #marker : : "i" (val))
 
-#define BLANK() asm volatile("\n->" : : )
