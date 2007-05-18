From: akpm@linux-foundation.org
Subject: + make-isdn-capi-use-seq_list_xxx-helpers.patch added to -mm tree
Date: Fri, 18 May 2007 10:37:48 -0700
Message-ID: <200705181737.l4IHbmPu019863@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from [207.189.120.14] ([207.189.120.14]:59750 "EHLO
	smtp2.linux-foundation.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbXERRmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 13:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@sw.ru, kkeil@suse.de, xemul@openvz.org


The patch titled
     Make ISDN CAPI use seq_list_xxx helpers
has been added to the -mm tree.  Its filename is
     make-isdn-capi-use-seq_list_xxx-helpers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make ISDN CAPI use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

The similar code exists here and is called capi_driver_get_idx().  Use generic
helpers now and remember to convert list_head to struct capi_driver in .show
callback.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c |   28 ++++------------------------
 1 files changed, 4 insertions(+), 24 deletions(-)

diff -puN drivers/isdn/capi/kcapi_proc.c~make-isdn-capi-use-seq_list_xxx-helpers drivers/isdn/capi/kcapi_proc.c
--- a/drivers/isdn/capi/kcapi_proc.c~make-isdn-capi-use-seq_list_xxx-helpers
+++ a/drivers/isdn/capi/kcapi_proc.c
@@ -243,36 +243,15 @@ create_seq_entry(char *name, mode_t mode
 
 // ---------------------------------------------------------------------------
 
-
-static __inline__ struct capi_driver *capi_driver_get_idx(loff_t pos)
-{
-	struct capi_driver *drv = NULL;
-	struct list_head *l;
-	loff_t i;
-
-	i = 0;
-	list_for_each(l, &capi_drivers) {
-		drv = list_entry(l, struct capi_driver, list);
-		if (i++ == pos)
-			return drv;
-	}
-	return NULL;
-}
-
 static void *capi_driver_start(struct seq_file *seq, loff_t *pos)
 {
-	struct capi_driver *drv;
 	read_lock(&capi_drivers_list_lock);
-	drv = capi_driver_get_idx(*pos);
-	return drv;
+	return seq_list_start(&capi_drivers, *pos);
 }
 
 static void *capi_driver_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct capi_driver *drv = (struct capi_driver *)v;
-	++*pos;
-	if (drv->list.next == &capi_drivers) return NULL;
-	return list_entry(drv->list.next, struct capi_driver, list);
+	return seq_list_next(v, &capi_drivers, pos);
 }
 
 static void capi_driver_stop(struct seq_file *seq, void *v)
@@ -282,7 +261,8 @@ static void capi_driver_stop(struct seq_
 
 static int capi_driver_show(struct seq_file *seq, void *v)
 {
-	struct capi_driver *drv = (struct capi_driver *)v;
+	struct capi_driver *drv = list_entry(v, struct capi_driver, list);
+
 	seq_printf(seq, "%-32s %s\n", drv->name, drv->revision);
 	return 0;
 }
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
