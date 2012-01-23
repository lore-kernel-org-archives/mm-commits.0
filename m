From: akpm@linux-foundation.org
Subject: [merged] mm-fix-warnings-regarding-enum-migrate_mode.patch removed from -mm tree
Date: Mon, 23 Jan 2012 12:21:06 -0800
Message-ID: <20120123202107.9D79C5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63367 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2AWUVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2012 15:21:11 -0500
Received: by eaaf1 with SMTP id f1so123157eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jan 2012 12:21:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix warnings regarding enum migrate_mode
has been removed from the -mm tree.  Its filename was
     mm-fix-warnings-regarding-enum-migrate_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm: fix warnings regarding enum migrate_mode

sparc64 allmodconfig:

In file included from include/linux/compat.h:15,
                 from /usr/src/25/arch/sparc/include/asm/siginfo.h:19,
                 from include/linux/signal.h:5,
                 from include/linux/sched.h:73,
                 from arch/sparc/kernel/asm-offsets.c:13:
include/linux/fs.h:618: warning: parameter has incomplete type

It seems that my sparc64 compiler (gcc-3.4.5) doesn't like the forward
declaration of enums.

Fix this by moving the "enum migrate_mode" definition into its own header
file.

Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h           |    2 +-
 include/linux/migrate.h      |   14 +-------------
 include/linux/migrate_mode.h |   16 ++++++++++++++++
 3 files changed, 18 insertions(+), 14 deletions(-)

diff -puN include/linux/fs.h~mm-fix-warnings-regarding-enum-migrate_mode include/linux/fs.h
--- a/include/linux/fs.h~mm-fix-warnings-regarding-enum-migrate_mode
+++ a/include/linux/fs.h
@@ -10,6 +10,7 @@
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
 #include <linux/types.h>
+#include <linux/migrate_mode.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -526,7 +527,6 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
-enum migrate_mode;
 
 struct iov_iter {
 	const struct iovec *iov;
diff -puN include/linux/migrate.h~mm-fix-warnings-regarding-enum-migrate_mode include/linux/migrate.h
--- a/include/linux/migrate.h~mm-fix-warnings-regarding-enum-migrate_mode
+++ a/include/linux/migrate.h
@@ -3,22 +3,10 @@
 
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
+#include <linux/migrate_mode.h>
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
-/*
- * MIGRATE_ASYNC means never block
- * MIGRATE_SYNC_LIGHT in the current implementation means to allow blocking
- *	on most operations but not ->writepage as the potential stall time
- *	is too significant
- * MIGRATE_SYNC will block when migrating pages
- */
-enum migrate_mode {
-	MIGRATE_ASYNC,
-	MIGRATE_SYNC_LIGHT,
-	MIGRATE_SYNC,
-};
-
 #ifdef CONFIG_MIGRATION
 #define PAGE_MIGRATION 1
 
diff -puN /dev/null include/linux/migrate_mode.h
--- /dev/null
+++ a/include/linux/migrate_mode.h
@@ -0,0 +1,16 @@
+#ifndef MIGRATE_MODE_H_INCLUDED
+#define MIGRATE_MODE_H_INCLUDED
+/*
+ * MIGRATE_ASYNC means never block
+ * MIGRATE_SYNC_LIGHT in the current implementation means to allow blocking
+ *	on most operations but not ->writepage as the potential stall time
+ *	is too significant
+ * MIGRATE_SYNC will block when migrating pages
+ */
+enum migrate_mode {
+	MIGRATE_ASYNC,
+	MIGRATE_SYNC_LIGHT,
+	MIGRATE_SYNC,
+};
+
+#endif		/* MIGRATE_MODE_H_INCLUDED */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

