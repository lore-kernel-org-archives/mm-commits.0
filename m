From: akpm@linux-foundation.org
Subject: + lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:02:33 -0700
Message-ID: <200908042302.n74N2YBA019259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933387AbZHDXEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: albin.tonnerre@free-electrons.com, eduard.munteanu@linux360.ro, hpa@zytor.com, mingo@elte.hu, penberg@cs.helsinki.fi, phillip@lougher.demon.co.uk, rmk@arm.linux.org.uk, sam@ravnborg.org, tglx@linutronix.de


The patch titled
     lib/decompress_*: only include <linux/slab.h> if STATIC is not defined
has been added to the -mm tree.  Its filename is
     lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch

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
Subject: lib/decompress_*: only include <linux/slab.h> if STATIC is not defined
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>

These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef
("kmemtrace, kbuild: fix slab.h dependency problem in
lib/decompress_inflate.c") to fix the build when using kmemtrace.  However
this is not necessary when used to create a compressed kernel, and
actually creates issues (brings a lot of things unavailable in the
decompression environment), so don't include it if STATIC is defined.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    2 +-
 lib/decompress_inflate.c |    2 +-
 lib/decompress_unlzma.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/decompress_bunzip2.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_bunzip2.c
--- a/lib/decompress_bunzip2.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_bunzip2.c
@@ -47,10 +47,10 @@
 
 #ifndef STATIC
 #include <linux/decompress/bunzip2.h>
+#include <linux/slab.h>
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff -puN lib/decompress_inflate.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_inflate.c
--- a/lib/decompress_inflate.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_inflate.c
@@ -19,11 +19,11 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
+#include <linux/slab.h>
 
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define GZIP_IOBUF_SIZE (16*1024)
 
diff -puN lib/decompress_unlzma.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined lib/decompress_unlzma.c
--- a/lib/decompress_unlzma.c~lib-decompress_-only-include-linux-slabh-if-static-is-not-defined
+++ a/lib/decompress_unlzma.c
@@ -31,10 +31,10 @@
 
 #ifndef STATIC
 #include <linux/decompress/unlzma.h>
+#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
_

Patches currently in -mm which might be from albin.tonnerre@free-electrons.com are

lib-decompress_-only-include-linux-slabh-if-static-is-not-defined.patch
include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
lzo-add-support-for-lzo-compressed-kernels.patch
lzo-arm-add-support-for-lzo-compressed-kernels.patch
lzo-x86-add-support-for-lzo-compressed-kernels.patch
lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch

