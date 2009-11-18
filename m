From: akpm@linux-foundation.org
Subject: + partitions-use-sector-size-for-efi-gpt-fix.patch added to -mm tree
Date: Wed, 18 Nov 2009 12:09:45 -0800
Message-ID: <200911182009.nAIK9jDM015899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758281AbZKRUKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 15:10:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kzak@redhat.com, jens.axboe@oracle.com, randy.dunlap@oracle.com


The patch titled
     partitions-use-sector-size-for-efi-gpt-fix
has been added to the -mm tree.  Its filename is
     partitions-use-sector-size-for-efi-gpt-fix.patch

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

partitions-use-sector-size-for-efi-gpt.patch
partitions-use-sector-size-for-efi-gpt-fix.patch
partitions-read-whole-sector-with-efi-gpt-header.patch

