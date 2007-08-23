From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-possible-fault-in-ecryptfs_sync_page.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:27:30 -0700
Message-ID: <200708232327.l7NNRUgg032400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52810 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933062AbXHWX1m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:27:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konishi.ryusuke@lab.ntt.co.jp, mhalcrow@us.ibm.com


The patch titled
     eCryptfs: fix possible fault in ecryptfs_sync_page
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-possible-fault-in-ecryptfs_sync_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eCryptfs: fix possible fault in ecryptfs_sync_page
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

This will avoid a possible fault in ecryptfs_sync_page().

In the function, eCryptfs calls sync_page() method of a lower filesystem
without checking its existence.  However, there are many filesystems that
don't have this method including network filesystems such as NFS, AFS, and
so forth.  They may fail when an eCryptfs page is waiting for lock.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-fix-possible-fault-in-ecryptfs_sync_page fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-fix-possible-fault-in-ecryptfs_sync_page
+++ a/fs/ecryptfs/mmap.c
@@ -834,7 +834,8 @@ static void ecryptfs_sync_page(struct pa
 		ecryptfs_printk(KERN_DEBUG, "find_lock_page failed\n");
 		return;
 	}
-	lower_page->mapping->a_ops->sync_page(lower_page);
+	if (lower_page->mapping->a_ops->sync_page)
+		lower_page->mapping->a_ops->sync_page(lower_page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
 			lower_page->index);
 	unlock_page(lower_page);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

ecryptfs-fix-lookup-error-for-special-files.patch
revert-ecryptfs-fix-lookup-error-for-special-files.patch
ecryptfs-fix-possible-fault-in-ecryptfs_sync_page.patch
