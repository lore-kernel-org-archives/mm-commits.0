From: akpm@linux-foundation.org
Subject: [folded-merged] ipc-message-queue-receive-cleanup-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:49:23 -0800
Message-ID: <20121218224924.2709D200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57044 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:49:26 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so68843eaa.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:49:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-message-queue-receive-cleanup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-message-queue-receive-cleanup-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-message-queue-receive-cleanup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-message-queue-receive-cleanup-checkpatch-fixes

WARNING: line over 80 characters
#33: FILE: include/linux/msg.h:39:
+		      long (*msg_fill)(void __user *, struct msg_msg *, size_t ));

ERROR: space prohibited before that close parenthesis ')'
#33: FILE: include/linux/msg.h:39:
+		      long (*msg_fill)(void __user *, struct msg_msg *, size_t ));

WARNING: line over 80 characters
#94: FILE: ipc/compat.c:368:
+	return do_msgrcv(first, uptr, second, msgtyp, third, compat_do_msg_fill);

ERROR: space prohibited before that close parenthesis ')'
#142: FILE: ipc/msg.c:774:
+	       long (*msg_handler)(void __user *, struct msg_msg *, size_t ))

total: 2 errors, 2 warnings, 165 lines checked

./patches/ipc-message-queue-receive-cleanup.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msg.h |    2 +-
 ipc/msg.c           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/msg.h~ipc-message-queue-receive-cleanup-checkpatch-fixes include/linux/msg.h
--- a/include/linux/msg.h~ipc-message-queue-receive-cleanup-checkpatch-fixes
+++ a/include/linux/msg.h
@@ -36,6 +36,6 @@ extern long do_msgsnd(int msqid, long mt
 			size_t msgsz, int msgflg);
 extern long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 		      int msgflg,
-		      long (*msg_fill)(void __user *, struct msg_msg *, size_t ));
+		      long (*msg_fill)(void __user *, struct msg_msg *, size_t));
 
 #endif /* _LINUX_MSG_H */
diff -puN ipc/msg.c~ipc-message-queue-receive-cleanup-checkpatch-fixes ipc/msg.c
--- a/ipc/msg.c~ipc-message-queue-receive-cleanup-checkpatch-fixes
+++ a/ipc/msg.c
@@ -771,7 +771,7 @@ static long do_msg_fill(void __user *des
 
 long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 	       int msgflg,
-	       long (*msg_handler)(void __user *, struct msg_msg *, size_t ))
+	       long (*msg_handler)(void __user *, struct msg_msg *, size_t))
 {
 	struct msg_queue *msq;
 	struct msg_msg *msg;
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
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

