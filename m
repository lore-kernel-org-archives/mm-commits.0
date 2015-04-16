From: akpm@linux-foundation.org
Subject: [merged] parisc-remove-use-of-seq_printf-return-value.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:43 -0700
Message-ID: <552fe98f./u5P9Jo6NYpt1ibR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43215 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbDPQuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     parisc-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

