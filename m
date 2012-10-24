From: akpm@linux-foundation.org
Subject: + ipc-message-queue-receive-cleanup-checkpatch-fixes.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:40:27 -0700
Message-ID: <20121024214028.B71B65C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:37235 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161051Ab2JXVkb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:40:31 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so62804wey.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:40:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, skinsbursky@parallels.com


The patch titled
     Subject: ipc-message-queue-receive-cleanup-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-message-queue-receive-cleanup-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
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

