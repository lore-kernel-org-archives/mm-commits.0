From: akpm@linux-foundation.org
Subject: + kernel-power-diskc-make-code-static.patch added to -mm tree
Date: Thu, 01 Nov 2007 00:23:06 -0700
Message-ID: <200711010723.lA17N6FL018007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbXKAHX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 03:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     kernel/power/disk.c: make code static
has been added to the -mm tree.  Its filename is
     kernel-power-diskc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel/power/disk.c: make code static
From: Adrian Bunk <bunk@kernel.org>

resume_file[] and create_image() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/disk.c |    4 ++--
 kernel/power/swap.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/power/disk.c~kernel-power-diskc-make-code-static kernel/power/disk.c
--- a/kernel/power/disk.c~kernel-power-diskc-make-code-static
+++ a/kernel/power/disk.c
@@ -26,7 +26,7 @@
 
 
 static int noresume = 0;
-char resume_file[256] = CONFIG_PM_STD_PARTITION;
+static char resume_file[256] = CONFIG_PM_STD_PARTITION;
 dev_t swsusp_resume_device;
 sector_t swsusp_resume_block;
 
@@ -145,7 +145,7 @@ static void platform_restore_cleanup(int
  *	reappears in this routine after a restore.
  */
 
-int create_image(int platform_mode)
+static int create_image(int platform_mode)
 {
 	int error;
 
diff -puN kernel/power/swap.c~kernel-power-diskc-make-code-static kernel/power/swap.c
--- a/kernel/power/swap.c~kernel-power-diskc-make-code-static
+++ a/kernel/power/swap.c
@@ -28,8 +28,6 @@
 
 #include "power.h"
 
-extern char resume_file[];
-
 #define SWSUSP_SIG	"S1SUSPEND"
 
 struct swsusp_header {
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
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
fs-ecryptfs-possible-cleanups.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
reiser4.patch
