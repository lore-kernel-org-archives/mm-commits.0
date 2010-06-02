From: akpm@linux-foundation.org
Subject: + include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:13:18 -0700
Message-ID: <201006022113.o52LDImZ017237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932894Ab0FBVNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:13:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org


The patch titled
     include/linux/compiler-gcc.h: use __same_type() in __must_be_array()
has been added to the -mm tree.  Its filename is
     include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch

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
Subject: include/linux/compiler-gcc.h: use __same_type() in __must_be_array()
From: Rusty Russell <rusty@rustcorp.com.au>

We should use the __same_type() helper in __must_be_array().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/compiler-gcc.h~include-linux-compiler-gcch-use-__same_type-in-__must_be_array include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-linux-compiler-gcch-use-__same_type-in-__must_be_array
+++ a/include/linux/compiler-gcc.h
@@ -35,8 +35,7 @@
     (typeof(ptr)) (__ptr + (off)); })
 
 /* &a[0] degrades to a pointer: a different type from an array */
-#define __must_be_array(a) \
-  BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
+#define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
 /*
  * Force always-inline if the user requests it so via the .config,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
linux-next.patch
modpost-support-objects-with-more-than-64k-sections.patch
kmap_atomic-make-kunmap_atomic-harder-to-misuse.patch
include-linux-compiler-gcch-use-__same_type-in-__must_be_array.patch
reiser4.patch

