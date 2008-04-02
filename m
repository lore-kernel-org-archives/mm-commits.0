From: akpm@linux-foundation.org
Subject: - tulip-tulip_read_eeprom-fixes-for-bug-4420.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:23 -0700
Message-ID: <200804021920.m32JKNO9030265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbYDBT2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grundler@parisc-linux.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     tulip: tulip_read_eeprom() fixes for BUG 4420
has been removed from the -mm tree.  Its filename was
     tulip-tulip_read_eeprom-fixes-for-bug-4420.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tulip: tulip_read_eeprom() fixes for BUG 4420
From: Grant Grundler <grundler@parisc-linux.org>

If "location" is > "addr_len" bits, the high bits of location would interfere
with the READ_CMD sent to the eeprom controller.

A patch was submitted to bug:
    http://bugzilla.kernel.org/show_bug.cgi?id=4420

which simply truncated the "location", read whatever was in "location modulo
addr_len", and returned that value.  That avoids confusing the eeprom but
seems like the wrong solution to me.

Correct would be to not read beyond "1 << addr_len" address of the eeprom.
I am submitting two changes to implement this:

1) tulip_read_eeprom will return zero (since we can't return -EINVAL)
   if this is attempted (defensive programming).

2) In tulip_core.c, fix the tulip_read_eeprom caller so they don't
   iterate past addr_len bits and make sure the entire tp->eeprom[]
   array is cleared.

I know we don't strictly need both.  I would prefer both in the tree since it
documents the issue and provides a second "defense" from the bug from creeping
back in.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Grant Grundler <grundler@parisc-linux.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/eeprom.c     |    6 ++++++
 drivers/net/tulip/tulip_core.c |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN drivers/net/tulip/eeprom.c~tulip-tulip_read_eeprom-fixes-for-bug-4420 drivers/net/tulip/eeprom.c
--- a/drivers/net/tulip/eeprom.c~tulip-tulip_read_eeprom-fixes-for-bug-4420
+++ a/drivers/net/tulip/eeprom.c
@@ -343,6 +343,12 @@ int __devinit tulip_read_eeprom(struct n
 	void __iomem *ee_addr = tp->base_addr + CSR9;
 	int read_cmd = location | (EE_READ_CMD << addr_len);
 
+	/* If location is past the end of what we can address, don't
+	 * read some other location (ie truncate). Just return zero.
+	 */
+	if (location > (1 << addr_len) - 1)
+		return 0;
+
 	iowrite32(EE_ENB & ~EE_CS, ee_addr);
 	iowrite32(EE_ENB, ee_addr);
 
diff -puN drivers/net/tulip/tulip_core.c~tulip-tulip_read_eeprom-fixes-for-bug-4420 drivers/net/tulip/tulip_core.c
--- a/drivers/net/tulip/tulip_core.c~tulip-tulip_read_eeprom-fixes-for-bug-4420
+++ a/drivers/net/tulip/tulip_core.c
@@ -1437,6 +1437,7 @@ static int __devinit tulip_init_one (str
 	   EEPROM.
 	   */
 	ee_data = tp->eeprom;
+	memset(ee_data, 0, sizeof(tp->eeprom));
 	sum = 0;
 	if (chip_idx == LC82C168) {
 		for (i = 0; i < 3; i++) {
@@ -1458,8 +1459,12 @@ static int __devinit tulip_init_one (str
 		/* A serial EEPROM interface, we read now and sort it out later. */
 		int sa_offset = 0;
 		int ee_addr_size = tulip_read_eeprom(dev, 0xff, 8) & 0x40000 ? 8 : 6;
+		int ee_max_addr = ((1 << ee_addr_size) - 1) * sizeof(u16);
 
-		for (i = 0; i < sizeof(tp->eeprom); i+=2) {
+		if (ee_max_addr > sizeof(tp->eeprom))
+			ee_max_addr = sizeof(tp->eeprom);
+
+		for (i = 0; i < ee_max_addr ; i += sizeof(u16)) {
 			u16 data = tulip_read_eeprom(dev, i/2, ee_addr_size);
 			ee_data[i] = data & 0xff;
 			ee_data[i + 1] = data >> 8;
_

Patches currently in -mm which might be from grundler@parisc-linux.org are

origin.patch
parisc-new-termios-definitions.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
pci-iommu-iotlb-flushing-speedup.patch
dma-add-dma_map_attrs-interfaces.patch
dma-document-dma_map_attrs-interfaces.patch
dma-ia64-update-ia64-machvecs-swiotlbc.patch
ib-expand-ib_umem_get-prototype.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

