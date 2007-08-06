From: akpm@linux-foundation.org
Subject: - fix-warn_on-on-bitfield-ops-for-all-other-archs.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:52:44 -0700
Message-ID: <200708060752.l767qifU016260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757723AbXHFHym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, adobriyan@sw.ru, herbert@gondor.apana.org.au, hskinnemoen@atmel.com, kyle@parisc-linux.org, lethal@linux-sh.org, matthew@wil.cx, schwidefsky@de.ibm.com, mm-


The patch titled
     Fix WARN_ON() on bitfield ops for all other archs
has been removed from the -mm tree.  Its filename was
     fix-warn_on-on-bitfield-ops-for-all-other-archs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix WARN_ON() on bitfield ops for all other archs
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes WARN_ON() on bitfield ops for all architectures that have been left
out in 8d4fbcfbe0a4bfc73e7f0297c59ae514e1f1436f.

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/bug.h  |    2 +-
 include/asm-parisc/bug.h |    2 +-
 include/asm-s390/bug.h   |    2 +-
 include/asm-sh/bug.h     |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-avr32/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs include/asm-avr32/bug.h
--- a/include/asm-avr32/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs
+++ a/include/asm-avr32/bug.h
@@ -57,7 +57,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		typeof(condition) __ret_warn_on = (condition);		\
+		int __ret_warn_on = !!(condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
diff -puN include/asm-parisc/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs include/asm-parisc/bug.h
--- a/include/asm-parisc/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs
+++ a/include/asm-parisc/bug.h
@@ -74,7 +74,7 @@
 
 
 #define WARN_ON(x) ({						\
-	typeof(x) __ret_warn_on = (x);				\
+	int __ret_warn_on = !!(x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
diff -puN include/asm-s390/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs include/asm-s390/bug.h
--- a/include/asm-s390/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs
+++ a/include/asm-s390/bug.h
@@ -50,7 +50,7 @@
 #define BUG()	__EMIT_BUG(0)
 
 #define WARN_ON(x) ({					\
-	typeof(x) __ret_warn_on = (x);			\
+	int __ret_warn_on = !!(x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
 			__EMIT_BUG(BUGFLAG_WARNING);	\
diff -puN include/asm-sh/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs include/asm-sh/bug.h
--- a/include/asm-sh/bug.h~fix-warn_on-on-bitfield-ops-for-all-other-archs
+++ a/include/asm-sh/bug.h
@@ -61,7 +61,7 @@ do {							\
 } while (0)
 
 #define WARN_ON(x) ({						\
-	typeof(x) __ret_warn_on = (x);				\
+	int __ret_warn_on = !!(x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

slow-down-printk-during-boot-fix-4.patch
git-wireless.patch
avoid-ssb-compililation-on-s390.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
