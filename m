From: akpm@linux-foundation.org
Subject: + parisc-use-seq_hex_dump-to-dump-buffers.patch added to -mm tree
Date: Tue, 07 Jul 2015 13:59:42 -0700
Message-ID: <559c3dbe.RQv0qj7RkP/ItFqG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbbGGU7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jul 2015 16:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: use seq_hex_dump() to dump buffers
has been added to the -mm tree.  Its filename is
     parisc-use-seq_hex_dump-to-dump-buffers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-use-seq_hex_dump-to-dump-buffers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-use-seq_hex_dump-to-dump-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: parisc: use seq_hex_dump() to dump buffers

Instead of custom approach let's use recently introduced seq_hex_dump()
helper.

In one case it changes the output from
	1111111122222222333333334444444455555555666666667777777788888888
to
	11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888

though it seems it prints same data (by meaning) in both cases.  I decide
to choose to use the space divided one.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c  |   13 +++----------
 drivers/parisc/sba_iommu.c |    9 ++-------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~parisc-use-seq_hex_dump-to-dump-buffers drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~parisc-use-seq_hex_dump-to-dump-buffers
+++ a/drivers/parisc/ccio-dma.c
@@ -1103,16 +1103,9 @@ static int ccio_proc_bitmap_info(struct
 	struct ioc *ioc = ioc_list;
 
 	while (ioc != NULL) {
-		u32 *res_ptr = (u32 *)ioc->res_map;
-		int j;
-
-		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
-			if ((j & 7) == 0)
-				seq_puts(m, "\n   ");
-			seq_printf(m, "%08x", *res_ptr);
-			res_ptr++;
-		}
-		seq_puts(m, "\n\n");
+		seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
+			     ioc->res_size, false);
+		seq_putc(m, '\n');
 		ioc = ioc->next;
 		break; /* XXX - remove me */
 	}
diff -puN drivers/parisc/sba_iommu.c~parisc-use-seq_hex_dump-to-dump-buffers drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-use-seq_hex_dump-to-dump-buffers
+++ a/drivers/parisc/sba_iommu.c
@@ -1854,14 +1854,9 @@ sba_proc_bitmap_info(struct seq_file *m,
 {
 	struct sba_device *sba_dev = sba_list;
 	struct ioc *ioc = &sba_dev->ioc[0];	/* FIXME: Multi-IOC support! */
-	unsigned int *res_ptr = (unsigned int *)ioc->res_map;
-	int i;
 
-	for (i = 0; i < (ioc->res_size/sizeof(unsigned int)); ++i, ++res_ptr) {
-		if ((i & 7) == 0)
-			seq_puts(m, "\n   ");
-		seq_printf(m, " %08x", *res_ptr);
-	}
+	seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
+		     ioc->res_size, false);
 	seq_putc(m, '\n');
 
 	return 0;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch

