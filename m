From: akpm@linux-foundation.org
Subject: + mtdpart-handle-remaining-checkpatch-findings.patch added to -mm tree
Date: Fri, 18 Jul 2008 14:42:32 -0700
Message-ID: <200807182142.m6ILgWXW032333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328AbYGRVmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 17:42:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, joern@logfs.org


The patch titled
     mtdpart: handle remaining checkpatch findings
has been added to the -mm tree.  Its filename is
     mtdpart-handle-remaining-checkpatch-findings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtdpart: handle remaining checkpatch findings
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Handle warnings about long lines and braces.  Now mtdpart.c is
checkpatch-clean.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Joern Engel <joern@logfs.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdpart.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff -puN drivers/mtd/mtdpart.c~mtdpart-handle-remaining-checkpatch-findings drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~mtdpart-handle-remaining-checkpatch-findings
+++ a/drivers/mtd/mtdpart.c
@@ -324,7 +324,9 @@ static struct mtd_part *add_one_partitio
 	/* allocate the partition structure */
 	slave = kzalloc(sizeof(*slave), GFP_KERNEL);
 	if (!slave) {
-		printk(KERN_ERR"memory allocation error while creating partitions for \"%s\"\n",
+		printk(KERN_ERR
+			"memory allocation error while creating partitions for"
+			" \"%s\"\n",
 			master->name);
 		del_mtd_partitions(master);
 		return NULL;
@@ -397,7 +399,9 @@ static struct mtd_part *add_one_partitio
 		slave->offset = cur_offset;
 		if ((cur_offset % master->erasesize) != 0) {
 			/* Round up to next erasesize */
-			slave->offset = ((cur_offset / master->erasesize) + 1) * master->erasesize;
+			slave->offset =
+				((cur_offset / master->erasesize) + 1) *
+				master->erasesize;
 			printk(KERN_NOTICE "Moving partition %d: "
 			       "0x%08x -> 0x%08x\n", partno,
 			       cur_offset, slave->offset);
@@ -414,13 +418,16 @@ static struct mtd_part *add_one_partitio
 		/* let's register it anyway to preserve ordering */
 		slave->offset = 0;
 		slave->mtd.size = 0;
-		printk(KERN_ERR"mtd: partition \"%s\" is out of reach -- disabled\n",
+		printk(KERN_ERR
+			"mtd: partition \"%s\" is out of reach -- disabled\n",
 			part->name);
 		goto out_register;
 	}
 	if (slave->offset + slave->mtd.size > master->size) {
 		slave->mtd.size = master->size - slave->offset;
-		printk(KERN_WARNING"mtd: partition \"%s\" extends beyond the end of device \"%s\" -- size truncated to %#x\n",
+		printk(KERN_WARNING "mtd: partition \"%s\" "
+			"extends beyond the end of device \"%s\""
+			" -- size truncated to %#x\n",
 			part->name, master->name, slave->mtd.size);
 	}
 	if (master->numeraseregions > 1) {
@@ -438,9 +445,8 @@ static struct mtd_part *add_one_partitio
 
 		/* Pick biggest erasesize */
 		for (; i < max && regions[i].offset < end; i++) {
-			if (slave->mtd.erasesize < regions[i].erasesize) {
+			if (slave->mtd.erasesize < regions[i].erasesize)
 				slave->mtd.erasesize = regions[i].erasesize;
-			}
 		}
 		BUG_ON(slave->mtd.erasesize == 0);
 	} else {
@@ -454,13 +460,16 @@ static struct mtd_part *add_one_partitio
 		/* FIXME: Let it be writable if it is on a boundary of
 		 * _minor_ erase size though */
 		slave->mtd.flags &= ~MTD_WRITEABLE;
-		printk(KERN_WARNING"mtd: partition \"%s\" doesn't start on an erase block boundary -- force read-only\n",
+		printk(KERN_WARNING "mtd: partition \"%s\""
+			" doesn't start on an erase block boundary"
+			" -- force read-only\n",
 			part->name);
 	}
 	if ((slave->mtd.flags & MTD_WRITEABLE) &&
 	    (slave->mtd.size % slave->mtd.erasesize)) {
 		slave->mtd.flags &= ~MTD_WRITEABLE;
-		printk(KERN_WARNING"mtd: partition \"%s\" doesn't end on an erase block -- force read-only\n",
+		printk(KERN_WARNING "mtd: partition \"%s\""
+			" doesn't end on an erase block -- force read-only\n",
 			part->name);
 	}
 
@@ -504,7 +513,8 @@ int add_mtd_partitions(struct mtd_info *
 	u_int32_t cur_offset = 0;
 	int i;
 
-	printk(KERN_NOTICE "Creating %d MTD partitions on \"%s\":\n", nbparts, master->name);
+	printk(KERN_NOTICE "Creating %d MTD partitions on \"%s\":\n",
+		nbparts, master->name);
 
 	for (i = 0; i < nbparts; i++) {
 		slave = add_one_partition(master, parts + i, i, cur_offset);
@@ -569,14 +579,16 @@ int parse_mtd_partitions(struct mtd_info
 				parser = get_partition_parser(*types);
 #endif
 		if (!parser) {
-			printk(KERN_NOTICE "%s partition parsing not available\n",
-			       *types);
+			printk(KERN_NOTICE
+				"%s partition parsing not available\n",
+				*types);
 			continue;
 		}
 		ret = (*parser->parse_fn)(master, pparts, origin);
 		if (ret > 0) {
-			printk(KERN_NOTICE "%d %s partitions found on MTD device %s\n",
-			       ret, parser->name, master->name);
+			printk(KERN_NOTICE
+				"%d %s partitions found on MTD device %s\n",
+				ret, parser->name, master->name);
 		}
 		put_partition_parser(parser);
 	}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
fix-build-on-compat-platforms-when-config_epoll-is-disabled.patch
linux-next.patch
mtd-jedec_probe-fix-sst-16-bit-chip-detection.patch
mtdpart-separate-main-loop-from-per-partition-code-in-add_mtd_partition.patch
mtdpart-handle-most-checkpatch-findings.patch
mtdpart-cleanup-and-document-the-erase-region-handling.patch
mtdpart-fix-a-division-by-zero-bug.patch
mtdpart-handle-remaining-checkpatch-findings.patch

