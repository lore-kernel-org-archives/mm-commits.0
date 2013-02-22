From: akpm@linux-foundation.org
Subject: [merged] compiler-gcch-add-gcc-recommended-gcc_version-macro.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:07 -0800
Message-ID: <20130222203708.56D6C31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34642 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3BVUhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:09 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so103538vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, ak@linux.intel.com, bp@alien8.de, joe@perches.com, josh@joshtriplett.org, paul.gortmaker@windriver.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: compiler-gcc.h: Add gcc-recommended GCC_VERSION macro
has been removed from the -mm tree.  Its filename was
     compiler-gcch-add-gcc-recommended-gcc_version-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: compiler-gcc.h: Add gcc-recommended GCC_VERSION macro

Throughout compiler*.h, many version checks are made.  These can be
simplified by using the macro that gcc's documentation recommends. 
However, my primary reason for adding this is that I need bug-check macros
that are enabled at certain gcc versions and it's cleaner to use this
macro than the tradition method:

if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ => 2)

If you add patch level, it gets this ugly:

if __GNUC__ > 4 || (__GNUC__ == 4 && (__GNUC_MINOR__ > 2 || \
   __GNUC_MINOR__ == 2 __GNUC_PATCHLEVEL__ >= 1))

As opposed to:

if GCC_VERSION >= 40201

While having separate headers for gcc 3 & 4 eliminates some of this
verbosity, they can still be cleaned up by this.

See also:
http://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/compiler-gcc.h~compiler-gcch-add-gcc-recommended-gcc_version-macro include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~compiler-gcch-add-gcc-recommended-gcc_version-macro
+++ a/include/linux/compiler-gcc.h
@@ -5,6 +5,9 @@
 /*
  * Common definitions for all gcc versions go here.
  */
+#define GCC_VERSION (__GNUC__ * 10000 \
+		   + __GNUC_MINOR__ * 100 \
+		   + __GNUC_PATCHLEVEL__)
 
 
 /* Optimization barrier */
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch

