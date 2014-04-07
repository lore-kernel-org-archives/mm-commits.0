From: akpm@linux-foundation.org
Subject: [folded-merged] zram-use-zcomp-compressing-backends-fix.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 15:13:53 -0700
Message-ID: <53432321.BFjE2KBjC6sJVX/M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaDGWNy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:13:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] zram-use-zcomp-compressing-backends-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:13:53 -0700


The patch titled
     Subject: zram-use-zcomp-compressing-backends-fix
has been removed from the -mm tree.  Its filename was
     zram-use-zcomp-compressing-backends-fix.patch

This patch was dropped because it was folded into zram-use-zcomp-compressing-backends.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-use-zcomp-compressing-backends-fix

resolve conflicts with zram-delete-zram_init_device-fix.patch

Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zcomp-compressing-backends-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -519,6 +519,7 @@ static ssize_t disksize_store(struct dev
 	u64 disksize;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
+	int err;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -531,18 +532,17 @@ static ssize_t disksize_store(struct dev
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		zram_meta_free(meta);
-		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		return -EBUSY;
+		err = -EBUSY;
+		goto out_free_meta;
 	}
 
 	zram->comp = zcomp_create(default_compressor);
 	if (!zram->comp) {
-		up_write(&zram->init_lock);
 		pr_info("Cannot initialise %s compressing backend\n",
 				default_compressor);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_free_meta;
 	}
 
 	zram->meta = meta;
@@ -551,6 +551,11 @@ static ssize_t disksize_store(struct dev
 	up_write(&zram->init_lock);
 
 	return len;
+
+out_free_meta:
+	up_write(&zram->init_lock);
+	zram_meta_free(meta);
+	return err;
 }
 
 static ssize_t reset_store(struct device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

