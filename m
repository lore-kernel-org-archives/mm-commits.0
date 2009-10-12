From: akpm@linux-foundation.org
Subject: + alpha-fix-f_setown_ex-and-f_getlk64-conflict.patch added to -mm tree
Date: Mon, 12 Oct 2009 14:50:45 -0700
Message-ID: <200910122150.n9CLojxL027024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932725AbZJLVw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 17:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, ink@jurassic.park.msu.ru, joseph@codesourcery.com, rth@twiddle.net, torvalds@linux-foundation.org


The patch titled
     alpha: fix F_SETOWN_EX and F_GETLK64 conflict
has been added to the -mm tree.  Its filename is
     alpha-fix-f_setown_ex-and-f_getlk64-conflict.patch

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
Subject: alpha: fix F_SETOWN_EX and F_GETLK64 conflict
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix a bug in

    commit ba0a6c9f6fceed11c6a99e8326f0477fe383e6b5
    Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
    AuthorDate: Wed Sep 23 15:57:03 2009 -0700
    Commit:     Linus Torvalds <torvalds@linux-foundation.org>
    CommitDate: Thu Sep 24 07:21:01 2009 -0700

        fcntl: add F_[SG]ETOWN_EX

In asm-generic/fcntl.h, F_SETOWN_EX and F_GETLK64 both have value 12, and
F_GETOWN_EX and F_SETLK64 both have value 13.

Reported-by: "Joseph S. Myers" <joseph@codesourcery.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/alpha/include/asm/fcntl.h~alpha-fix-f_setown_ex-and-f_getlk64-conflict arch/alpha/include/asm/fcntl.h
--- a/arch/alpha/include/asm/fcntl.h~alpha-fix-f_setown_ex-and-f_getlk64-conflict
+++ a/arch/alpha/include/asm/fcntl.h
@@ -26,8 +26,8 @@
 #define F_GETOWN	6	/*  for sockets. */
 #define F_SETSIG	10	/*  for sockets. */
 #define F_GETSIG	11	/*  for sockets. */
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 
 /* for posix fcntl() and lockf() */
 #define F_RDLCK		1
diff -puN include/asm-generic/fcntl.h~alpha-fix-f_setown_ex-and-f_getlk64-conflict include/asm-generic/fcntl.h
--- a/include/asm-generic/fcntl.h~alpha-fix-f_setown_ex-and-f_getlk64-conflict
+++ a/include/asm-generic/fcntl.h
@@ -73,9 +73,18 @@
 #define F_SETSIG	10	/* for sockets. */
 #define F_GETSIG	11	/* for sockets. */
 #endif
+
+#ifndef CONFIG_64BIT
+#ifndef F_GETLK64
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+#endif
+#endif
+
 #ifndef F_SETOWN_EX
-#define F_SETOWN_EX	12
-#define F_GETOWN_EX	13
+#define F_SETOWN_EX	15
+#define F_GETOWN_EX	16
 #endif
 
 #define F_OWNER_TID	0
@@ -139,12 +148,6 @@ struct flock {
 
 #ifndef CONFIG_64BIT
 
-#ifndef F_GETLK64
-#define F_GETLK64	12	/*  using 'struct flock64' */
-#define F_SETLK64	13
-#define F_SETLKW64	14
-#endif
