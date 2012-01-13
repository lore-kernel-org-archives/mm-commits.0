From: akpm@linux-foundation.org
Subject: + mm-fix-warnings-regarding-enum-migrate_mode.patch added to -mm tree
Date: Fri, 13 Jan 2012 13:25:56 -0800
Message-ID: <20120113212557.70CF25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42946 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2AMV0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 16:26:00 -0500
Received: by eeke50 with SMTP id e50so25001eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 13:25:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: fix warnings regarding enum migrate_mode
has been added to the -mm tree.  Its filename is
     mm-fix-warnings-regarding-enum-migrate_mode.patch

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

Cc: Mel Gorman <mgorman@suse.de>
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
@@ -525,7 +526,6 @@ enum positive_aop_returns {
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
Subject: Subject: mm: fix warnings regarding enum migrate_mode

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-fix-warnings-regarding-enum-migrate_mode.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
drivers-scsi-megaraidc-fix-sparse-warnings-checkpatch-fixes.patch
drivers-usb-misc-emi26c-emi62c-fix-warnings.patch
mm.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-idle-intel_idlec-remove-redundant-local_irq_disable-call.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

