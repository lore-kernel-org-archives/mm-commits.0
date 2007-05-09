From: akpm@linux-foundation.org
Subject: - fs-convert-core-functions-to-zero_user_page-fix-2.patch removed from -mm tree
Date: Wed, 09 May 2007 02:15:31 -0700
Message-ID: <200705090915.l499FVAv018912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588AbXEIJQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:16:04 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l499FWRF005317
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 9 May 2007 02:15:33 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     fs-convert-core-functions-to-zero_user_page-fix-2
has been removed from the -mm tree.  Its filename was
     fs-convert-core-functions-to-zero_user_page-fix-2.patch

This patch was dropped because it was folded into fs-convert-core-functions-to-zero_user_page.patch

------------------------------------------------------
Subject: fs-convert-core-functions-to-zero_user_page-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/truncate.c~fs-convert-core-functions-to-zero_user_page-fix-2 mm/truncate.c
--- a/mm/truncate.c~fs-convert-core-functions-to-zero_user_page-fix-2
+++ a/mm/truncate.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/highmem.h>
 #include <linux/pagevec.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
@@ -46,7 +47,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	zero_user_page(page, partial, PAGE_CACHE_SIZE-partial);
+	zero_user_page(page, partial, PAGE_CACHE_SIZE - partial, KM_USER0);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
mutex_lock_interruptible-add-__must_check.patch
afs-implement-basic-file-write-support.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
rename-thread_info-to-stack.patch
