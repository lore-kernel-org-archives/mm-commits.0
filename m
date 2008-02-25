From: akpm@linux-foundation.org
Subject: - make-lkdtm-depend-on-block.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:16 -0800
Message-ID: <200802250044.m1P0iGs2006095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYBYApC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:45:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csnook@redhat.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     make LKDTM depend on BLOCK
has been removed from the -mm tree.  Its filename was
     make-lkdtm-depend-on-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make LKDTM depend on BLOCK
From: Chris Snook <csnook@redhat.com>

Make LKDTM depend on BLOCK to prevent build failures with certain configs.

Signed-off-by: Chris Snook <csnook@redhat.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~make-lkdtm-depend-on-block lib/Kconfig.debug
--- a/lib/Kconfig.debug~make-lkdtm-depend-on-block
+++ a/lib/Kconfig.debug
@@ -527,6 +527,7 @@ config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	depends on BLOCK
 	default n
 	help
 	This module enables testing of the different dumping mechanisms by
_

Patches currently in -mm which might be from csnook@redhat.com are
