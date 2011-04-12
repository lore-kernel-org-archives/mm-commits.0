From: akpm@linux-foundation.org
Subject: + fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch added to -mm tree
Date: Tue, 12 Apr 2011 13:53:16 -0700
Message-ID: <201104122053.p3CKrG0M002146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227Ab1DLUyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Apr 2011 16:54:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Warns@pre-sense.de, Matt_Domsch@dell.com, davej@codemonkey.org.uk, eugeneteo@kernel.sg, warns@pre-sense.de


The patch titled
     fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
has been added to the -mm tree.  Its filename is
     fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

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
+	if (le32_to_cpu((*gpt)->header_size) > bdev_logical_block_size(state->bdev)) {
+		pr_debug("GUID Partition Table Header size is wrong:"
+			 "%u > %u\n",
+             le32_to_cpu((*gpt)->header_size),
+             bdev_logical_block_size(state->bdev));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
_

Patches currently in -mm which might be from Warns@pre-sense.de are

fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch

