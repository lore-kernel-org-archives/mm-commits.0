From: akpm@linux-foundation.org
Subject: + hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:45:37 -0700
Message-ID: <20120613224538.28180A030B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:58886 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2FMWpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:45:39 -0400
Received: by ggeh3 with SMTP id h3so102995gge.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:45:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs-get-rid-of-hfs_sync_super-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch

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
Subject: hfs-get-rid-of-hfs_sync_super-checkpatch-fixes

WARNING: suspect code indent for conditional statements (8, 15)
#212: FILE: fs/hfs/super.c:73:
+	if (sb->s_flags & MS_RDONLY)
+	       return;

WARNING: suspect code indent for conditional statements (8, 15)
#216: FILE: fs/hfs/super.c:77:
+	if (!sbi->work_queued) {
+	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);

total: 0 errors, 2 warnings, 181 lines checked

./patches/hfs-get-rid-of-hfs_sync_super.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hfs/super.c~hfs-get-rid-of-hfs_sync_super-checkpatch-fixes fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-get-rid-of-hfs_sync_super-checkpatch-fixes
+++ a/fs/hfs/super.c
@@ -71,13 +71,13 @@ void hfs_mark_mdb_dirty(struct super_blo
 	unsigned long delay;
 
 	if (sb->s_flags & MS_RDONLY)
-	       return;
+		return;
 
 	spin_lock(&sbi->work_lock);
 	if (!sbi->work_queued) {
-	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
-	       queue_delayed_work(system_long_wq, &sbi->mdb_work, delay);
-	       sbi->work_queued = 1;
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->mdb_work, delay);
+		sbi->work_queued = 1;
 	}
 	spin_unlock(&sbi->work_lock);
 }
_
Subject: Subject: hfs-get-rid-of-hfs_sync_super-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
mm-fix-slab-page-_count-corruption-when-using-slub-fix.patch
tmpfs-implement-numa-node-interleaving-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
mm.patch
mm-make-vb_alloc-more-foolproof-fix.patch
mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix.patch
avr32-mm-faultc-port-oom-changes-to-do_page_fault-fix.patch
nmi-watchdog-fix-for-lockup-detector-breakage-on-resume.patch
kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-fix.patch
btrfs-use-printk_get_level-and-printk_skip_level-add-__printf-fix-fallout-checkpatch-fixes.patch
string-introduce-memweight-fix.patch
kmod-avoid-deadlock-from-recursive-kmod-call.patch
fork-use-vma_pages-to-simplify-the-code-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

