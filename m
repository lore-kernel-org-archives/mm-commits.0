From: akpm@linux-foundation.org
Subject: [folded-merged] dax-add-support-for-fsync-sync-v6-fix.patch
 removed from -mm tree
Date: Fri, 22 Jan 2016 14:57:52 -0800
Message-ID: <56a2b3f0.whjnxkGdZM5rbLcd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbcAVW5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jan 2016 17:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix dax_pmd_dbg build warning
has been removed from the -mm tree.  Its filename was
     dax-add-support-for-fsync-sync-v6-fix.patch

This patch was dropped because it was folded into dax-add-support-for-fsync-sync.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: dax: fix dax_pmd_dbg build warning

Fixes below warning from commit 3cb108f941deb
"dax-add-support-for-fsync-sync-v6" in -next.

    fs/dax.c: In function `__dax_pmd_fault':
    fs/dax.c:916:15: warning: passing argument 1 of `__dax_dbg' from incompatible pointer type
         dax_pmd_dbg(bdev, address,
                   ^
    fs/dax.c:738:13: note: expected `struct buffer_head *' but argument is of type `struct block_device *'
     static void __dax_dbg(struct buffer_head *bh, unsigned long address,

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dax.c~dax-add-support-for-fsync-sync-v6-fix fs/dax.c
--- a/fs/dax.c~dax-add-support-for-fsync-sync-v6-fix
+++ a/fs/dax.c
@@ -914,7 +914,7 @@ int __dax_pmd_fault(struct vm_area_struc
 			error = dax_radix_entry(mapping, pgoff, dax.sector,
 					true, true);
 			if (error) {
-				dax_pmd_dbg(bdev, address,
+				dax_pmd_dbg(&bh, address,
 						"PMD radix insertion failed");
 				goto fallback;
 			}
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync.patch

