From: akpm@google.com
Subject: + treewide-use-__printf-not-__attribute__formatprintf-fix.patch added to -mm tree
Date: Wed, 28 Sep 2011 15:03:48 -0700
Message-ID: <201109282203.p8SM3mXR027301@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1I1WEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2011 18:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, joe@perches.com, sfr@canb.auug.org.au


The patch titled
     Subject: treewide-use-__printf-not-__attribute__formatprintf-fix
has been added to the -mm tree.  Its filename is
     treewide-use-__printf-not-__attribute__formatprintf-fix.patch

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
From: Andrew Morton <akpm@google.com>
Subject: treewide-use-__printf-not-__attribute__formatprintf-fix

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/boot/stdio.c:12:0:
arch/powerpc/boot/stdio.h:10:17: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:10:20: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:10:8: warning: return type defaults to 'int'
arch/powerpc/boot/stdio.h:10:8: warning: function declaration isn't a prototype
arch/powerpc/boot/stdio.h: In function '__printf':
arch/powerpc/boot/stdio.h:14:17: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:14:20: error: expected declaration specifiers or '...' before numeric constant
arch/powerpc/boot/stdio.h:14:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'int'
arch/powerpc/boot/stdio.h:16:12: error: storage class specified for parameter 'vsprintf'
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/powerpc/boot/ps3.c   |    3 ++-
 arch/powerpc/boot/stdio.h |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/boot/ps3.c~treewide-use-__printf-not-__attribute__formatprintf-fix arch/powerpc/boot/ps3.c
--- a/arch/powerpc/boot/ps3.c~treewide-use-__printf-not-__attribute__formatprintf-fix
+++ a/arch/powerpc/boot/ps3.c
@@ -36,7 +36,8 @@ extern int lv1_get_repository_node_value
 #ifdef DEBUG
 #define DBG(fmt...) printf(fmt)
 #else
-static inline __printf(1, 2) int DBG(const char *fmt, ...) {return 0;}
+static inline int __attribute__ ((format (printf, 1, 2))) DBG(
+	const char *fmt, ...) {return 0;}
 #endif
 
 BSS_STACK(4096);
diff -puN arch/powerpc/boot/stdio.h~treewide-use-__printf-not-__attribute__formatprintf-fix arch/powerpc/boot/stdio.h
--- a/arch/powerpc/boot/stdio.h~treewide-use-__printf-not-__attribute__formatprintf-fix
+++ a/arch/powerpc/boot/stdio.h
@@ -7,11 +7,12 @@
 #define	EINVAL		22	/* Invalid argument */
 #define ENOSPC		28	/* No space left on device */
 
-extern __printf(1, 2) int printf(const char *fmt, ...);
+extern int printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 
 #define fprintf(fmt, args...)	printf(args)
 
-extern __printf(2, 3) int sprintf(char *buf, const char *fmt, ...);
+extern int sprintf(char *buf, const char *fmt, ...)
+	__attribute__((format(printf, 2, 3)));
 
 extern int vsprintf(char *buf, const char *fmt, va_list args);
 
_
Subject: Subject: treewide-use-__printf-not-__attribute__formatprintf-fix

Patches currently in -mm which might be from akpm@google.com are

linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch

