From: akpm@linux-foundation.org
Subject: [merged] block-partitions-efic-fix-bound-check.patch removed from -mm tree
Date: Fri, 22 Nov 2013 13:21:57 -0800
Message-ID: <528fcaf5.9/ZW7LJV83Pmdk+C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3KVVWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wad@chromium.org, matt.fleming@intel.com, hdoyu@nvidia.com, davidlohr@hp.com, amiettinen@nvidia.com

Subject: [merged] block-partitions-efic-fix-bound-check.patch removed from -mm tree
To: amiettinen@nvidia.com,davidlohr@hp.com,hdoyu@nvidia.com,matt.fleming@intel.com,wad@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:57 -0800


The patch titled
     Subject: block/partitions/efi.c: fix bound check
has been removed from the -mm tree.  Its filename was
     block-partitions-efic-fix-bound-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Antti P Miettinen <amiettinen@nvidia.com>
Subject: block/partitions/efi.c: fix bound check

Use ARRAY_SIZE instead of sizeof to get proper max for label length.

Since this is just a read out of bounds it's not that bad, but the problem
becomes user-visible e.g.  if one tries to use CONFIG_DEBUG_PAGEALLOC and
CONFIG_DEBUG_RODATA, at least with some enhancements from Hiroshi.  Of
course the destination array can contain garbage when we read beyond the
end of source array so that would be another user-visible problem.

Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Will Drewry <wad@chromium.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
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

origin.patch

