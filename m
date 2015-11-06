From: akpm@linux-foundation.org
Subject: [merged] kernel-watchdog-is_hardlockup-can-be-boolean.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:03 -0800
Message-ID: <563d082b.8EiOmABAM54aaiU0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161824AbbKFUGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: is_hardlockup can be boolean
has been removed from the -mm tree.  Its filename was
     kernel-watchdog-is_hardlockup-can-be-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: kernel/watchdog.c: is_hardlockup can be boolean

Make is_hardlockup return bool to improve readability due to this
particular function only using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdog-is_hardlockup-can-be-boolean kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-is_hardlockup-can-be-boolean
+++ a/kernel/watchdog.c
@@ -263,15 +263,15 @@ void touch_softlockup_watchdog_sync(void
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
-static int is_hardlockup(void)
+static bool is_hardlockup(void)
 {
 	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
 
 	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
-		return 1;
+		return true;
 
 	__this_cpu_write(hrtimer_interrupts_saved, hrint);
-	return 0;
+	return false;
 }
 #endif
 
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-oom_kill-introduce-is_sysrq_oom-helper.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

