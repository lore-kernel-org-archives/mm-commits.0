From: akpm@linux-foundation.org
Subject: - make-various-things-static.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:26 -0800
Message-ID: <200901082251.n08MpQnI030554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763526AbZAHWv3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Make various things static
has been removed from the -mm tree.  Its filename was
     make-various-things-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Make various things static
From: Roel Kluin <roel.kluin@gmail.com>

Building an allnoconfig kernel, sparse asked whether these could be
static, so I checked, and they are only used in the file where they are
declared.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c        |    2 +-
 drivers/char/vt.c         |    3 +--
 drivers/firmware/memmap.c |    6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/char/pty.c~make-various-things-static drivers/char/pty.c
--- a/drivers/char/pty.c~make-various-things-static
+++ a/drivers/char/pty.c
@@ -32,7 +32,7 @@
 
 /* These are global because they are accessed in tty_io.c */
 #ifdef CONFIG_UNIX98_PTYS
-struct tty_driver *ptm_driver;
+static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
 
diff -puN drivers/char/vt.c~make-various-things-static drivers/char/vt.c
--- a/drivers/char/vt.c~make-various-things-static
+++ a/drivers/char/vt.c
@@ -969,8 +969,7 @@ int vc_resize(struct vc_data *vc, unsign
  *	Takes the console sem and the called methods then take the tty
  *	termios_mutex and the tty ctrl_lock in that order.
  */
-
-int vt_resize(struct tty_struct *tty, struct winsize *ws)
+static int vt_resize(struct tty_struct *tty, struct winsize *ws)
 {
 	struct vc_data *vc = tty->driver_data;
 	int ret;
diff -puN drivers/firmware/memmap.c~make-various-things-static drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~make-various-things-static
+++ a/drivers/firmware/memmap.c
@@ -56,9 +56,9 @@ struct memmap_attribute {
 	ssize_t (*show)(struct firmware_map_entry *entry, char *buf);
 };
 
-struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
-struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
-struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
+static struct memmap_attribute memmap_start_attr = __ATTR_RO(start);
+static struct memmap_attribute memmap_end_attr   = __ATTR_RO(end);
+static struct memmap_attribute memmap_type_attr  = __ATTR_RO(type);
 
 /*
  * These are default attributes that are added for every memmap entry.
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
ufs-sector_t-cannot-be-negative.patch

