From: akpm@linux-foundation.org
Subject: [merged] warn_once-use-bool-for-boolean-flag.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:23 -0800
Message-ID: <200912152155.nBFLtNg9015483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933757AbZLOV4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, dwalker@fifo99.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     WARN_ONCE(): use bool for boolean flag
has been removed from the -mm tree.  Its filename was
     warn_once-use-bool-for-boolean-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: WARN_ONCE(): use bool for boolean flag
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Commit 70867453092297be9afb2249e712a1f960ec0a09 ("printk_once(): use bool
for boolean flag") changed printk_once() to use bool instead of int for
its guard variable.  Do the same change to WARN_ONCE() and WARN_ON_ONCE(),
for the same reasons.

This resulted in a reduction of 1462 bytes on a x86-64 defconfig:

   text    data     bss     dec     hex filename
8101271 1207116  992764 10301151         9d2edf vmlinux.before
8100553 1207148  991988 10299689         9d2929 vmlinux.after

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/bug.h~warn_once-use-bool-for-boolean-flag include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~warn_once-use-bool-for-boolean-flag
+++ a/include/asm-generic/bug.h
@@ -113,22 +113,22 @@ extern void warn_slowpath_null(const cha
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN_ON(!__warned)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static int __warned;					\
+	static bool __warned;					\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN(!__warned, format)) 			\
-			__warned = 1;				\
+			__warned = true;			\
 	unlikely(__ret_warn_once);				\
 })
 
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch

