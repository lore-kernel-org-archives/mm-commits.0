From: akpm@linux-foundation.org
Subject: + parisc-remove-use-of-seq_printf-return-value.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:59:22 -0800
Message-ID: <54ebbeda.nsoVHOwg8VLmW5xR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbBWX7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:59:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     parisc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: parisc: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/ccio-dma.c  |   56 ++++++++++------------
 drivers/parisc/sba_iommu.c |   86 +++++++++++++++++------------------
 2 files changed, 69 insertions(+), 73 deletions(-)

diff -puN drivers/parisc/ccio-dma.c~parisc-remove-use-of-seq_printf-return-value drivers/parisc/ccio-dma.c
--- a/drivers/parisc/ccio-dma.c~parisc-remove-use-of-seq_printf-return-value
+++ a/drivers/parisc/ccio-dma.c
@@ -1021,7 +1021,6 @@ static struct hppa_dma_ops ccio_ops = {
 #ifdef CONFIG_PROC_FS
 static int ccio_proc_info(struct seq_file *m, void *p)
 {
-	int len = 0;
 	struct ioc *ioc = ioc_list;
 
 	while (ioc != NULL) {
@@ -1031,22 +1030,22 @@ static int ccio_proc_info(struct seq_fil
 		int j;
 #endif
 
-		len += seq_printf(m, "%s\n", ioc->name);
+		seq_printf(m, "%s\n", ioc->name);
 		
-		len += seq_printf(m, "Cujo 2.0 bug    : %s\n",
-				  (ioc->cujo20_bug ? "yes" : "no"));
+		seq_printf(m, "Cujo 2.0 bug    : %s\n",
+			   (ioc->cujo20_bug ? "yes" : "no"));
 		
-		len += seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
-			       total_pages * 8, total_pages);
+		seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
+			   total_pages * 8, total_pages);
 
 #ifdef CCIO_COLLECT_STATS
-		len += seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
-				  total_pages - ioc->used_pages, ioc->used_pages,
-				  (int)(ioc->used_pages * 100 / total_pages));
+		seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
+			   total_pages - ioc->used_pages, ioc->used_pages,
+			   (int)(ioc->used_pages * 100 / total_pages));
 #endif
 
-		len += seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n", 
-				  ioc->res_size, total_pages);
+		seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n",
+			   ioc->res_size, total_pages);
 
 #ifdef CCIO_COLLECT_STATS
 		min = max = ioc->avg_search[0];
@@ -1058,26 +1057,26 @@ static int ccio_proc_info(struct seq_fil
 				min = ioc->avg_search[j];
 		}
 		avg /= CCIO_SEARCH_SAMPLE;
-		len += seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
-				  min, avg, max);
+		seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
+			   min, avg, max);
 
-		len += seq_printf(m, "pci_map_single(): %8ld calls  %8ld pages (avg %d/1000)\n",
-				  ioc->msingle_calls, ioc->msingle_pages,
-				  (int)((ioc->msingle_pages * 1000)/ioc->msingle_calls));
+		seq_printf(m, "pci_map_single(): %8ld calls  %8ld pages (avg %d/1000)\n",
+			   ioc->msingle_calls, ioc->msingle_pages,
+			   (int)((ioc->msingle_pages * 1000)/ioc->msingle_calls));
 
 		/* KLUGE - unmap_sg calls unmap_single for each mapped page */
 		min = ioc->usingle_calls - ioc->usg_calls;
 		max = ioc->usingle_pages - ioc->usg_pages;
-		len += seq_printf(m, "pci_unmap_single: %8ld calls  %8ld pages (avg %d/1000)\n",
-				  min, max, (int)((max * 1000)/min));
+		seq_printf(m, "pci_unmap_single: %8ld calls  %8ld pages (avg %d/1000)\n",
+			   min, max, (int)((max * 1000)/min));
  
