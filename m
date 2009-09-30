From: akpm@linux-foundation.org
Subject: + warn_once-use-bool-for-boolean-flag.patch added to -mm tree
Date: Wed, 30 Sep 2009 15:53:27 -0700
Message-ID: <200909302253.n8UMrRLU020827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbZI3WyW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 18:54:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, dwalker@fifo99.com, rolandd@cisco.com


The patch titled
     WARN_ONCE(): use bool for boolean flag
has been added to the -mm tree.  Its filename is
     warn_once-use-bool-for-boolean-flag.patch

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

warn_once-use-bool-for-boolean-flag.patch

