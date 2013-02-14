From: akpm@linux-foundation.org
Subject: + ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch added to -mm tree
Date: Thu, 14 Feb 2013 12:53:29 -0800
Message-ID: <20130214205329.B0C1D5A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:62161 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934977Ab3BNUxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 15:53:31 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so285793yen.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 12:53:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pjones@redhat.com, axboe@kernel.dk, matt.fleming@intel.com, swarren@nvidia.com


The patch titled
     Subject: block/partitions/efi.c: ensure that the GPT header is at least the size of the structure.
has been added to the -mm tree.  Its filename is
     ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
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

ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch

