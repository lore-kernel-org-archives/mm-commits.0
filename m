From: akpm@linux-foundation.org
Subject: [merged] compilerh-add-support-for-malloc-attribute.patch removed from -mm tree
Date: Fri, 20 May 2016 14:03:55 -0700
Message-ID: <573f7bbb.0cT/i/7dhCd8475q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbcETVD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, ak@linux.intel.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler.h: add support for malloc attribute
has been removed from the -mm tree.  Its filename was
     compilerh-add-support-for-malloc-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: compiler.h: add support for malloc attribute

gcc as far back as at least 3.04 documents the function attribute
__malloc__.  Add a shorthand for attaching that to a function declaration.
This was also suggested by Andi Kleen way back in 2002 [1], but didn't
get applied, perhaps because gcc at that time generated the exact same
code with and without this attribute.

This attribute tells the compiler that the return value (if non-NULL) can
be assumed not to alias any other valid pointers at the time of the call.

Please note that the documentation for a range of gcc versions (starting
from around 4.7) contained a somewhat confusing and self-contradicting
text:

  The malloc attribute is used to tell the compiler that a function may
  be treated as if any non-NULL pointer it returns cannot alias any other
  pointer valid when the function returns and *that the memory has
  undefined content*.  [...] Standard functions with this property include
  malloc and *calloc*.

(emphasis mine). The intended meaning has later been clarified [2]:

  This tells the compiler that a function is malloc-like, i.e., that the
  pointer P returned by the function cannot alias any other pointer valid
  when the function returns, and moreover no pointers to valid objects
  occur in any storage addressed by P.

What this means is that we can apply the attribute to kmalloc and friends,
and it is ok for the returned memory to have well-defined contents
(__GFP_ZERO).  But it is not ok to apply it to kmemdup(), nor to other
functions which both allocate and possibly initialize the memory with
existing pointers.  So unless someone is doing something pretty perverted
kstrdup() should also be a fine candidate.

[1] http://thread.gmane.org/gmane.linux.kernel/57172
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56955

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    1 +
 include/linux/compiler.h     |    4 ++++
 2 files changed, 5 insertions(+)

diff -puN include/linux/compiler-gcc.h~compilerh-add-support-for-malloc-attribute include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compilerh-add-support-for-malloc-attribute
+++ a/include/linux/compiler-gcc.h
@@ -142,6 +142,7 @@
 
 #if GCC_VERSION >= 30400
 #define __must_check		__attribute__((warn_unused_result))
+#define __malloc		__attribute__((__malloc__))
 #endif
 
 #if GCC_VERSION >= 40000
diff -puN include/linux/compiler.h~compilerh-add-support-for-malloc-attribute include/linux/compiler.h
--- a/include/linux/compiler.h~compilerh-add-support-for-malloc-attribute
+++ a/include/linux/compiler.h
@@ -357,6 +357,10 @@ static __always_inline void __write_once
 #define __deprecated_for_modules
 #endif
 
+#ifndef __malloc
+#define __malloc
+#endif
+
 /*
  * Allow us to avoid 'defined but not used' warnings on functions and data,
  * as well as force them to be emitted to the assembly file.
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

init-mainc-simplify-initcall_blacklisted.patch

