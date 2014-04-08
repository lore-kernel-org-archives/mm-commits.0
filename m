From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-remove-unused-ufs_super_block_third-pointer.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:54:41 -0700
Message-ID: <53447021.Y6UB5V8hMx4tKi/Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753AbaDHVyl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:54:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, cengelma@gmx.at

Subject: [merged] fs-ufs-remove-unused-ufs_super_block_third-pointer.patch removed from -mm tree
To: cengelma@gmx.at,dushistov@mail.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:54:41 -0700


The patch titled
     Subject: fs/ufs: remove unused ufs_super_block_third pointer
has been removed from the -mm tree.  Its filename was
     fs-ufs-remove-unused-ufs_super_block_third-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Engelmayer <cengelma@gmx.at>
Subject: fs/ufs: remove unused ufs_super_block_third pointer

Pointer 'usb3' to struct ufs_super_block_third acquired via
ubh_get_usb_third() is never used in function
ufs_read_cylinder_structures(= ).  Thus remove it.

Detected by Coverity: CID 139939.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_third-pointer fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-remove-unused-ufs_super_block_third-pointer
+++ a/fs/ufs/super.c
@@ -524,11 +524,9 @@ static int ufs_read_cylinder_structures(
 	struct ufs_buffer_head * ubh;
 	unsigned char * base, * space;
 	unsigned size, blks, i;
-	struct ufs_super_block_third *usb3;
 
 	UFSD("ENTER\n");
 
-	usb3 = ubh_get_usb_third(uspi);
 	/*
 	 * Read cs structures from (usually) first data block
 	 * on the device. 
_

Patches currently in -mm which might be from cengelma@gmx.at are

origin.patch

