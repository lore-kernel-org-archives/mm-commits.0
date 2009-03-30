From: akpm@linux-foundation.org
Subject: [merged] mtd-onenand-add-write-while-program-support.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:06:09 -0700
Message-ID: <200903301906.n2UJ69KX018970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759387AbZC3TKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:10:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kmpark@infradead.org, dwmw2@infradead.org, ext-adrian.hunter@nokia.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     mtd: onenand: add write-while-program support
has been removed from the -mm tree.  Its filename was
     mtd-onenand-add-write-while-program-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: onenand: add write-while-program support
From: Kyungmin Park <kmpark@infradead.org>

It's similar with read-while-program method.
but it's write side performance improvement.

Here's brief performance results.
Note: Measured from OMAP3 with async OneNAND mode. (not sync mode)

=================================================================
speedtest: dev = 3
speedtest: Size=16777216  EB size=131072  Write size=2048  EB count=128
                Pages per EB=64  Page size=2048
speedtest: scanning for bad blocks
speedtest: scanned 0
speedtest: scanned 128, found 0 bad
speedtest: erasing
speedtest: erased 0
speedtest: erased 128
speedtest: Testing eraseblock write speed
eraseblock write speed is 2592 KiB/s
speedtest: Testing eraseblock read speed
eraseblock read speed is 16786 KiB/s
speedtest: Testing page write speed
page write speed is 2966 KiB/s
speedtest: Testing page read speed
page read speed is 13277 KiB/s
speedtest: Testing 2 page write speed
2 page write speed is 3182 KiB/s
speedtest: Testing 2 page read speed
2 page read speed is 14773 KiB/s
speedtest: Testing erase speed
erase speed is 192752 KiB/s
speedtest: speedtest finished
=================================================================

Also it's passed all nand-tests.

Adrian:

  I have made a couple of tiny changes and tested this.  I get a 10% -
  25% improvement in write speed when writing more than 1 page.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/onenand/onenand_base.c |  149 +++++++++++++++++----------
 1 file changed, 98 insertions(+), 51 deletions(-)

