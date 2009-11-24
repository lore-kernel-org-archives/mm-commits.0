From: akpm@linux-foundation.org
Subject: [merged] partitions-use-sector-size-for-efi-gpt-fix.patch removed from -mm tree
Date: Tue, 24 Nov 2009 11:19:19 -0800
Message-ID: <200911241919.nAOJJJnY021477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758160AbZKXTTd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:19:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kzak@redhat.com, jens.axboe@oracle.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     partitions-use-sector-size-for-efi-gpt-fix
has been removed from the -mm tree.  Its filename was
     partitions-use-sector-size-for-efi-gpt-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: partitions-use-sector-size-for-efi-gpt-fix
From: Karel Zak <kzak@redhat.com>

On Sun, Nov 15, 2009 at 10:46:31AM -0800, Randy Dunlap wrote:
> on i386 builds:
>
> fs/built-in.o: In function `last_lba':
> efi.c:(.text+0x9d9fe): undefined reference to `__divdi3'
>
>
> -       return (bdev->bd_inode->i_size >> 9) - 1ULL;
> +       return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;

 Ah.. I guess that div_u64() is more portable.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/partitions/efi.c~partitions-use-sector-size-for-efi-gpt-fix fs/partitions/efi.c
--- a/fs/partitions/efi.c~partitions-use-sector-size-for-efi-gpt-fix
+++ a/fs/partitions/efi.c
@@ -94,6 +94,7 @@
  *
  ************************************************************/
 #include <linux/crc32.h>
+#include <linux/math64.h>
 #include "check.h"
 #include "efi.h"
 
@@ -143,7 +144,8 @@ last_lba(struct block_device *bdev)
 {
 	if (!bdev || !bdev->bd_inode)
 		return 0;
-	return (bdev->bd_inode->i_size / bdev_logical_block_size(bdev)) - 1ULL;
+	return div_u64(bdev->bd_inode->i_size,
+		       bdev_logical_block_size(bdev)) - 1ULL;
 }
 
 static inline int
_

Patches currently in -mm which might be from kzak@redhat.com are

linux-next.patch

