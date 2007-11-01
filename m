From: akpm@linux-foundation.org
Subject: + kernel-cgroupc-make-2-functions-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:21:19 -0700
Message-ID: <200711010721.lA17LJXP017962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbXKAHVk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:21:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, menage@google.com


The patch titled
     kernel/cgroup.c: make 2 functions static
has been added to the -mm tree.  Its filename is
     kernel-cgroupc-make-2-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/cgroup.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

cgroup_is_releasable() and notify_on_release() should be static,
not global inline.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~kernel-cgroupc-make-2-functions-static kernel/cgroup.c
--- a/kernel/cgroup.c~kernel-cgroupc-make-2-functions-static
+++ a/kernel/cgroup.c
@@ -143,7 +143,7 @@ enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
 };
 
-inline int cgroup_is_releasable(const struct cgroup *cgrp)
+static int cgroup_is_releasable(const struct cgroup *cgrp)
 {
 	const int bits =
 		(1 << CGRP_RELEASABLE) |
@@ -151,7 +151,7 @@ inline int cgroup_is_releasable(const st
 	return (cgrp->flags & bits) == bits;
 }
 
-inline int notify_on_release(const struct cgroup *cgrp)
+static int notify_on_release(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
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
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
