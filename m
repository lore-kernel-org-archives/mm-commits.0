From: akpm@linux-foundation.org
Subject: - sparc-build-fixes.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:16:16 -0800
Message-ID: <200802132016.m1DKGGq9011443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37924 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbYBMUX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:23:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: reif@earthlink.net, bunk@stusta.de, davem@davemloft.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     sparc build fixes
has been removed from the -mm tree.  Its filename was
     sparc-build-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc build fixes
From: Robert Reif <reif@earthlink.net>

Apparently these drivers now need uaccess.h

Signed-off-by: Robert Reif <reif@earthlink.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cg14.c    |    1 +
 drivers/video/sbuslib.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/video/cg14.c~sparc-build-fixes drivers/video/cg14.c
--- a/drivers/video/cg14.c~sparc-build-fixes
+++ a/drivers/video/cg14.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/fb.h>
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
diff -puN drivers/video/sbuslib.c~sparc-build-fixes drivers/video/sbuslib.c
--- a/drivers/video/sbuslib.c~sparc-build-fixes
+++ a/drivers/video/sbuslib.c
@@ -9,6 +9,7 @@
 #include <linux/string.h>
 #include <linux/fb.h>
 #include <linux/mm.h>
+#include <linux/uaccess.h>
 
 #include <asm/oplib.h>
 #include <asm/fbio.h>
_

Patches currently in -mm which might be from reif@earthlink.net are

git-sparc64.patch
sparc-fix-build.patch
