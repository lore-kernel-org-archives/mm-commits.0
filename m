From: akpm@linux-foundation.org
Subject: + sparc-build-fixes.patch added to -mm tree
Date: Tue, 12 Feb 2008 13:37:07 -0800
Message-ID: <200802122137.m1CLb7jf023454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYBLVha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 16:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: reif@earthlink.net, bunk@stusta.de, davem@davemloft.net, rientjes@google.com


The patch titled
     sparc build fixes
has been added to the -mm tree.  Its filename is
     sparc-build-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sparc-fix-build.patch
sparc-build-fixes.patch
