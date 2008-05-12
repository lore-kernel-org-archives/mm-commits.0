From: akpm@linux-foundation.org
Subject: + asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch added to -mm tree
Date: Mon, 12 May 2008 15:33:48 -0700
Message-ID: <200805122233.m4CMXmSU012493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbYELWea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, chris@zankel.net, ink@jurassic.park.msu.ru, jdike@addtoit.com, rth@twiddle.net, ysato@users.sourceforge.jp


The patch titled
     asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
has been added to the -mm tree.  Its filename is
     asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch

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
Subject: asm-{alpha,h8300,um,v850,xtensa}/param.h: unbreak HZ for userspace
From: Mike Frysinger <vapier@gentoo.org>

I noticed this because alpha was broken due to the recent
bdc807871d58285737.  Most arches do something like this in their
asm/param.h:

#ifdef __KERNEL__
# define HZ CONFIG_HZ
#else
# define HZ 100
#endif

A few arches though (namely alpha/h8300/um/v850/xtensa) either do no set
HZ at all for !__KERNEL__, or they set it wrongly.  This should bring all
arches in line by setting up HZ for userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/param.h  |    4 ++++
 include/asm-h8300/param.h  |    8 +++-----
 include/asm-um/param.h     |    2 ++
 include/asm-v850/param.h   |    2 ++
 include/asm-xtensa/param.h |    2 ++
 5 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/asm-alpha/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace include/asm-alpha/param.h
--- a/include/asm-alpha/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace
+++ a/include/asm-alpha/param.h
@@ -5,8 +5,12 @@
    hardware ignores reprogramming.  We also need userland buy-in to the 
    change in HZ, since this is visible in the wait4 resources etc.  */
 
+#ifdef __KERNEL__
 #define HZ		CONFIG_HZ
 #define USER_HZ		HZ
+#else
+#define HZ		100
+#endif
 
 #define EXEC_PAGESIZE	8192
 
diff -puN include/asm-h8300/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace include/asm-h8300/param.h
--- a/include/asm-h8300/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace
+++ a/include/asm-h8300/param.h
@@ -1,14 +1,12 @@
 #ifndef _H8300_PARAM_H
 #define _H8300_PARAM_H
 
-
-#ifndef HZ
-#define HZ CONFIG_HZ
-#endif
-
 #ifdef __KERNEL__
+#define HZ		CONFIG_HZ
 #define	USER_HZ		HZ
 #define	CLOCKS_PER_SEC	(USER_HZ)
+#else
+#define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096
diff -puN include/asm-um/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace include/asm-um/param.h
--- a/include/asm-um/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace
+++ a/include/asm-um/param.h
@@ -13,6 +13,8 @@
 #define HZ CONFIG_HZ
 #define USER_HZ	100	   /* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC (USER_HZ)  /* frequency at which times() counts */
+#else
+#define HZ 100
 #endif
 
 #endif
diff -puN include/asm-v850/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace include/asm-v850/param.h
--- a/include/asm-v850/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace
+++ a/include/asm-v850/param.h
@@ -26,6 +26,8 @@
 # define HZ		CONFIG_HZ
 # define USER_HZ	100
 # define CLOCKS_PER_SEC	USER_HZ
+#else
+# define HZ		100
 #endif
 
 #endif /* __V850_PARAM_H__ */
diff -puN include/asm-xtensa/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace include/asm-xtensa/param.h
--- a/include/asm-xtensa/param.h~asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace
+++ a/include/asm-xtensa/param.h
@@ -15,6 +15,8 @@
 # define HZ		CONFIG_HZ	/* internal timer frequency */
 # define USER_HZ	100		/* for user interfaces in "ticks" */
 # define CLOCKS_PER_SEC (USER_HZ)	/* frequnzy at which times() counts */
+#else
+# define HZ		100
 #endif
 
 #define EXEC_PAGESIZE	4096
_

Patches currently in -mm which might be from vapier@gentoo.org are

asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch

