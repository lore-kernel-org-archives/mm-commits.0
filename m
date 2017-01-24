From: akpm@linux-foundation.org
Subject: + compiler-gcch-added-new-macro-for-gcc-attribute.patch added to
 -mm tree
Date: Tue, 24 Jan 2017 13:49:02 -0800
Message-ID: <5887cbce.27X+fcXKGjFZMeq7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbdAXVtD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jan 2017 16:49:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gidisrael@gmail.com, geert@linux-m68k.org, gerg@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: add new macro for gcc attribute
has been added to the -mm tree.  Its filename is
     compiler-gcch-added-new-macro-for-gcc-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compiler-gcch-added-new-macro-for-gcc-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compiler-gcch-added-new-macro-for-gcc-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: compiler-gcc.h: add new macro for gcc attribute

Add __mode(x) into compiler-gcc.h.  The next patch cleans up the m68k
subsystem and it requires a new macro to wrap __attribute__ ((mode (...)))

Link: http://lkml.kernel.org/r/1485260068-2495-1-git-send-email-gidisrael@gmail.com
Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-added-new-macro-for-gcc-attribute include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-added-new-macro-for-gcc-attribute
+++ a/include/linux/compiler-gcc.h
@@ -121,6 +121,7 @@
 #define __attribute_const__	__attribute__((__const__))
 #define __maybe_unused		__attribute__((unused))
 #define __always_unused		__attribute__((unused))
+#define __mode                  __attribute__((mode(x)))
 
 /* gcc version specific checks */
 
_

Patches currently in -mm which might be from gidisrael@gmail.com are

compiler-gcch-added-new-macro-for-gcc-attribute.patch
m68k-replaced-gcc-specific-macros-with-ones-from-compilerh.patch

