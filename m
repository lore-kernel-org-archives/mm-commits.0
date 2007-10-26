From: akpm@linux-foundation.org
Subject: + fuse_file_alloc-fix-null-dereferences.patch added to -mm tree
Date: Fri, 26 Oct 2007 15:05:12 -0700
Message-ID: <200710262205.l9QM5CWt016955@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbXJZWG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 18:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, miklos@szeredi.hu


The patch titled
     fuse_file_alloc(): fix NULL dereferences
has been added to the -mm tree.  Its filename is
     fuse_file_alloc-fix-null-dereferences.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fuse_file_alloc(): fix NULL dereferences
From: Adrian Bunk <bunk@kernel.org>

Fix obvious NULL dereferences spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse_file_alloc-fix-null-dereferences fs/fuse/file.c
--- a/fs/fuse/file.c~fuse_file_alloc-fix-null-dereferences
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
