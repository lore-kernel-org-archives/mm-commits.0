From: akpm@linux-foundation.org
Subject: - make-proc-tty-drivers-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:46 -0700
Message-ID: <200707162053.l6GKrkR6001675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760002AbXGPVdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, alan@lxorguk.ukuu.org.uk, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make /proc/tty/drivers use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-proc-tty-drivers-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make /proc/tty/drivers use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid like some previous ones.  Just use new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff -puN fs/proc/proc_tty.c~make-proc-tty-drivers-use-seq_list_xxx-helpers fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~make-proc-tty-drivers-use-seq_list_xxx-helpers
+++ a/fs/proc/proc_tty.c
@@ -69,7 +69,7 @@ static void show_tty_range(struct seq_fi
 
 static int show_tty_driver(struct seq_file *m, void *v)
 {
-	struct tty_driver *p = v;
+	struct tty_driver *p = list_entry(v, struct tty_driver, tty_drivers);
 	dev_t from = MKDEV(p->major, p->minor_start);
 	dev_t to = from + p->num;
 
@@ -106,22 +106,13 @@ static int show_tty_driver(struct seq_fi
 /* iterator */
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
-	struct list_head *p;
-	loff_t l = *pos;
-
 	mutex_lock(&tty_mutex);
-	list_for_each(p, &tty_drivers)
-		if (!l--)
-			return list_entry(p, struct tty_driver, tty_drivers);
-	return NULL;
+	return seq_list_start(&tty_drivers, *pos);
 }
 
 static void *t_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct tty_driver *)v)->tty_drivers.next;
-	(*pos)++;
-	return p==&tty_drivers ? NULL :
-			list_entry(p, struct tty_driver, tty_drivers);
+	return seq_list_next(v, &tty_drivers, pos);
 }
 
 static void t_stop(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
