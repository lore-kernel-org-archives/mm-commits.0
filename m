From: akpm@linux-foundation.org
Subject: + revert-zram-move-compact_store-to-sysfs-functions-area.patch
 added to -mm tree
Date: Wed, 22 Apr 2015 12:39:38 -0700
Message-ID: <5537f8fa.WCs++YfbHLNqExgM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbbDVTcw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 15:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "zram: move compact_store() to sysfs functions area"
has been added to the -mm tree.  Its filename is
     revert-zram-move-compact_store-to-sysfs-functions-area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-zram-move-compact_store-to-sysfs-functions-area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-zram-move-compact_store-to-sysfs-functions-area.patch

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
Subject: revert "zram: move compact_store() to sysfs functions area"

Revert

: commit c72c6160d967ed26a0b136dbab337f821d233509
: Author:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
: AuthorDate: Wed Apr 15 16:15:55 2015 -0700
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Wed Apr 15 16:35:21 2015 -0700
: 
:     zram: move compact_store() to sysfs functions area

it was intended to be a cosmetic change that w/o any functional change and
was part of a bigger change:

  http://lkml.iu.edu/hypermail/linux/kernel/1503.1/01818.html

Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~revert-zram-move-compact_store-to-sysfs-functions-area drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~revert-zram-move-compact_store-to-sysfs-functions-area
+++ a/drivers/block/zram/zram_drv.c
@@ -74,6 +74,27 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
+static ssize_t compact_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long nr_migrated;
+	struct zram *zram = dev_to_zram(dev);
+	struct zram_meta *meta;
+
+	down_read(&zram->init_lock);
+	if (!init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
+
+	meta = zram->meta;
+	nr_migrated = zs_compact(meta->mem_pool);
+	atomic64_add(nr_migrated, &zram->stats.num_migrated);
+	up_read(&zram->init_lock);
+
+	return len;
+}
+
 static ssize_t disksize_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1038,6 +1059,7 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
+static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
@@ -1114,6 +1136,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
+	&dev_attr_compact.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

