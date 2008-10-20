From: akpm@linux-foundation.org
Subject: - remove-the-obsolete-bcdbin-binbcd-macros.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:38:00 -0700
Message-ID: <200810202038.m9KKc0Mp011758@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbYJTUp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     remove the obsolete BCD*BIN/BIN*BCD macros
has been removed from the -mm tree.  Its filename was
     remove-the-obsolete-bcdbin-binbcd-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove the obsolete BCD*BIN/BIN*BCD macros
From: Adrian Bunk <bunk@kernel.org>

Remove the following obsolete macros:

- BCD2BIN
- BIN2BCD
- BCD_TO_BIN
- BIN_TO_BCD

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bcd.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/bcd.h~remove-the-obsolete-bcdbin-binbcd-macros include/linux/bcd.h
--- a/include/linux/bcd.h~remove-the-obsolete-bcdbin-binbcd-macros
+++ a/include/linux/bcd.h
@@ -15,11 +15,4 @@
 unsigned bcd2bin(unsigned char val) __attribute_const__;
 unsigned char bin2bcd(unsigned val) __attribute_const__;
 
-#define BCD2BIN(val)	bcd2bin(val)
-#define BIN2BCD(val)	bin2bcd(val)
-
-/* backwards compat */
-#define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
-#define BIN_TO_BCD(val) ((val)=BIN2BCD(val))
