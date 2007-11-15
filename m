From: akpm@linux-foundation.org
Subject: - cm40x0_csc-fix-debug-macros.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:18 -0800
Message-ID: <200711152108.lAFL8IDb015347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXKOVIj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pterjan@mandriva.com, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     cm40x0_cs.c: fix debug macros
has been removed from the -mm tree.  Its filename was
     cm40x0_csc-fix-debug-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cm40x0_cs.c: fix debug macros
From: Pascal Terjan <pterjan@mandriva.com>

When PCMCIA_DEBUG is set, cm40x0_cs.c and cm4000_cs.c don't build because the
definition of reader_to_dev uses a non-existent handle field of the struct
pcmcia_device in the call to handle_to_dev.  As handle_to_dev works on struct
pcmcia_device, the fix is quite trivial.

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pcmcia/cm4000_cs.c |    2 +-
 drivers/char/pcmcia/cm4040_cs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/pcmcia/cm4000_cs.c~cm40x0_csc-fix-debug-macros drivers/char/pcmcia/cm4000_cs.c
--- a/drivers/char/pcmcia/cm4000_cs.c~cm40x0_csc-fix-debug-macros
+++ a/drivers/char/pcmcia/cm4000_cs.c
@@ -47,7 +47,7 @@
 /* #define ATR_CSUM */
 
 #ifdef PCMCIA_DEBUG
-#define reader_to_dev(x)	(&handle_to_dev(x->p_dev->handle))
+#define reader_to_dev(x)	(&handle_to_dev(x->p_dev))
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
diff -puN drivers/char/pcmcia/cm4040_cs.c~cm40x0_csc-fix-debug-macros drivers/char/pcmcia/cm4040_cs.c
--- a/drivers/char/pcmcia/cm4040_cs.c~cm40x0_csc-fix-debug-macros
+++ a/drivers/char/pcmcia/cm4040_cs.c
@@ -41,7 +41,7 @@
 
 
 #ifdef PCMCIA_DEBUG
-#define reader_to_dev(x)	(&handle_to_dev(x->p_dev->handle))
+#define reader_to_dev(x)	(&handle_to_dev(x->p_dev))
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0600);
 #define DEBUGP(n, rdr, x, args...) do { 				\
_

Patches currently in -mm which might be from pterjan@mandriva.com are

origin.patch
