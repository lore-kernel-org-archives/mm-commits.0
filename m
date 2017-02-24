From: akpm@linux-foundation.org
Subject: [patch 100/124] compiler-gcc.h: add a new macro to wrap gcc
 attribute
Date: Fri, 24 Feb 2017 15:00:32 -0800
Message-ID: <58b0bb10.169r6HWUZ5eH7HQ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdBXXAd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, gidisrael@gmail.com, geert@linux-m68k.org, gerg@linux-m68k.org, paul.gortmaker@windriver.com

From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: compiler-gcc.h: add a new macro to wrap gcc attribute

Add __mode(x) into compiler-gcc.h as part of a cleanup task I've taken up,
to replace gcc specific attributes with macros.

The next patch is a cleanup of the m68k subsystem and it requires a new
macro to wrap __attribute__ ((mode (...)))

Link: http://lkml.kernel.org/r/1485540901-1988-2-git-send-email-gidisrael@gmail.com
Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-added-a-new-macro-to-wrap-gcc-attribute include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-added-a-new-macro-to-wrap-gcc-attribute
+++ a/include/linux/compiler-gcc.h
@@ -122,6 +122,7 @@
 #define __attribute_const__	__attribute__((__const__))
 #define __maybe_unused		__attribute__((unused))
 #define __always_unused		__attribute__((unused))
+#define __mode(x)               __attribute__((mode(x)))
 
 /* gcc version specific checks */
 
_
