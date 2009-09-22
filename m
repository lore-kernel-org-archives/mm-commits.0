From: akpm@linux-foundation.org
Subject: [merged] vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:38:36 -0700
Message-ID: <200909222038.n8MKcaJ0001747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbZIVUjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, ct@pipapo.org, mm-commits@vger.kernel.org


The patch titled
     vm: document that setting vfs_cache_pressure to 0 isn't a good idea
has been removed from the -mm tree.  Its filename was
     vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vm: document that setting vfs_cache_pressure to 0 isn't a good idea
From: Jan Kara <jack@suse.cz>

Reported-by: Christian Thaeter <ct@pipapo.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~vm-document-that-setting-vfs_cache_pressure-to-0-isnt-a-good-idea
+++ a/Documentation/sysctl/vm.txt
@@ -585,7 +585,9 @@ caching of directory and inode objects.
 At the default value of vfs_cache_pressure=100 the kernel will attempt to
 reclaim dentries and inodes at a "fair" rate with respect to pagecache and
 swapcache reclaim.  Decreasing vfs_cache_pressure causes the kernel to prefer
-to retain dentry and inode caches.  Increasing vfs_cache_pressure beyond 100
+to retain dentry and inode caches. When vfs_cache_pressure=0, the kernel will
+never reclaim dentries and inodes due to memory pressure and this can easily
+lead to out-of-memory conditions. Increasing vfs_cache_pressure beyond 100
 causes the kernel to prefer to reclaim dentries and inodes.
 
 ==============================================================
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
vfs-split-generic_forget_inode-so-that-hugetlbfs-does-not-have-to-copy-it.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention-fix.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
reiser4-update-names-of-quota-methods.patch

