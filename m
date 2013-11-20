From: akpm@linux-foundation.org
Subject: + block-partitions-efic-fix-bound-check.patch added to -mm tree
Date: Tue, 19 Nov 2013 16:04:58 -0800
Message-ID: <528bfcaa.RZrSl/r30keHczcC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3KTAE7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 19:04:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wad@chromium.org, matt.fleming@intel.com, hdoyu@nvidia.com, amiettinen@nvidia.com

Subject: + block-partitions-efic-fix-bound-check.patch added to -mm tree
To: amiettinen@nvidia.com,hdoyu@nvidia.com,matt.fleming@intel.com,wad@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 16:04:58 -0800


The patch titled
     Subject: block/partitions/efi.c: fix bound check
has been added to the -mm tree.  Its filename is
     block-partitions-efic-fix-bound-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-partitions-efic-fix-bound-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-partitions-efic-fix-bound-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Antti P Miettinen <amiettinen@nvidia.com>
Subject: block/partitions/efi.c: fix bound check

Use ARRAY_SIZE instead of sizeof to get proper max for label length.

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Will Drewry <wad@chromium.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN block/partitions/efi.c~block-partitions-efic-fix-bound-check block/partitions/efi.c
--- a/block/partitions/efi.c~block-partitions-efic-fix-bound-check
+++ a/block/partitions/efi.c
@@ -96,6 +96,7 @@
  * - Code works, detects all the partitions.
  *
  ************************************************************/
+#include <linux/kernel.h>
 #include <linux/crc32.h>
 #include <linux/ctype.h>
 #include <linux/math64.h>
@@ -715,8 +716,8 @@ int efi_partition(struct parsed_partitio
 		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
-		label_max = min(sizeof(info->volname) - 1,
-				sizeof(ptes[i].partition_name));
+		label_max = min(ARRAY_SIZE(info->volname) - 1,
+				ARRAY_SIZE(ptes[i].partition_name));
 		info->volname[label_max] = 0;
 		while (label_count < label_max) {
 			u8 c = ptes[i].partition_name[label_count] & 0xff;
_

Patches currently in -mm which might be from amiettinen@nvidia.com are

block-partitions-efic-fix-bound-check.patch

