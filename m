From: akpm@linux-foundation.org
Subject: + drivers-bluetooth-btsdioc-fix-double-free.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:47:03 -0700
Message-ID: <200711010747.lA17l3Qc018855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049AbXKAHrR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:47:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     drivers/bluetooth/btsdio.c: fix double-free
has been added to the -mm tree.  Its filename is
     drivers-bluetooth-btsdioc-fix-double-free.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/bluetooth/btsdio.c: fix double-free
From: Adrian Bunk <bunk@kernel.org>

This patch fixes a double-free spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/bluetooth/btsdio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/bluetooth/btsdio.c~drivers-bluetooth-btsdioc-fix-double-free drivers/bluetooth/btsdio.c
--- a/drivers/bluetooth/btsdio.c~drivers-bluetooth-btsdioc-fix-double-free
+++ a/drivers/bluetooth/btsdio.c
@@ -162,10 +162,8 @@ static int btsdio_rx_packet(struct btsdi
 	bt_cb(skb)->pkt_type = hdr[3];
 
 	err = hci_recv_frame(skb);
-	if (err < 0) {
-		kfree(skb);
+	if (err < 0)
 		return err;
-	}
 
 	sdio_writeb(data->func, 0x00, REG_PC_RRT, NULL);
 
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
