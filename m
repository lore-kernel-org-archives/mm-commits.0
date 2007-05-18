From: akpm@linux-foundation.org
Subject: + make-proc-tty-drivers-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:38:00 -0700
Message-ID: <200705181738.l4IHc0V0019882@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:34569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754560AbXERRmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, alan@lxorguk.ukuu.org.uk, xemul@openvz.org


The patch titled
     Make /proc/tty/drivers use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-proc-tty-drivers-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /proc/tty/drivers use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid like some previous ones.  Just use new API.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

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

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-afs-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
