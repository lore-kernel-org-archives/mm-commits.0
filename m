From: akpm@linux-foundation.org
Subject: + fat-simplify-writeback_inode-checkpatch-fixes.patch added to -mm tree
Date: Thu, 30 Aug 2012 13:41:18 -0700
Message-ID: <20120830204119.2DA3220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:65021 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2H3UlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 16:41:21 -0400
Received: by wibhr14 with SMTP id hr14so31912wib.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 13:41:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, linkinjeon@gmail.com


The patch titled
     Subject: fat-simplify-writeback_inode-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fat-simplify-writeback_inode-checkpatch-fixes.patch

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
Subject: fat-simplify-writeback_inode-checkpatch-fixes

WARNING: suspect code indent for conditional statements (8, 15)
#34: FILE: fs/fat/inode.c:1466:
 	if (!ret)
+	       ret = filemap_fdatawrite(inode->i_mapping);

total: 0 errors, 1 warnings, 23 lines checked

./patches/fat-simplify-writeback_inode.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes fs/fat/inode.c
--- a/fs/fat/inode.c~fat-simplify-writeback_inode-checkpatch-fixes
+++ a/fs/fat/inode.c
@@ -1464,7 +1464,7 @@ static int writeback_inode(struct inode 
 	*/
 	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-	       ret = filemap_fdatawrite(inode->i_mapping);
+		= filemap_fdatawrite(inode->i_mapping);
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-netpoll-re-enable-irq-in-poll_napi.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
rbtree-performance-and-correctness-test-fix.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

