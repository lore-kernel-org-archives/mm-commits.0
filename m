From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 30 Oct 2012 13:46:45 -0700
Message-ID: <20121030204645.70A84100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:35782 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2J3Uqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 16:46:47 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so79395qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 13:46:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ceph/messenger.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN net/ceph/messenger.c~linux-next-git-rejects net/ceph/messenger.c
--- a/net/ceph/messenger.c~linux-next-git-rejects
+++ a/net/ceph/messenger.c
@@ -2305,22 +2305,11 @@ restart:
 
 	if (test_and_clear_bit(CON_FLAG_BACKOFF, &con->flags)) {
 		dout("con_work %p backing off\n", con);
-<<<<<<< HEAD
-		if (queue_delayed_work(ceph_msgr_wq, &con->work,
-				       round_jiffies_relative(con->delay))) {
-			dout("con_work %p backoff %lu\n", con, con->delay);
-			mutex_unlock(&con->mutex);
-			return;
-		} else {
-			dout("con_work %p FAILED to back off %lu\n", con,
-			     con->delay);
-=======
 		ret = queue_con_delay(con, round_jiffies_relative(con->delay));
 		if (ret) {
 			dout("con_work %p FAILED to back off %lu\n", con,
 			     con->delay);
 			BUG_ON(ret == -ENOENT);
->>>>>>> linux-next/akpm-base
 			set_bit(CON_FLAG_BACKOFF, &con->flags);
 		}
 		goto done;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

