From: akpm@linux-foundation.org
Subject: + make-ipc-utilcsysvipc_find_ipc-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:20:13 -0700
Message-ID: <200711010720.lA17KDuf017950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbXKAHVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, Nadia.Derbey@bull.net


The patch titled
     make ipc/util.c:sysvipc_find_ipc() static
has been added to the -mm tree.  Its filename is
     make-ipc-utilcsysvipc_find_ipc-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make ipc/util.c:sysvipc_find_ipc() static
From: Adrian Bunk <bunk@kernel.org>

sysvipc_find_ipc() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/util.c~make-ipc-utilcsysvipc_find_ipc-static ipc/util.c
--- a/ipc/util.c~make-ipc-utilcsysvipc_find_ipc-static
+++ a/ipc/util.c
@@ -802,8 +802,8 @@ struct ipc_proc_iter {
 /*
  * This routine locks the ipc structure found at least at position pos.
  */
-struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
-					loff_t *new_pos)
+static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
+					      loff_t *new_pos)
 {
 	struct kern_ipc_perm *ipc;
 	int total, id;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
