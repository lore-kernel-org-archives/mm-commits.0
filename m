From: akpm@linux-foundation.org
Subject: - cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:12 -0800
Message-ID: <200802052234.m15MYrO6012563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762259AbYBEWlD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: remove unused __dummy, CONST_ADDR and ADDR from bitops.h
has been removed from the -mm tree.  Its filename was
     cris-remove-unused-__dummy-const_addr-and-addr-from-bitopsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-mtd.patch
procfs-constify-function-pointer-tables.patch
