From: akpm@linux-foundation.org
Subject: + hfsplus-get-rid-of-write_super-checkpatch-fixes.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:43:51 -0700
Message-ID: <20120621194351.CFDA4A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38989 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2FUTny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:43:54 -0400
Received: by fat25 with SMTP id 25so63630fat.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:43:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus-get-rid-of-write_super-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hfsplus-get-rid-of-write_super-checkpatch-fixes.patch

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
Subject: hfsplus-get-rid-of-write_super-checkpatch-fixes

WARNING: suspect code indent for conditional statements (8, 15)
#168: FILE: fs/hfsplus/super.c:247:
+	if (sb->s_flags & MS_RDONLY)
+	       return;

WARNING: suspect code indent for conditional statements (8, 15)
#172: FILE: fs/hfsplus/super.c:251:
+	if (!sbi->work_queued) {
+	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);

total: 0 errors, 2 warnings, 145 lines checked

./patches/hfsplus-get-rid-of-write_super.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-checkpatch-fixes fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-get-rid-of-write_super-checkpatch-fixes
+++ a/fs/hfsplus/super.c
@@ -245,13 +245,13 @@ void hfsplus_mark_mdb_dirty(struct super
 	unsigned long delay;
 
 	if (sb->s_flags & MS_RDONLY)
-	       return;
+		return;
 
 	spin_lock(&sbi->work_lock);
 	if (!sbi->work_queued) {
-	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
-	       queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
-	       sbi->work_queued = 1;
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+		sbi->work_queued = 1;
 	}
 	spin_unlock(&sbi->work_lock);
 }
_
Subject: Subject: hfsplus-get-rid-of-write_super-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
memory-hotplug-fix-invalid-memory-access-caused-by-stale-kswapd-pointer-fix.patch
drivers-gpio-devresc-export-devm_gpio_request_one-to-modules.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
string-introduce-memweight-fix.patch
drivers-rtc-rtc-ab8500c-use-uie-emulation-checkpatch-fixes.patch
hfsplus-get-rid-of-write_super-checkpatch-fixes.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
fs-cachefiles-add-support-for-large-files-in-filesystem-caching-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

