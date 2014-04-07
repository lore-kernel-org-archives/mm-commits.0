From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-return-error-valued-pointer-from-zcomp_create-fix.patch removed from
 -mm tree
Date: Mon, 07 Apr 2014 15:14:20 -0700
Message-ID: <5343233c.O/p1K+JNjUxyFl45%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaDGWOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] zram-return-error-valued-pointer-from-zcomp_create-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:14:20 -0700


The patch titled
     Subject: zram-return-error-valued-pointer-from-zcomp_create-fix
has been removed from the -mm tree.  Its filename was
     zram-return-error-valued-pointer-from-zcomp_create-fix.patch

This patch was dropped because it was folded into zram-return-error-valued-pointer-from-zcomp_create.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-return-error-valued-pointer-from-zcomp_create-fix

clean up error recovery flow

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-error-valued-pointer-from-zcomp_create-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -583,7 +583,7 @@ static ssize_t disksize_store(struct dev
 	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err = -EBUSY;
+	int err;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -599,14 +599,14 @@ static ssize_t disksize_store(struct dev
 		pr_info("Cannot initialise %s compressing backend\n",
 				zram->compressor);
 		err = PTR_ERR(comp);
-		goto out_cleanup;
+		goto out_free_meta;
 	}
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
-		goto out_cleanup;
+		err = -EBUSY;
+		goto out_destroy_comp;
 	}
 
 	zram->meta = meta;
@@ -614,12 +614,12 @@ static ssize_t disksize_store(struct dev
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
-
 	return len;
 
-out_cleanup:
-	if (!IS_ERR(comp))
-		zcomp_destroy(comp);
+out_destroy_comp:
+	up_write(&zram->init_lock);
+	zcomp_destroy(comp);
+out_free_meta:
 	zram_meta_free(meta);
 	return err;
 }
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
zram-return-error-valued-pointer-from-zcomp_create.patch
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

