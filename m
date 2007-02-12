From: akpm@linux-foundation.org
Subject: - include-linux-kernelh-remove-labs.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:16 -0800
Message-ID: <200702122243.l1CMhGm6013486@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44832 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030236AbXBLWnW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, mm-commits@vger.kernel.org


The patch titled
     include/linux/kernel.h: Remove labs()
has been removed from the -mm tree.  Its filename was
     include-linux-kernelh-remove-labs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/linux/kernel.h: Remove labs()
From: Richard Knutsson <ricknu-0@student.ltu.se>

Remove labs() since it is not used/needed.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/kernel.h~include-linux-kernelh-remove-labs include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-kernelh-remove-labs
+++ a/include/linux/kernel.h
@@ -92,11 +92,6 @@ extern int cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#define labs(x) ({				\
-		long __x = (x);			\
-		(__x < 0) ? -__x : __x;		\
-	})
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
git-dvb.patch
