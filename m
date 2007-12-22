From: akpm@linux-foundation.org
Subject: + cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch added to -mm tree
Date: Sat, 22 Dec 2007 00:29:16 -0800
Message-ID: <200712220829.lBM8TG0r024671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXLVI3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 03:29:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com


The patch titled
     cris: remove unused __dummy, CONST_ADDR and ADDR from bitops.h
has been added to the -mm tree.  Its filename is
     cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: remove unused __dummy, CONST_ADDR and ADDR from bitops.h
From: Jesper Nilsson <jesper.nilsson@axis.com>

This is very old code, it hasn't changed since 2001 and it is not used
anywhere.  Noticed by Clemens Koller.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-cris/bitops.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/asm-cris/bitops.h~cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh include/asm-cris/bitops.h
--- a/include/asm-cris/bitops.h~cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh
+++ a/include/asm-cris/bitops.h
@@ -24,13 +24,6 @@
 #include <linux/compiler.h>
 
 /*
- * Some hacks to defeat gcc over-optimizations..
- */
-struct __dummy { unsigned long a[100]; };
-#define ADDR (*(struct __dummy *) addr)
-#define CONST_ADDR (*(const struct __dummy *) addr)
-
-/*
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
  * @addr: the address to start counting from
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

git-mtd.patch
cris-avoid-using-arch-links-in-kconfig.patch
arch-cris-arch-v10-vmlinuxldss-fix-boot-problem.patch
cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch
