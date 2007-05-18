From: akpm@linux-foundation.org
Subject: + make-proc-misc-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:50 -0700
Message-ID: <200705181737.l4IHbo92019866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:36257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbXERRla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, xemul@openvz.org


The patch titled
     Make /proc/misc use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-proc-misc-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make /proc/misc use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

Simple and stupid - just use the helpers.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

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