-		len += seq_printf(m, "pci_map_sg()    : %8ld calls  %8ld pages (avg %d/1000)\n",
-				  ioc->msg_calls, ioc->msg_pages,
-				  (int)((ioc->msg_pages * 1000)/ioc->msg_calls));
-
-		len += seq_printf(m, "pci_unmap_sg()  : %8ld calls  %8ld pages (avg %d/1000)\n\n\n",
-				  ioc->usg_calls, ioc->usg_pages,
-				  (int)((ioc->usg_pages * 1000)/ioc->usg_calls));
+		seq_printf(m, "pci_map_sg()    : %8ld calls  %8ld pages (avg %d/1000)\n",
+			   ioc->msg_calls, ioc->msg_pages,
+			   (int)((ioc->msg_pages * 1000)/ioc->msg_calls));
+
+		seq_printf(m, "pci_unmap_sg()  : %8ld calls  %8ld pages (avg %d/1000)\n\n\n",
+			   ioc->usg_calls, ioc->usg_pages,
+			   (int)((ioc->usg_pages * 1000)/ioc->usg_calls));
 #endif	/* CCIO_COLLECT_STATS */
 
 		ioc = ioc->next;
@@ -1101,7 +1100,6 @@ static const struct file_operations ccio
 
 static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 {
-	int len = 0;
 	struct ioc *ioc = ioc_list;
 
 	while (ioc != NULL) {
@@ -1110,11 +1108,11 @@ static int ccio_proc_bitmap_info(struct
 
 		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
 			if ((j & 7) == 0)
-				len += seq_puts(m, "\n   ");
-			len += seq_printf(m, "%08x", *res_ptr);
+				seq_puts(m, "\n   ");
+			seq_printf(m, "%08x", *res_ptr);
 			res_ptr++;
 		}
-		len += seq_puts(m, "\n\n");
+		seq_puts(m, "\n\n");
 		ioc = ioc->next;
 		break; /* XXX - remove me */
 	}
diff -puN drivers/parisc/sba_iommu.c~parisc-remove-use-of-seq_printf-return-value drivers/parisc/sba_iommu.c
--- a/drivers/parisc/sba_iommu.c~parisc-remove-use-of-seq_printf-return-value
+++ a/drivers/parisc/sba_iommu.c
@@ -1774,37 +1774,35 @@ static int sba_proc_info(struct seq_file
 #ifdef SBA_COLLECT_STATS
 	unsigned long avg = 0, min, max;
 #endif
-	int i, len = 0;
+	int i;
 
-	len += seq_printf(m, "%s rev %d.%d\n",
-		sba_dev->name,
-		(sba_dev->hw_rev & 0x7) + 1,
-		(sba_dev->hw_rev & 0x18) >> 3
-		);
-	len += seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
-		(int) ((ioc->res_size << 3) * sizeof(u64)), /* 8 bits/byte */
-		total_pages);
-
-	len += seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n", 
-		ioc->res_size, ioc->res_size << 3);   /* 8 bits per byte */
-
-	len += seq_printf(m, "LMMIO_BASE/MASK/ROUTE %08x %08x %08x\n",
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_BASE),
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_MASK),
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_ROUTE)
-		);
+	seq_printf(m, "%s rev %d.%d\n",
+		   sba_dev->name,
+		   (sba_dev->hw_rev & 0x7) + 1,
+		   (sba_dev->hw_rev & 0x18) >> 3);
+	seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
+		   (int)((ioc->res_size << 3) * sizeof(u64)), /* 8 bits/byte */
+		   total_pages);
+
+	seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n",
+		   ioc->res_size, ioc->res_size << 3);   /* 8 bits per byte */
+
+	seq_printf(m, "LMMIO_BASE/MASK/ROUTE %08x %08x %08x\n",
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_BASE),
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_MASK),
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_ROUTE));
 
 	for (i=0; i<4; i++)
