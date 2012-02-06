From: akpm@linux-foundation.org
Subject: [merged] xtensa-fix-memscan.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:17 -0800
Message-ID: <20120206203117.5A147A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33821 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2BFUbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:18 -0500
Received: by mail-gx0-f202.google.com with SMTP id p1so612070ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: fix memscan()
has been removed from the -mm tree.  Its filename was
     xtensa-fix-memscan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: xtensa: fix memscan()

Defining memscan() as memchr() is wrong, because the return values of
memscan() and memchr() are different when the character is not found.  So
use the generic memscan() implementation to fix this.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/include/asm/string.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/xtensa/include/asm/string.h~xtensa-fix-memscan arch/xtensa/include/asm/string.h
--- a/arch/xtensa/include/asm/string.h~xtensa-fix-memscan
+++ a/arch/xtensa/include/asm/string.h
@@ -118,7 +118,4 @@ extern void *memmove(void *__dest, __con
 /* Don't build bcopy at all ...  */
 #define __HAVE_ARCH_BCOPY
 
-#define __HAVE_ARCH_MEMSCAN
-#define memscan memchr
