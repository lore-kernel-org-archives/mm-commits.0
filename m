From: akpm@linux-foundation.org
Subject: + make-various-things-static.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:15:32 -0700
Message-ID: <200810302115.m9ULFXqY012159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351AbYJ3VQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com


The patch titled
     Make various things static
has been added to the -mm tree.  Its filename is
     make-various-things-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 block/blk-softirq.c       |    2 +-
 drivers/char/pty.c        |    2 +-
 drivers/char/tty_io.c     |    2 +-
 drivers/char/vt.c         |    2 +-
 drivers/firmware/memmap.c |    6 +++---
 mm/page_alloc.c           |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff -puN block/blk-softirq.c~make-various-things-static block/blk-softirq.c
--- a/block/blk-softirq.c~make-various-things-static
+++ a/block/blk-softirq.c
@@ -161,7 +161,7 @@ void blk_complete_request(struct request
 }
 EXPORT_SYMBOL(blk_complete_request);
 
-__init int blk_softirq_init(void)
+static __init int blk_softirq_init(void)
 {
 	int i;
 
diff -puN drivers/char/pty.c~make-various-things-static drivers/char/pty.c
--- a/drivers/char/pty.c~make-various-things-static
+++ a/drivers/char/pty.c
@@ -34,7 +34,7 @@
 
 /* These are global because they are accessed in tty_io.c */
 #ifdef CONFIG_UNIX98_PTYS
-struct tty_driver *ptm_driver;
+static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
 #endif
 
diff -puN drivers/char/tty_io.c~make-various-things-static drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~make-various-things-static
+++ a/drivers/char/tty_io.c
@@ -1213,7 +1213,7 @@ static void tty_line_name(struct tty_dri
  *	be held until the 'fast-open' is also done. Will change once we
  *	have refcounting in the driver and per driver locking
  */
-struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
+static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 		struct inode *inode, int idx)
 {
 	struct tty_struct *tty;
diff -puN drivers/char/vt.c~make-various-things-static drivers/char/vt.c
--- a/drivers/char/vt.c~make-various-things-static
+++ a/drivers/char/vt.c
@@ -971,7 +971,7 @@ int vc_resize(struct vc_data *vc, unsign
  *	termios_mutex and the tty ctrl_lock in that order.
  */
 
-int vt_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+static int vt_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 	struct winsize *ws)
 {
 	struct vc_data *vc = tty->driver_data;
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
diff -puN mm/page_alloc.c~make-various-things-static mm/page_alloc.c
--- a/mm/page_alloc.c~make-various-things-static
+++ a/mm/page_alloc.c
@@ -4316,7 +4316,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-void setup_per_zone_inactive_ratio(void)
+static void setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
u14-34f-fix-scsi_dma_map-failure-case.patch
make-various-things-static.patch

