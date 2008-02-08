From: akpm@linux-foundation.org
Subject: - add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:56 -0800
Message-ID: <200802080808.m1888bSh014665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46902 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268AbYBHIUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, clameter@sgi.com, kaos@ocs.com.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
has been removed from the -mm tree.  Its filename was
     add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Add the primitives cmpxchg_local, cmpxchg64 and cmpxchg64_local to ia64. They
use cmpxchg_acq as underlying macro, just like the already existing ia64
cmpxchg().

Changelog:

ia64 cmpxchg_local coding style fix
Quoting Keith Owens:

As a matter of coding style, I prefer

#define cmpxchg_local   cmpxchg
#define cmpxchg64_local cmpxchg64

Which makes it absolutely clear that they are the same code.  With your
patch, humans have to do a string compare of two defines to see if they
are the same.

Note cmpxchg is *not* a performance win vs interrupt disable / enable on IA64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Keith Owens <kaos@ocs.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/intrinsics.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/asm-ia64/intrinsics.h~add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64 include/asm-ia64/intrinsics.h
--- a/include/asm-ia64/intrinsics.h~add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64
+++ a/include/asm-ia64/intrinsics.h
@@ -153,11 +153,17 @@ extern long ia64_cmpxchg_called_with_bad
 	(__typeof__(old)) _r_;								\
 })
 
-#define cmpxchg_acq(ptr,o,n)	ia64_cmpxchg(acq, (ptr), (o), (n), sizeof(*(ptr)))
-#define cmpxchg_rel(ptr,o,n)	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
+#define cmpxchg_acq(ptr, o, n)	\
+	ia64_cmpxchg(acq, (ptr), (o), (n), sizeof(*(ptr)))
+#define cmpxchg_rel(ptr, o, n)	\
+	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
 /* for compatibility with other platforms: */
-#define cmpxchg(ptr,o,n)	cmpxchg_acq(ptr,o,n)
+#define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
+#define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
+
+#define cmpxchg_local		cmpxchg
+#define cmpxchg64_local		cmpxchg64
 
 #ifdef CONFIG_IA64_DEBUG_CMPXCHG
 # define CMPXCHG_BUGCHECK_DECL	int _cmpxchg_bugcheck_count = 128;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
linux-kernel-markers-support-multiple-probes.patch
linux-kernel-markers-support-multiple-probes-update.patch
linux-kernel-markers-create-modpost-file.patch
