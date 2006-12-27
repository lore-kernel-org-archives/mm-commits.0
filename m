From: akpm@osdl.org
Subject: + fix-mrproper-incompleteness.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:55:43 -0800
Message-ID: <200612270755.kBR7thHc004895@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37854 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932985AbWL0Hzx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikpe@it.uu.se


The patch titled
     fix mrproper incompleteness
has been added to the -mm tree.  Its filename is
     fix-mrproper-incompleteness.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix mrproper incompleteness
From: Mikael Pettersson <mikpe@it.uu.se>

include/linux/utsrelease.h and include/linux/version.h aren't removed any
more by mrproper in kernel 2.6.20-rc2.  The patch below fixes this.

The definition of MRPROPER_FILES looks weird: generated-headers looks like
a misspelling of generated_headers, but that one is a Makefile target, not
a variable or a file, so I don't see how including it in MRPROPER_FILES
could have any effect.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~fix-mrproper-incompleteness Makefile
--- a/Makefile~fix-mrproper-incompleteness
+++ a/Makefile
@@ -1040,7 +1040,7 @@ CLEAN_FILES +=	vmlinux System.map \
 # Directories & files removed with 'make mrproper'
 MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
-                  include/linux/autoconf.h generated-headers		\
+                  include/linux/autoconf.h include/linux/utsrelease.h include/linux/version.h \
 		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
_

Patches currently in -mm which might be from mikpe@it.uu.se are

fix-mrproper-incompleteness.patch
git-libata-all.patch

