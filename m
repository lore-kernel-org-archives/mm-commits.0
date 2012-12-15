From: akpm@linux-foundation.org
Subject: + make-my-i386-build-work.patch added to -mm tree
Date: Fri, 14 Dec 2012 17:07:08 -0800
Message-ID: <20121215010708.F328B82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37062 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab2LOBHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 20:07:10 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so415992ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 17:07:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bfields@redhat.com, bjschuma@netapp.com


The patch titled
     Subject: make my i386 build work
has been added to the -mm tree.  Its filename is
     make-my-i386-build-work.patch

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
Subject: make my i386 build work

How long is this to take?

Cc: Bryan Schumaker <bjschuma@netapp.com>
Cc: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/fault_inject.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/nfsd/fault_inject.c~make-my-i386-build-work fs/nfsd/fault_inject.c
--- a/fs/nfsd/fault_inject.c~make-my-i386-build-work
+++ a/fs/nfsd/fault_inject.c
@@ -127,8 +127,9 @@ static ssize_t fault_inject_write(struct
 	struct sockaddr_storage sa;
 	u64 val;
 
-	if (copy_from_user(write_buf, buf, size))
-		return -EFAULT;
+return len;
+//	if (copy_from_user(write_buf, buf, size))
+//		return -EFAULT;
 	write_buf[size] = '\0';
 
 	size = rpc_pton(net, write_buf, size, (struct sockaddr *)&sa, sizeof(sa));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
irq-tsk-comm-is-an-array.patch
block-remove-deadlock-in-disk_clear_events-fix.patch
block-prevent-race-cleanup-fix.patch
mm.patch
memory-hotplug-document-and-enable-config_movable_node-fix.patch
memcg-kmem-accounting-basic-infrastructure-fix.patch
slub-slub-specific-propagation-changes-fix.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes-checkpatch-fixes.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix.patch
core_pattern-set-core-helpers-root-and-namespace-to-crashing-process-fix-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-notify-add-procfs-fdinfo-helper-v7-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

