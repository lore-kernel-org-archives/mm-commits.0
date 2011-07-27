From: akpm@linux-foundation.org
Subject: [merged] procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:36 -0700
Message-ID: <201107271927.p6RJRMks003208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754359Ab1G0T2C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ogino.daisuke@jp.fujitsu.com, adobriyan@gmail.com, hch@lst.de, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     procfs: return ENOENT on opening a being-removed proc entry
has been removed from the -mm tree.  Its filename was
     procfs-return-enoent-on-opening-a-being-removed-proc-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: procfs: return ENOENT on opening a being-removed proc entry
From: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>

Change the return value to ENOENT.  This return value is then returned
when opening the proc entry that have been removed.  For example,
open("/proc/bus/pci/XX/YY") when the corresponding device is being
hot-removed.

Signed-off-by: Daisuke Ogino <ogino.daisuke@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/inode.c~procfs-return-enoent-on-opening-a-being-removed-proc-entry fs/proc/inode.c
--- a/fs/proc/inode.c~procfs-return-enoent-on-opening-a-being-removed-proc-entry
+++ a/fs/proc/inode.c
@@ -319,7 +319,7 @@ static int proc_reg_open(struct inode *i
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return -EINVAL;
+		return -ENOENT;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;
_

Patches currently in -mm which might be from ogino.daisuke@jp.fujitsu.com are

origin.patch

