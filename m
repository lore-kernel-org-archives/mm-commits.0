From: akpm@linux-foundation.org
Subject: + video-sis-fix-negative-array-index.patch added to -mm tree
Date: Thu, 01 Nov 2007 15:22:24 -0700
Message-ID: <200711012222.lA1MMOkL018496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753469AbXKAWWj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 18:22:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, adaplas@pol.net, thomas@winischhofer.net


The patch titled
     video/sis/: fix negative array index
has been added to the -mm tree.  Its filename is
     video-sis-fix-negative-array-index.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: video/sis/: fix negative array index
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the possible usage of a negative value as an array
index spotted by the Coverity checker.

sisfb_validate_mode() could return a negative error code and we must check for
that prior to using its return value as an array index.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/sis/sis_main.c~video-sis-fix-negative-array-index drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~video-sis-fix-negative-array-index
+++ a/drivers/video/sis/sis_main.c
@@ -1248,7 +1248,6 @@ sisfb_do_set_var(struct fb_var_screeninf
 	if(found_mode) {
 		ivideo->sisfb_mode_idx = sisfb_validate_mode(ivideo,
 				ivideo->sisfb_mode_idx, ivideo->currentvbflags);
-		ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
 	} else {
 		ivideo->sisfb_mode_idx = -1;
 	}
@@ -1260,6 +1259,8 @@ sisfb_do_set_var(struct fb_var_screeninf
 		return -EINVAL;
 	}
 
+	ivideo->mode_no = sisbios_mode[ivideo->sisfb_mode_idx].mode_no[ivideo->mni];
+
 	if(sisfb_search_refresh_rate(ivideo, ivideo->refresh_rate, ivideo->sisfb_mode_idx) == 0) {
 		ivideo->rate_idx = sisbios_mode[ivideo->sisfb_mode_idx].rate_idx;
 		ivideo->refresh_rate = 60;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-afs-vlocationc-fix-off-by-one.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
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
