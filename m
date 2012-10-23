From: akpm@linux-foundation.org
Subject: + drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2012 16:46:45 -0700
Message-ID: <20121023234646.94B47200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52341 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab2JWXqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 19:46:48 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so262818wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 16:46:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mhocko@suse.cz


The patch titled
     Subject: drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch

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
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

