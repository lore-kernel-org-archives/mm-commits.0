From: akpm@linux-foundation.org
Subject: [merged]
 stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:47:09 -0700
Message-ID: <5591aecd.Q5gSgn9zY6cMWwp6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbbF2UrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dvlasenk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: stddef.h: move offsetofend inside #ifndef/#endif guard, neaten
has been removed from the -mm tree.  Its filename was
     stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: stddef.h: move offsetofend inside #ifndef/#endif guard, neaten

commit 3876488444e7 ("include/stddef.h: Move offsetofend() from vfio.h to
a generic kernel header") added offsetofend outside the normal include
#ifndef/#endif guard.  Move it inside.

Miscellanea:

o remove unnecessary blank line
o standardize offsetof macros whitespace style

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stddef.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/stddef.h~stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten include/linux/stddef.h
--- a/include/linux/stddef.h~stddefh-move-offsetofend-inside-ifndef-endif-guard-neaten
+++ a/include/linux/stddef.h
@@ -3,7 +3,6 @@
 
 #include <uapi/linux/stddef.h>
 
-
 #undef NULL
 #define NULL ((void *)0)
 
@@ -14,10 +13,9 @@ enum {
 
 #undef offsetof
 #ifdef __compiler_offsetof
-#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
+#define offsetof(TYPE, MEMBER)	__compiler_offsetof(TYPE, MEMBER)
 #else
-#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
-#endif
+#define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)
 #endif
 
 /**
@@ -28,3 +26,5 @@ enum {
  */
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof(((TYPE *)0)->MEMBER))
+
+#endif
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

