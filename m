From: akpm@linux-foundation.org
Subject: - make-block-layer-proc-files-use-seq_list_xxx-helpers.patch removed from -mm tree
Date: Tue, 22 May 2007 13:38:46 -0700
Message-ID: <200705222038.l4MKcmNm009341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757431AbXEVUlT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@sw.ru, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Make block layer /proc files use seq_list_xxx helpers
has been removed from the -mm tree.  Its filename was
     make-block-layer-proc-files-use-seq_list_xxx-helpers.patch

This patch was dropped because changes in Greg's tree destroyed it

------------------------------------------------------
Subject: Make block layer /proc files use seq_list_xxx helpers
From: Pavel Emelianov <xemul@sw.ru>

The /proc/partitions .show callback checked the *v to be the first element in
list to show the header.  Now *v is the struct list_head pointer and it is
checked for the head of the list.

The comment in /proc/diskstats .show handler is also updated not to forget it
in the future.

Signed-off-by: Pavel Emelianov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c |   40 ++++++++++++++--------------------------
 1 files changed, 14 insertions(+), 26 deletions(-)

diff -puN block/genhd.c~make-block-layer-proc-files-use-seq_list_xxx-helpers block/genhd.c
--- a/block/genhd.c~make-block-layer-proc-files-use-seq_list_xxx-helpers
+++ a/block/genhd.c
@@ -270,22 +270,13 @@ void __init printk_all_partitions(void)
 /* iterator */
 static void *part_start(struct seq_file *part, loff_t *pos)
 {
-	struct list_head *p;
-	loff_t l = *pos;
-
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
-		if (!l--)
-			return list_entry(p, struct gendisk, kobj.entry);
-	return NULL;
+	return seq_list_start_head(&block_subsys.list, *pos);
 }
 
 static void *part_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
-	++*pos;
-	return p==&block_subsys.list ? NULL :
-		list_entry(p, struct gendisk, kobj.entry);
+	return seq_list_next(v, &block_subsys.list, pos);
 }
 
 static void part_stop(struct seq_file *part, void *v)
@@ -295,13 +286,16 @@ static void part_stop(struct seq_file *p
 
 static int show_partition(struct seq_file *part, void *v)
 {
-	struct gendisk *sgp = v;
+	struct gendisk *sgp;
 	int n;
 	char buf[BDEVNAME_SIZE];
 
-	if (&sgp->kobj.entry == block_subsys.list.next)
+	if (v == &block_subsys.list) {
 		seq_puts(part, "major minor  #blocks  name\n\n");
+		return 0;
+	}
 
+	sgp = list_entry(v, struct gendisk, kobj.entry);
 	/* Don't show non-partitionable removeable devices or empty devices */
 	if (!get_capacity(sgp) ||
 			(sgp->minors == 1 && (sgp->flags & GENHD_FL_REMOVABLE)))
@@ -622,22 +616,13 @@ decl_subsys(block, &ktype_block, &block_
 /* iterator */
 static void *diskstats_start(struct seq_file *part, loff_t *pos)
 {
-	loff_t k = *pos;
-	struct list_head *p;
-
 	mutex_lock(&block_subsys_lock);
-	list_for_each(p, &block_subsys.list)
-		if (!k--)
-			return list_entry(p, struct gendisk, kobj.entry);
-	return NULL;
+	return seq_list_start(&block_subsys.list, *pos);
 }
 
 static void *diskstats_next(struct seq_file *part, void *v, loff_t *pos)
 {
-	struct list_head *p = ((struct gendisk *)v)->kobj.entry.next;
-	++*pos;
-	return p==&block_subsys.list ? NULL :
-		list_entry(p, struct gendisk, kobj.entry);
+	return seq_list_next(v, &block_subsys.list, pos);
 }
 
 static void diskstats_stop(struct seq_file *part, void *v)
@@ -647,18 +632,21 @@ static void diskstats_stop(struct seq_fi
 
 static int diskstats_show(struct seq_file *s, void *v)
 {
-	struct gendisk *gp = v;
+	struct gendisk *gp;
 	char buf[BDEVNAME_SIZE];
 	int n = 0;
 
 	/*
-	if (&sgp->kobj.entry == block_subsys.kset.list.next)
+	if (v == &block_subsys.list) {
 		seq_puts(s,	"major minor name"
 				"     rio rmerge rsect ruse wio wmerge "
 				"wsect wuse running use aveq"
 				"\n\n");
+		return 0;
+	}
 	*/
  
+	gp = list_entry(v, struct gendisk, kobj.entry);
 	preempt_disable();
 	disk_round_stats(gp);
 	preempt_enable();
_

Patches currently in -mm which might be from xemul@sw.ru are

make-common-helpers-for-seq_files-that-work-with-list_head-s.patch
make-input-layer-use-seq_list_xxx-helpers.patch
make-atm-driver-use-seq_list_xxx-helpers.patch
make-some-network-related-proc-files-use-seq_list_xxx.patch
make-some-netfilter-related-proc-files-use-seq_list_xxx.patch
make-block-layer-proc-files-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-afs-use-seq_list_xxx-helpers.patch
make-crypto-api-use-seq_list_xxx-helpers.patch
make-proc-misc-use-seq_list_xxx-helpers.patch
make-proc-modules-use-seq_list_xxx-helpers.patch
make-proc-tty-drivers-use-seq_list_xxx-helpers.patch
make-proc-self-mountstats-use-seq_list_xxx-helpers.patch
make-nfs-client-use-seq_list_xxx-helpers.patch
make-isdn-capi-use-seq_list_xxx-helpers.patch