-		len += seq_printf(m, "DIR%d_BASE/MASK/ROUTE %08x %08x %08x\n", i,
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_BASE  + i*0x18),
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_MASK  + i*0x18),
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_ROUTE + i*0x18)
-		);
+		seq_printf(m, "DIR%d_BASE/MASK/ROUTE %08x %08x %08x\n",
+			   i,
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_BASE  + i*0x18),
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_MASK  + i*0x18),
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_ROUTE + i*0x18));
 
 #ifdef SBA_COLLECT_STATS
-	len += seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
-		total_pages - ioc->used_pages, ioc->used_pages,
-		(int) (ioc->used_pages * 100 / total_pages));
+	seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
+		   total_pages - ioc->used_pages, ioc->used_pages,
+		   (int)(ioc->used_pages * 100 / total_pages));
 
 	min = max = ioc->avg_search[0];
 	for (i = 0; i < SBA_SEARCH_SAMPLE; i++) {
@@ -1813,26 +1811,26 @@ static int sba_proc_info(struct seq_file
 		if (ioc->avg_search[i] < min) min = ioc->avg_search[i];
 	}
 	avg /= SBA_SEARCH_SAMPLE;
-	len += seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
-		min, avg, max);
+	seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
+		   min, avg, max);
 
-	len += seq_printf(m, "pci_map_single(): %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->msingle_calls, ioc->msingle_pages,
-		(int) ((ioc->msingle_pages * 1000)/ioc->msingle_calls));
+	seq_printf(m, "pci_map_single(): %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->msingle_calls, ioc->msingle_pages,
+		   (int)((ioc->msingle_pages * 1000)/ioc->msingle_calls));
 
 	/* KLUGE - unmap_sg calls unmap_single for each mapped page */
 	min = ioc->usingle_calls;
 	max = ioc->usingle_pages - ioc->usg_pages;
-	len += seq_printf(m, "pci_unmap_single: %12ld calls  %12ld pages (avg %d/1000)\n",
-		min, max, (int) ((max * 1000)/min));
+	seq_printf(m, "pci_unmap_single: %12ld calls  %12ld pages (avg %d/1000)\n",
+		   min, max, (int)((max * 1000)/min));
 
-	len += seq_printf(m, "pci_map_sg()    : %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->msg_calls, ioc->msg_pages, 
-		(int) ((ioc->msg_pages * 1000)/ioc->msg_calls));
-
-	len += seq_printf(m, "pci_unmap_sg()  : %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->usg_calls, ioc->usg_pages,
-		(int) ((ioc->usg_pages * 1000)/ioc->usg_calls));
+	seq_printf(m, "pci_map_sg()    : %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->msg_calls, ioc->msg_pages,
+		   (int)((ioc->msg_pages * 1000)/ioc->msg_calls));
+
+	seq_printf(m, "pci_unmap_sg()  : %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->usg_calls, ioc->usg_pages,
+		   (int)((ioc->usg_pages * 1000)/ioc->usg_calls));
 #endif
 
 	return 0;
@@ -1858,14 +1856,14 @@ sba_proc_bitmap_info(struct seq_file *m,
 	struct sba_device *sba_dev = sba_list;
 	struct ioc *ioc = &sba_dev->ioc[0];	/* FIXME: Multi-IOC support! */
 	unsigned int *res_ptr = (unsigned int *)ioc->res_map;
-	int i, len = 0;
+	int i;
 
 	for (i = 0; i < (ioc->res_size/sizeof(unsigned int)); ++i, ++res_ptr) {
 		if ((i & 7) == 0)
-			len += seq_printf(m, "\n   ");
-		len += seq_printf(m, " %08x", *res_ptr);
+			seq_puts(m, "\n   ");
+		seq_printf(m, " %08x", *res_ptr);
 	}
-	len += seq_printf(m, "\n");
+	seq_putc(m, '\n');
 
 	return 0;
 }
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

