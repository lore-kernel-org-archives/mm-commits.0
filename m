From: akpm@linux-foundation.org
Subject: - make-isdn-capi-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:35 -0700
Message-ID: <200707172303.l6HN3ZIg011701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760894AbXGQXQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, kkeil@suse.de, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make ISDN CAPI use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-isdn-capi-use-seq_list_xxx-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make ISDN CAPI use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

The similar code exists here and is called capi_driver_get_idx().  Use generic
helpers now and remember to convert list_head to struct capi_driver in .show
callback.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/capi/kcapi_proc.c |   28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

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

origin.patch
make-input-layer-use-seq_list_xxx-helpers.patch
