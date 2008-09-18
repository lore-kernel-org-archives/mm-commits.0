From: akpm@linux-foundation.org
Subject: - libata-fix-lba28-lba48-off-by-one-bug-in-atah.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:38 -0700
Message-ID: <200809182056.m8IKuc8l019202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755234AbYIRU6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tai@rakugaki.org, alan@redhat.com, greg.freemyer@gmail.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     libata: fix LBA28/LBA48 off-by-one bug in ata.h
has been removed from the -mm tree.  Its filename was
     libata-fix-lba28-lba48-off-by-one-bug-in-atah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libata: fix LBA28/LBA48 off-by-one bug in ata.h
From: Taisuke Yamada <tai@rakugaki.org>

I recently bought 3 HGST P7K500-series 500GB SATA drives and had trouble
accessing the block right on the LBA28-LBA48 border.  Here's how it fails
(same for all 3 drives):

  # dd if=/dev/sdc bs=512 count=1 skip=268435455 > /dev/null
  dd: reading `/dev/sdc': Input/output error
  0+0 records in
  0+0 records out
  0 bytes (0 B) copied, 0.288033 seconds, 0.0 kB/s
  # dmesg
  ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
  ata1.00: BMDMA stat 0x25
  ata1.00: cmd c8/00:08:f8:ff:ff/00:00:00:00:00/ef tag 0 dma 4096 in
  res 51/04:08:f8:ff:ff/00:00:00:00:00/ef Emask 0x1 (device error)
  ata1.00: status: { DRDY ERR }
  ata1.00: error: { ABRT }
  ata1.00: configured for UDMA/33
  ata1: EH complete
  ...

After some investigations, it turned out this seems to be caused by
misinterpretation of the ATA specification on LBA28 access.  Following
part is the code in question:

  === include/linux/ata.h ===
  static inline int lba_28_ok(u64 block, u32 n_block)
  {
    /* check the ending block number */
    return ((block + n_block - 1) < ((u64)1 << 28)) && (n_block <= 256);
  }

HGST drive (sometimes) fails with LBA28 access of {block = 0xfffffff,
n_block = 1}, and this behavior seems to be comformant.  Other drives,
including other HGST drives are not that strict, through.

The ATA specification:
(http://www.t13.org/Documents/UploadedDocuments/project/d1410r3b-ATA-ATAPI-6.pdf)

  8.15.29  Word (61:60): Total number of user addressable sectors
  This field contains a value that is one greater than the total number
  of user addressable sectors (see 6.2). The maximum value that shall
  be placed in this field is 0FFFFFFFh.

So the driver shouldn't use the value of 0xfffffff for LBA28 request as
this exceeds maximum user addressable sector.  The logical maximum value
for LBA28 is 0xffffffe.

The obvious fix is to cut "- 1" part, and the patch attached just do that.
 I've been using the patched kernel for about a month now, and the same
fix is also floating on the net for some time.  So I believe this fix
works reliably.

Just FYI, many Windows/Intel platform users also seems to be struck
by this, and HGST has issued a note pointing to Intel ICH8/9 driver.

  "28-bit LBA command is being used to access LBAs 29-bits in length"
http://www.hitachigst.com/hddt/knowtree.nsf/cffe836ed7c12018862565b000530c74/b531b8bce8745fb78825740f00580e23

Also, *BSDs seems to have similar fix included sometime around ~2004,
through I have not checked out exact portion of the code.

Cc: "Greg Freemyer" <greg.freemyer@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/ata.h~libata-fix-lba28-lba48-off-by-one-bug-in-atah include/linux/ata.h
--- a/include/linux/ata.h~libata-fix-lba28-lba48-off-by-one-bug-in-atah
+++ a/include/linux/ata.h
@@ -855,7 +855,7 @@ static inline int ata_ok(u8 status)
 static inline int lba_28_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number */
-	return ((block + n_block - 1) < ((u64)1 << 28)) && (n_block <= 256);
+	return ((block + n_block) < ((u64)1 << 28)) && (n_block <= 256);
 }
 
 static inline int lba_48_ok(u64 block, u32 n_block)
_

Patches currently in -mm which might be from tai@rakugaki.org are

origin.patch

