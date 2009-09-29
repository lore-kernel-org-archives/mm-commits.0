From: akpm@linux-foundation.org
Subject: + warn_once-use-bool-for-condition.patch added to -mm tree
Date: Tue, 29 Sep 2009 13:59:52 -0700
Message-ID: <200909292059.n8TKxqtm016956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbZI2VAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, dwalker@fifo99.com, rolandd@cisco.com


The patch titled
     WARN_ONCE(): use bool for condition
has been added to the -mm tree.  Its filename is
     warn_once-use-bool-for-condition.patch

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
Subject: WARN_ONCE(): use bool for condition
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Use the type bool for __ret_warn_once and __ret_warn_on, instead of int
with a double negation.  This matches the intent of the code better and
should allow the compiler to generate better code, like in commit
70867453092297be9afb2249e712a1f960ec0a09.  However, some versions of gcc
seems to pessimize the code instead when the condition is not trivial.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/bug.h    |    2 +-
 arch/blackfin/include/asm/bug.h |    2 +-
 arch/parisc/include/asm/bug.h   |    2 +-
 arch/powerpc/include/asm/bug.h  |    2 +-
 arch/s390/include/asm/bug.h     |    2 +-
 arch/sh/include/asm/bug.h       |    4 ++--
 include/asm-generic/bug.h       |   12 ++++++------
 7 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/avr32/include/asm/bug.h~warn_once-use-bool-for-condition arch/avr32/include/asm/bug.h
--- a/arch/avr32/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/avr32/include/asm/bug.h
@@ -57,7 +57,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		int __ret_warn_on = !!(condition);			\
+		bool __ret_warn_on = (condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
diff -puN arch/blackfin/include/asm/bug.h~warn_once-use-bool-for-condition arch/blackfin/include/asm/bug.h
--- a/arch/blackfin/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/blackfin/include/asm/bug.h
@@ -46,7 +46,7 @@
 
 #define WARN_ON(condition)							\
 	({								\
-		int __ret_warn_on = !!(condition);			\
+		bool __ret_warn_on = (condition);			\
 		if (unlikely(__ret_warn_on))				\
 			_BUG_OR_WARN(BUGFLAG_WARNING);			\
 		unlikely(__ret_warn_on);				\
diff -puN arch/parisc/include/asm/bug.h~warn_once-use-bool-for-condition arch/parisc/include/asm/bug.h
--- a/arch/parisc/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/parisc/include/asm/bug.h
@@ -74,7 +74,7 @@
 
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
diff -puN arch/powerpc/include/asm/bug.h~warn_once-use-bool-for-condition arch/powerpc/include/asm/bug.h
--- a/arch/powerpc/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/powerpc/include/asm/bug.h
@@ -95,7 +95,7 @@
 } while (0)
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
diff -puN arch/s390/include/asm/bug.h~warn_once-use-bool-for-condition arch/s390/include/asm/bug.h
--- a/arch/s390/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/s390/include/asm/bug.h
@@ -53,7 +53,7 @@
 } while (0)
 
 #define WARN_ON(x) ({					\
-	int __ret_warn_on = !!(x);			\
+	bool __ret_warn_on = (x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
 			__EMIT_BUG(BUGFLAG_WARNING);	\
diff -puN arch/sh/include/asm/bug.h~warn_once-use-bool-for-condition arch/sh/include/asm/bug.h
--- a/arch/sh/include/asm/bug.h~warn_once-use-bool-for-condition
+++ a/arch/sh/include/asm/bug.h
@@ -62,7 +62,7 @@ do {							\
 } while (0)
 
 #define WARN_ON(x) ({						\
-	int __ret_warn_on = !!(x);				\
+	bool __ret_warn_on = (x);				\
 	if (__builtin_constant_p(__ret_warn_on)) {		\
 		if (__ret_warn_on)				\
 			__WARN();				\
@@ -87,7 +87,7 @@ do {							\
 } while (0)
 
 #define UNWINDER_BUG_ON(x) ({					\
-	int __ret_unwinder_on = !!(x);				\
+	bool __ret_unwinder_on = (x);				\
 	if (__builtin_constant_p(__ret_unwinder_on)) {		\
 		if (__ret_unwinder_on)				\
 			UNWINDER_BUG();				\
diff -puN include/asm-generic/bug.h~warn_once-use-bool-for-condition include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~warn_once-use-bool-for-condition
+++ a/include/asm-generic/bug.h
@@ -71,7 +71,7 @@ extern void warn_slowpath_null(const cha
 
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	if (unlikely(__ret_warn_on))					\
 		__WARN();						\
 	unlikely(__ret_warn_on);					\
@@ -80,7 +80,7 @@ extern void warn_slowpath_null(const cha
 
 #ifndef WARN
 #define WARN(condition, format...) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	if (unlikely(__ret_warn_on))					\
 		__WARN_printf(format);					\
 	unlikely(__ret_warn_on);					\
@@ -98,14 +98,14 @@ extern void warn_slowpath_null(const cha
 
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	unlikely(__ret_warn_on);					\
 })
 #endif
 
 #ifndef WARN
 #define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
+	bool __ret_warn_on = (condition);				\
 	unlikely(__ret_warn_on);					\
 })
 #endif
@@ -114,7 +114,7 @@ extern void warn_slowpath_null(const cha
 
 #define WARN_ON_ONCE(condition)	({				\
 	static int __warned;					\
-	int __ret_warn_once = !!(condition);			\
+	bool __ret_warn_once = (condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN_ON(!__warned)) 			\
@@ -124,7 +124,7 @@ extern void warn_slowpath_null(const cha
 
 #define WARN_ONCE(condition, format...)	({			\
 	static int __warned;					\
-	int __ret_warn_once = !!(condition);			\
+	bool __ret_warn_once = (condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
 		if (WARN(!__warned, format)) 			\
_

Patches currently in -mm which might be from cesarb@cesarb.net are

warn_once-use-bool-for-condition.patch

