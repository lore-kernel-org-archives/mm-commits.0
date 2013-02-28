From: akpm@linux-foundation.org
Subject: [merged] ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:16:41 -0800
Message-ID: <20130228201641.C897231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60736 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab3B1UQm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:16:42 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246821yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:16:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pjones@redhat.com, axboe@kernel.dk, matt.fleming@intel.com, swarren@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block/partitions/efi.c: ensure that the GPT header is at least the size of the structure.
has been removed from the -mm tree.  Its filename was
     ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Jones <pjones@redhat.com>
Subject: block/partitions/efi.c: ensure that the GPT header is at least the size of the structure.

UEFI 2.3.1D will include a change to the spec language mandating that a
GPT header must be greater than *or equal to* the size of the defined
structure.  While verifying that this would work on Linux, I discovered
that we're not actually checking the minimum bound at all.

The result of this is that when we verify the checksum, it's possible that
on a malformed header (with header_size of 0), we won't actually verify
any data.

[akpm@linux-foundation.org: fix printk warning]
Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN block/partitions/efi.c~ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure block/partitions/efi.c
--- a/block/partitions/efi.c~ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure
+++ a/block/partitions/efi.c
@@ -310,15 +310,23 @@ static int is_gpt_valid(struct parsed_pa
 		goto fail;
 	}
 
-	/* Check the GUID Partition Table header size */
+	/* Check the GUID Partition Table header size is too big */
 	if (le32_to_cpu((*gpt)->header_size) >
 			bdev_logical_block_size(state->bdev)) {
-		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
+		pr_debug("GUID Partition Table Header size is too large: %u > %u\n",
 			le32_to_cpu((*gpt)->header_size),
 			bdev_logical_block_size(state->bdev));
 		goto fail;
 	}
 
+	/* Check the GUID Partition Table header size is too small */
+	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
+		pr_debug("GUID Partition Table Header size is too small: %u < %zu\n",
+			le32_to_cpu((*gpt)->header_size),
+			sizeof(gpt_header));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
_

Patches currently in -mm which might be from pjones@redhat.com are

origin.patch

