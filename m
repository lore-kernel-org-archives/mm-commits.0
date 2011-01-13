From: akpm@linux-foundation.org
Subject: [merged] toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:57 -0800
Message-ID: <201101132006.p0DK6caB029763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933405Ab1AMUHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: virtuoso@slind.org, jonathan@buzzard.org.uk, mm-commits@vger.kernel.org


The patch titled
     toshiba.h: hide a function prototypes behind __KERNEL__ macro
has been removed from the -mm tree.  Its filename was
     toshibah-hide-a-function-prototypes-behind-__kernel__-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: toshiba.h: hide a function prototypes behind __KERNEL__ macro
From: Alexander Shishkin <virtuoso@slind.org>

Currently, tosh_smm() prototype is present in a header file exported to
userland.  This patch fixes it.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Jonathan Buzzard <jonathan@buzzard.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/toshiba.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/toshiba.h~toshibah-hide-a-function-prototypes-behind-__kernel__-macro include/linux/toshiba.h
--- a/include/linux/toshiba.h~toshibah-hide-a-function-prototypes-behind-__kernel__-macro
+++ a/include/linux/toshiba.h
@@ -33,6 +33,8 @@ typedef struct {
 	unsigned int edi __attribute__ ((packed));
 } SMMRegisters;
 
+#ifdef __KERNEL__
 int tosh_smm(SMMRegisters *regs);
+#endif /* __KERNEL__ */
 
 #endif
_

Patches currently in -mm which might be from virtuoso@slind.org are

origin.patch
scsi-fix-a-header-to-include-linux-typesh.patch

