From: akpm@linux-foundation.org
Subject: - make-proc-misc-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:42 -0700
Message-ID: <200707162053.l6GKrgFw001667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760664AbXGPVY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make /proc/misc use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-proc-misc-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make /proc/misc use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid - just use the helpers.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff -puN drivers/char/misc.c~make-proc-misc-use-seq_list_xxx-helpers drivers/char/misc.c
--- a/drivers/char/misc.c~make-proc-misc-use-seq_list_xxx-helpers
+++ a/drivers/char/misc.c
@@ -67,25 +67,13 @@ extern int pmu_device_init(void);
 #ifdef CONFIG_PROC_FS
 static void *misc_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	struct miscdevice *p;
-	loff_t off = 0;
-
 	mutex_lock(&misc_mtx);
-	list_for_each_entry(p, &misc_list, list) {
-		if (*pos == off++) 
-			return p;
-	}
-	return NULL;
+	return seq_list_start(&misc_list, *pos);
 }
 
 static void *misc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct list_head *n = ((struct miscdevice *)v)->list.next;
-
-	++*pos;
-
-	return (n != &misc_list) ? list_entry(n, struct miscdevice, list)
-		 : NULL;
+	return seq_list_next(v, &misc_list, pos);
 }
 
 static void misc_seq_stop(struct seq_file *seq, void *v)
@@ -95,7 +83,7 @@ static void misc_seq_stop(struct seq_fil
 
 static int misc_seq_show(struct seq_file *seq, void *v)
 {
-	const struct miscdevice *p = v;
+	const struct miscdevice *p = list_entry(v, struct miscdevice, list);
 
 	seq_printf(seq, "%3i %s\n", p->minor, p->name ? p->name : "");
 	return 0;
_

Patches currently in -mm which might be from xemul@sw.ru are

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
