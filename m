From: akpm@linux-foundation.org
Subject: + mtd-nand-fix-htmldocs-warnings.patch added to -mm tree
Date: Thu, 24 Sep 2009 15:16:17 -0700
Message-ID: <200909242216.n8OMGIqs028590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200AbZIXWSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 18:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, David.Woodhouse@intel.com, jaswinderrajput@gmail.com, nsnehaprabha@ti.com, randy.dunlap@oracle.com, s-paulraj@ti.com, tglx@linutronix.de


The patch titled
     mtd: nand: fix htmldocs warnings
has been added to the -mm tree.  Its filename is
     mtd-nand-fix-htmldocs-warnings.patch

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
Subject: mtd: nand: fix htmldocs warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fixed following htmldocs warnings:

  DOCPROC Documentation/DocBook/mtdnand.xml
  Warning(drivers/mtd/nand/nand_base.c:769): No description found for parameter 'page'
  Warning(drivers/mtd/nand/nand_base.c:785): No description found for parameter 'page'
  Warning(drivers/mtd/nand/nand_base.c:824): No description found for parameter 'page'
  Warning(drivers/mtd/nand/nand_base.c:947): No description found for parameter 'page'
  Warning(drivers/mtd/nand/nand_base.c:996): No description found for parameter 'page'
  Warning(drivers/mtd/nand/nand_base.c:1040): No description found for parameter 'page'

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Sneha Narnakaje <nsnehaprabha@ti.com>
Cc: Sandeep Paulraj <s-paulraj@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/nand_base.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/mtd/nand/nand_base.c~mtd-nand-fix-htmldocs-warnings drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c~mtd-nand-fix-htmldocs-warnings
+++ a/drivers/mtd/nand/nand_base.c
@@ -761,6 +761,7 @@ static int nand_wait(struct mtd_info *mt
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  *
  * Not for syndrome calculating ecc controllers, which use a special oob layout
  */
@@ -777,6 +778,7 @@ static int nand_read_page_raw(struct mtd
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  *
  * We need a special oob layout and handling even when OOB isn't used.
  */
@@ -818,6 +820,7 @@ static int nand_read_page_raw_syndrome(s
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  */
 static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int page)
@@ -939,6 +942,7 @@ static int nand_read_subpage(struct mtd_
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  *
  * Not for syndrome calculating ecc controllers which need a special oob layout
  */
@@ -983,6 +987,7 @@ static int nand_read_page_hwecc(struct m
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  *
  * Hardware ECC for large page chips, require OOB to be read first.
  * For this ECC mode, the write_page method is re-used from ECC_HW.
@@ -1031,6 +1036,7 @@ static int nand_read_page_hwecc_oob_firs
  * @mtd:	mtd info structure
  * @chip:	nand chip info structure
  * @buf:	buffer to store read data
+ * @page:	page number to read
  *
  * The hw generator calculates the error syndrome automatically. Therefor
  * we need a special oob layout and handling.
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
mtd-nand-fix-htmldocs-warnings.patch

