From: akpm@linux-foundation.org
Subject: - x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486-fix.patch removed from -mm tree
Date: Tue, 12 Feb 2008 15:06:57 -0800
Message-ID: <200802122306.m1CN6vB2027479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbYBLXHz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:07:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, mingo@elte.hu, penberg@cs.helsinki.fi, tglx@linutronix.de, vegard.nossum@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Cast cmpxchg64 and cmpxchg64_local result for 386 and 486 - Fix missing parenthesis
has been removed from the -mm tree.  Its filename was
     x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486-fix.patch

This patch was dropped because it was folded into x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Cast cmpxchg64 and cmpxchg64_local result for 386 and 486 - Fix missing parenthesis
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Two pairs of parenthesis were missing around the result cast of cmpxchg64 and
cmpxchg64_local. This is a rather stupid mistake in
"Cast cmpxchg and cmpxchg_local result for 386 and 486". My bad. This fix
should be folded with the previous.

Sorry for this trivial bug which should have never appeared in the first place.
The aim was to fix cmpxchg and cmpxchg_local, which were used in slub. cmpxchg64
and cmpxchg64_local happen to be only used in LTTng currently.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/cmpxchg_32.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-x86/cmpxchg_32.h~x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486-fix include/asm-x86/cmpxchg_32.h
--- a/include/asm-x86/cmpxchg_32.h~x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486-fix
+++ a/include/asm-x86/cmpxchg_32.h
@@ -305,11 +305,11 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __typeof__(*(ptr))__cmpxchg64((ptr),		\
+		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
@@ -318,11 +318,11 @@ extern unsigned long long cmpxchg_486_u6
 ({									\
 	__typeof__(*(ptr)) __ret;					\
 	if (likely(boot_cpu_data.x86 > 4))				\
-		__ret = __typeof__(*(ptr))__cmpxchg64_local((ptr),	\
+		__ret = (__typeof__(*(ptr)))__cmpxchg64_local((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	else								\
-		__ret = __typeof__(*(ptr))cmpxchg_486_u64((ptr),	\
+		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
 				(unsigned long long)(o),		\
 				(unsigned long long)(n));		\
 	__ret;								\
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
fix-frv-cmpxchg_local.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-create-modpost-file.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486-fix.patch
