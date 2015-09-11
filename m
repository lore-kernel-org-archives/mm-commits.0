From: akpm@linux-foundation.org
Subject: [merged] crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:13:04 -0700
Message-ID: <55f319b0.htzB1R2geC1FviM1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53965 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbbIKSNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, catalin.marinas@arm.com, deller@gmx.de, ingo.tuchscherer@de.ibm.com, joe@perches.com, qca_vkondrat@qca.qualcomm.com, tadeusz.struk@intel.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/crypto/qat: use seq_hex_dump() to dump buffers
has been removed from the -mm tree.  Its filename was
     crypto-qat-use-seq_hex_dump-to-dump-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: drivers/crypto/qat: use seq_hex_dump() to dump buffers

Instead of custom approach let's use recently introduced seq_hex_dump()
helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Joe Perches <joe@perches.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/qat/qat_common/adf_transport_debug.c |   16 +---------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff -puN drivers/crypto/qat/qat_common/adf_transport_debug.c~crypto-qat-use-seq_hex_dump-to-dump-buffers drivers/crypto/qat/qat_common/adf_transport_debug.c
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c~crypto-qat-use-seq_hex_dump-to-dump-buffers
+++ a/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -86,9 +86,7 @@ static int adf_ring_show(struct seq_file
 {
 	struct adf_etr_ring_data *ring = sfile->private;
 	struct adf_etr_bank_data *bank = ring->bank;
-	uint32_t *msg = v;
 	void __iomem *csr = ring->bank->csr_addr;
-	int i, x;
 
 	if (v == SEQ_START_TOKEN) {
 		int head, tail, empty;
@@ -113,18 +111,8 @@ static int adf_ring_show(struct seq_file
 		seq_puts(sfile, "----------- Ring data ------------\n");
 		return 0;
 	}
-	seq_printf(sfile, "%p:", msg);
-	x = 0;
-	i = 0;
-	for (; i < (ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2); i++) {
-		seq_printf(sfile, " %08X", *(msg + i));
-		if ((ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2) != i + 1 &&
-		    (++x == 8)) {
-			seq_printf(sfile, "\n%p:", msg + i + 1);
-			x = 0;
-		}
-	}
-	seq_puts(sfile, "\n");
+	seq_hex_dump(sfile, "", DUMP_PREFIX_ADDRESS, 32, 4,
+		     v, ADF_MSG_SIZE_TO_BYTES(ring->msg_size), false);
 	return 0;
 }
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


