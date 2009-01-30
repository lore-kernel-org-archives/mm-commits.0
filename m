From: akpm@linux-foundation.org
Subject: [to-be-updated] libata-sff-32bit-pio-use-16bit-on-slop.patch removed from -mm tree
Date: Fri, 30 Jan 2009 09:10:59 -0800
Message-ID: <200901301710.n0UHAxg3003354@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbZA3RLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 12:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     libata sff: 32bit PIO use 16bit on slop
has been removed from the -mm tree.  Its filename was
     libata-sff-32bit-pio-use-16bit-on-slop.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata sff: 32bit PIO use 16bit on slop
From: Hugh Dickins <hugh@veritas.com>

871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
causes errors on a four-year-old ata_piix Dell Precision 670.  Using 16bit
PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata-sff.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/ata/libata-sff.c~libata-sff-32bit-pio-use-16bit-on-slop drivers/ata/libata-sff.c
--- a/drivers/ata/libata-sff.c~libata-sff-32bit-pio-use-16bit-on-slop
+++ a/drivers/ata/libata-sff.c
@@ -774,17 +774,21 @@ unsigned int ata_sff_data_xfer32(struct 
 		iowrite32_rep(data_addr, buf, words);
 
 	if (unlikely(slop)) {
-		__le32 pad;
+		unsigned char slop_buf[4];
+		unsigned char *trailing_buf = buf + buflen - slop;
+
+		words = (slop + 1) >> 1;
 		if (rw == READ) {
-			pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
-			memcpy(buf + buflen - slop, &pad, slop);
+			ioread16_rep(data_addr, slop_buf, words);
+			memcpy(trailing_buf, slop_buf, slop);
 		} else {
-			memcpy(&pad, buf + buflen - slop, slop);
-			iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
+			memcpy(slop_buf, trailing_buf, slop);
+			slop_buf[slop] = 0;
+			iowrite16_rep(data_addr, slop_buf, words);
 		}
-		words++;
 	}
-	return words << 2;
+
+	return buflen + (slop & 1);
 }
 EXPORT_SYMBOL_GPL(ata_sff_data_xfer32);
 
_

Patches currently in -mm which might be from hugh@veritas.com are

shm-fix-shmctlshm_info-lockup-with-config_shmem.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-mmapc-avoid-referencing-a-freed-vma-in-mmap_region.patch
libata-sff-32bit-pio-use-16bit-on-slop.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
mm-shmemc-fix-division-by-zero.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