diff -puN drivers/mtd/onenand/onenand_base.c~mtd-onenand-add-write-while-program-support drivers/mtd/onenand/onenand_base.c
--- a/drivers/mtd/onenand/onenand_base.c~mtd-onenand-add-write-while-program-support
+++ a/drivers/mtd/onenand/onenand_base.c
@@ -1780,7 +1780,8 @@ static int onenand_write_ops_nolock(stru
 				struct mtd_oob_ops *ops)
 {
 	struct onenand_chip *this = mtd->priv;
-	int written = 0, column, thislen, subpage;
+	int written = 0, column, thislen = 0, subpage = 0;
+	int prev = 0, prevlen = 0, prev_subpage = 0, first = 1;
 	int oobwritten = 0, oobcolumn, thisooblen, oobsize;
 	size_t len = ops->len;
 	size_t ooblen = ops->ooblen;
@@ -1807,6 +1808,10 @@ static int onenand_write_ops_nolock(stru
                 return -EINVAL;
         }
 
+	/* Check zero length */
+	if (!len)
+		return 0;
+
 	if (ops->mode == MTD_OOB_AUTO)
 		oobsize = this->ecclayout->oobavail;
 	else
@@ -1817,79 +1822,121 @@ static int onenand_write_ops_nolock(stru
 	column = to & (mtd->writesize - 1);
 
 	/* Loop until all data write */
-	while (written < len) {
-		u_char *wbuf = (u_char *) buf;
+	while (1) {
+		if (written < len) {
+			u_char *wbuf = (u_char *) buf;
+
+			thislen = min_t(int, mtd->writesize - column, len - written);
+			thisooblen = min_t(int, oobsize - oobcolumn, ooblen - oobwritten);
+
+			cond_resched();
+
+			this->command(mtd, ONENAND_CMD_BUFFERRAM, to, thislen);
+
+			/* Partial page write */
+			subpage = thislen < mtd->writesize;
+			if (subpage) {
+				memset(this->page_buf, 0xff, mtd->writesize);
+				memcpy(this->page_buf + column, buf, thislen);
+				wbuf = this->page_buf;
+			}
 
-		thislen = min_t(int, mtd->writesize - column, len - written);
-		thisooblen = min_t(int, oobsize - oobcolumn, ooblen - oobwritten);
+			this->write_bufferram(mtd, ONENAND_DATARAM, wbuf, 0, mtd->writesize);
 
-		cond_resched();
+			if (oob) {
+				oobbuf = this->oob_buf;
 
-		this->command(mtd, ONENAND_CMD_BUFFERRAM, to, thislen);
+				/* We send data to spare ram with oobsize
+				 * to prevent byte access */
+				memset(oobbuf, 0xff, mtd->oobsize);
+				if (ops->mode == MTD_OOB_AUTO)
+					onenand_fill_auto_oob(mtd, oobbuf, oob, oobcolumn, thisooblen);
+				else
+					memcpy(oobbuf + oobcolumn, oob, thisooblen);
+
+				oobwritten += thisooblen;
+				oob += thisooblen;
+				oobcolumn = 0;
+			} else
+				oobbuf = (u_char *) ffchars;
 
-		/* Partial page write */
-		subpage = thislen < mtd->writesize;
-		if (subpage) {
-			memset(this->page_buf, 0xff, mtd->writesize);
-			memcpy(this->page_buf + column, buf, thislen);
-			wbuf = this->page_buf;
-		}
+			this->write_bufferram(mtd, ONENAND_SPARERAM, oobbuf, 0, mtd->oobsize);
+		} else
+			ONENAND_SET_NEXT_BUFFERRAM(this);
 
-		this->write_bufferram(mtd, ONENAND_DATARAM, wbuf, 0, mtd->writesize);
+		/*
+		 * 2 PLANE, MLC, and Flex-OneNAND doesn't support
+		 * write-while-programe feature.
+		 */
+		if (!ONENAND_IS_2PLANE(this) && !first) {
+			ONENAND_SET_PREV_BUFFERRAM(this);
 
-		if (oob) {
-			oobbuf = this->oob_buf;
+			ret = this->wait(mtd, FL_WRITING);
 
-			/* We send data to spare ram with oobsize
-			 * to prevent byte access */
-			memset(oobbuf, 0xff, mtd->oobsize);
-			if (ops->mode == MTD_OOB_AUTO)
-				onenand_fill_auto_oob(mtd, oobbuf, oob, oobcolumn, thisooblen);
-			else
-				memcpy(oobbuf + oobcolumn, oob, thisooblen);
-
-			oobwritten += thisooblen;
-			oob += thisooblen;
-			oobcolumn = 0;
-		} else
-			oobbuf = (u_char *) ffchars;
+			/* In partial page write we don't update bufferram */
+			onenand_update_bufferram(mtd, prev, !ret && !prev_subpage);
+			if (ret) {
+				written -= prevlen;
+				printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
+				break;
+			}
 
-		this->write_bufferram(mtd, ONENAND_SPARERAM, oobbuf, 0, mtd->oobsize);
+			if (written == len) {
+				/* Only check verify write turn on */
+				ret = onenand_verify(mtd, buf - len, to - len, len);
+				if (ret)
+					printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
+				break;
+			}
 
-		this->command(mtd, ONENAND_CMD_PROG, to, mtd->writesize);
+			ONENAND_SET_NEXT_BUFFERRAM(this);
+		}
 
-		ret = this->wait(mtd, FL_WRITING);
+		this->command(mtd, ONENAND_CMD_PROG, to, mtd->writesize);
 
-		/* In partial page write we don't update bufferram */
-		onenand_update_bufferram(mtd, to, !ret && !subpage);
+		/*
+		 * 2 PLANE, MLC, and Flex-OneNAND wait here
+		 */
 		if (ONENAND_IS_2PLANE(this)) {
-			ONENAND_SET_BUFFERRAM1(this);
-			onenand_update_bufferram(mtd, to + this->writesize, !ret && !subpage);
-		}
+			ret = this->wait(mtd, FL_WRITING);
 
-		if (ret) {
-			printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
-			break;
-		}
+			/* In partial page write we don't update bufferram */
+			onenand_update_bufferram(mtd, to, !ret && !subpage);
+			if (ret) {
+				printk(KERN_ERR "onenand_write_ops_nolock: write filaed %d\n", ret);
+				break;
+			}
 
-		/* Only check verify write turn on */
-		ret = onenand_verify(mtd, buf, to, thislen);
-		if (ret) {
-			printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
-			break;
-		}
+			/* Only check verify write turn on */
+			ret = onenand_verify(mtd, buf, to, thislen);
+			if (ret) {
+				printk(KERN_ERR "onenand_write_ops_nolock: verify failed %d\n", ret);
+				break;
+			}
 
-		written += thislen;
+			written += thislen;
 
-		if (written == len)
-			break;
+			if (written == len)
+				break;
+
+		} else
+			written += thislen;
 
 		column = 0;
+		prev_subpage = subpage;
+		prev = to;
+		prevlen = thislen;
 		to += thislen;
 		buf += thislen;
+		first = 0;
 	}
 
+	/* In error case, clear all bufferrams */
+	if (written != len)
+		onenand_invalidate_bufferram(mtd, 0, -1);
+
 	ops->retlen = written;
+	ops->oobretlen = oobwritten;
 
 	return ret;
 }
_

Patches currently in -mm which might be from kmpark@infradead.org are

linux-next.patch
mtd-onenand-add-bbt_wait-unlock_all-as-replaceable-for-some-platform.patch

