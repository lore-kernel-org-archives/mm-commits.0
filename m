From: akpm@linux-foundation.org
Subject: + xtensa-iss_net_setup-must-be-__init.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:48:10 -0700
Message-ID: <200711010748.lA17mA99018894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243AbXKAHsY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:48:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, chris@zankel.net


The patch titled
     xtensa iss_net_setup() must be __init
has been added to the -mm tree.  Its filename is
     xtensa-iss_net_setup-must-be-__init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xtensa iss_net_setup() must be __init
From: Adrian Bunk <bunk@kernel.org>

WARNING: vmlinux.o(.text+0x395c): Section mismatch: reference to .init.text:__alloc_bootmem (between '__invalidate_dcache_all' and '__simc')

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platform-iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/platform-iss/network.c~xtensa-iss_net_setup-must-be-__init arch/xtensa/platform-iss/network.c
--- a/arch/xtensa/platform-iss/network.c~xtensa-iss_net_setup-must-be-__init
+++ a/arch/xtensa/platform-iss/network.c
@@ -746,7 +746,7 @@ struct iss_net_init {
 
 #define ERR KERN_ERR "iss_net_setup: "
 
-static int iss_net_setup(char *str)
+static int __init iss_net_setup(char *str)
 {
 	struct iss_net_private *device = NULL;
 	struct iss_net_init *new;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
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
reiser4.patch
