From: akpm@linux-foundation.org
Subject: - ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate.patch removed from -mm tree
Date: Fri, 01 Jun 2007 00:07:18 -0700
Message-ID: <200706010707.l5177HCs004773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459AbXFAHHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 03:07:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     RAMFS NOMMU: a bug in ramfs_nommu_resize function, passing old size to vmtruncate
has been removed from the -mm tree.  Its filename was
     ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RAMFS NOMMU: a bug in ramfs_nommu_resize function, passing old size to vmtruncate
From: Bryan Wu <bryan.wu@analog.com>

It should pass "newsize" to vmtruncate function to modify the
inode->i_size, while the old size is passed to vmtruncate.

This bug was caught by LTP truncate test case on Blackfin platform.  After
it was fixed, the LTP truncate test case passed.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/file-nommu.c~ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~ramfs-nommu-a-bug-in-ramfs_nommu_resize-function-passing-old-size-to-vmtruncate
+++ a/fs/ramfs/file-nommu.c
@@ -179,7 +179,7 @@ static int ramfs_nommu_resize(struct ino
 			return ret;
 	}
 
-	ret = vmtruncate(inode, size);
+	ret = vmtruncate(inode, newsize);
 
 	return ret;
 }
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
lots-of-architectures-enable-arbitary-speed-tty-support.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
blackfin-enable-arbitary-speed-serial-setting.patch
