From: akpm@linux-foundation.org
Subject: [folded-merged] drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 15:12:22 -0800
Message-ID: <20121218231223.0BBA482004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:44982 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 18:12:24 -0500
Received: by mail-qa0-f73.google.com with SMTP id a19so185640qad.4
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 15:12:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch

This patch was dropped because it was folded into drop_caches-add-some-documentation-and-info-messsge.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes

WARNING: Prefer netdev_notice(netdev, ... then dev_notice(dev, ... then pr_notice(...  to printk(KERN_NOTICE ...
#112: FILE: fs/drop_caches.c:61:
+		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",

WARNING: line over 80 characters
#113: FILE: fs/drop_caches.c:62:
+			current->comm, task_pid_nr(current), sysctl_drop_caches);

total: 0 errors, 2 warnings, 53 lines checked

./patches/drop_caches-add-some-documentation-and-info-messsge.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/drop_caches.c~drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes fs/drop_caches.c
--- a/fs/drop_caches.c~drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes
+++ a/fs/drop_caches.c
@@ -59,7 +59,7 @@ int drop_caches_sysctl_handler(ctl_table
 		return ret;
 	if (write) {
 		printk(KERN_NOTICE "%s (%d): dropped kernel caches: %d\n",
-			current->comm, task_pid_nr(current), sysctl_drop_caches);
+		       current->comm, task_pid_nr(current), sysctl_drop_caches);
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
 		if (sysctl_drop_caches & 2)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
drop_caches-add-some-documentation-and-info-messsge.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

