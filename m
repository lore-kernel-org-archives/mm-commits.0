From: akpm@linux-foundation.org
Subject: - fuse-fuse_file_alloc-fix-null-dereferences.patch removed from -mm tree
Date: Sat, 27 Oct 2007 00:30:18 -0700
Message-ID: <200710270730.l9R7UKB8002828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43157 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbXJ0Haq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fuse_file_alloc(): fix NULL dereferences
has been removed from the -mm tree.  Its filename was
     fuse-fuse_file_alloc-fix-null-dereferences.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fuse: fuse_file_alloc(): fix NULL dereferences
From: Adrian Bunk <bunk@kernel.org>

This patch fixes obvious NULL dereferences spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-fuse_file_alloc-fix-null-dereferences fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fuse_file_alloc-fix-null-dereferences
+++ a/fs/fuse/file.c
@@ -55,9 +55,10 @@ struct fuse_file *fuse_file_alloc(void)
 		if (!ff->reserved_req) {
 			kfree(ff);
 			ff = NULL;
+		} else {
+			INIT_LIST_HEAD(&ff->write_entry);
+			atomic_set(&ff->count, 0);
 		}
-		INIT_LIST_HEAD(&ff->write_entry);
-		atomic_set(&ff->count, 0);
 	}
 	return ff;
 }
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
ipmi-fix-comparison-in-demangle_device_id.patch
git-acpi.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
fuse-fuse_file_alloc-fix-null-dereferences.patch
make-jbd-journalc__journal_abort_hard-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
