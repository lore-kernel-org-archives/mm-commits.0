From: akpm@linux-foundation.org
Subject: [merged] fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:59 -0700
Message-ID: <201105271957.p4RJv5wg017634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab1E0UON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:14:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Warns@pre-sense.de, Matt_Domsch@dell.com, davej@codemonkey.org.uk, eugeneteo@kernel.sg, warns@pre-sense.de, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
has been removed from the -mm tree.  Its filename was
     fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
From: Timo Warns <Warns@pre-sense.de>

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating GUID partitions (in fs/partitions/efi.c) contains
a bug that causes a kernel oops on certain corrupted GUID partition
tables.

This bug has security impacts, because it allows, for example, to
prepare a storage device that crashes a kernel subsystem upon connecting
the device (e.g., a "USB Stick of (Partial) Death").

	crc = efi_crc32((const unsigned char *) (*gpt), le32_to_cpu((*gpt)->header_size));

computes a CRC32 checksum over gpt covering (*gpt)->header_size bytes. 
There is no validation of (*gpt)->header_size before the efi_crc32 call.

A corrupted partition table may have large values for (*gpt)->header_size.
 In this case, the CRC32 computation access memory beyond the memory
allocated for gpt, which may cause a kernel heap overflow.

Validate value of GUID partition table header size.

[akpm@linux-foundation.org: fix layout and indenting]
Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/partitions/efi.c~fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops fs/partitions/efi.c
--- a/fs/partitions/efi.c~fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops
+++ a/fs/partitions/efi.c
@@ -310,6 +310,15 @@ static int is_gpt_valid(struct parsed_pa
 		goto fail;
 	}
 
+	/* Check the GUID Partition Table header size */
+	if (le32_to_cpu((*gpt)->header_size) >
+			bdev_logical_block_size(state->bdev)) {
+		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
+			le32_to_cpu((*gpt)->header_size),
+			bdev_logical_block_size(state->bdev));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
_

Patches currently in -mm which might be from Warns@pre-sense.de are

origin.patch

