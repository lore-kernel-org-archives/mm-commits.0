From: akpm@linux-foundation.org
Subject: + fs-afs-vlocationc-fix-off-by-one.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:18:15 -0700
Message-ID: <200711012218.lA1MIFbE018324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbXKAWSl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:18:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dhowells@redhat.com


The patch titled
     fs/afs/vlocation.c: fix off-by-one
has been added to the -mm tree.  Its filename is
     fs-afs-vlocationc-fix-off-by-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/afs/vlocation.c: fix off-by-one
From: Adrian Bunk <bunk@kernel.org>

This patch fixes an off-by-one error spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/vlocation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/afs/vlocation.c~fs-afs-vlocationc-fix-off-by-one fs/afs/vlocation.c
--- a/fs/afs/vlocation.c~fs-afs-vlocationc-fix-off-by-one
+++ a/fs/afs/vlocation.c
@@ -382,7 +382,7 @@ struct afs_vlocation *afs_vlocation_look
 	       cell->name, key_serial(key),
 	       (int) namesz, (int) namesz, name, namesz);
 
-	if (namesz > sizeof(vl->vldb.name)) {
+	if (namesz >= sizeof(vl->vldb.name)) {
 		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
 	}
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-afs-vlocationc-fix-off-by-one.patch
lguest_userc-fix-memory-leak.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
xtensa-iss_net_setup-must-be-__init.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
53c7xx-removal-fallout.patch
remove-mm_ptovvtop.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
