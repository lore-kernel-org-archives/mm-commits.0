From: akpm@linux-foundation.org
Subject: [alternative-merged]
 afs-proc-cells-and-rootcell-are-writeable.patch removed from -mm tree
Date: Mon, 03 Feb 2014 12:16:24 -0800
Message-ID: <52eff918.c3LRSazy/alhzpyQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaBCUQZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 15:16:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, dhowells@redhat.com, pali.rohar@gmail.com

Subject: [alternative-merged] afs-proc-cells-and-rootcell-are-writeable.patch removed from -mm tree
To: pali.rohar@gmail.com,dhowells@redhat.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 12:16:24 -0800


The patch titled
     Subject: afs: proc cells and rootcell are writeable
has been removed from the -mm tree.  Its filename was
     afs-proc-cells-and-rootcell-are-writeable.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Pali Rohár <pali.rohar@gmail.com>
Subject: afs: proc cells and rootcell are writeable

Both proc files are writeable and used for configuring cells. But
there is missing correct mode flag for writeable files.

Without this patch it is not possible to write to cells and rootcell files
which means that it is not possible to add new servers to cells, so it is
not possible to access afs disks and afs driver is unusable.

Signed-off-by: Pali Rohr <pali.rohar@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/afs/proc.c~afs-proc-cells-and-rootcell-are-writeable fs/afs/proc.c
--- a/fs/afs/proc.c~afs-proc-cells-and-rootcell-are-writeable
+++ a/fs/afs/proc.c
@@ -130,8 +130,10 @@ int afs_proc_init(void)
 	if (!proc_afs)
 		goto error_dir;
 
-	if (!proc_create("cells", 0, proc_afs, &afs_proc_cells_fops) ||
-	    !proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops))
+	if (!proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs,
+			 &afs_proc_cells_fops) ||
+	    !proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs,
+			 &afs_proc_rootcell_fops))
 		goto error_tree;
 
 	_leave(" = 0");
_

Patches currently in -mm which might be from pali.rohar@gmail.com are


