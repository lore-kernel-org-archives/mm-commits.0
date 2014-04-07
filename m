From: akpm@linux-foundation.org
Subject: [folded-merged] zram-propagate-error-to-user-fix.patch removed
 from -mm tree
Date: Mon, 07 Apr 2014 15:15:04 -0700
Message-ID: <53432368.HElCdjeEA92ZlV8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40054 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] zram-propagate-error-to-user-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:15:04 -0700


The patch titled
     Subject: zram-propagate-error-to-user-fix
has been removed from the -mm tree.  Its filename was
     zram-propagate-error-to-user-fix.patch

This patch was dropped because it was folded into zram-propagate-error-to-user.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-propagate-error-to-user-fix

don't return with the lock held, per Sergey

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-propagate-error-to-user-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-propagate-error-to-user-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -126,26 +126,28 @@ static ssize_t max_comp_streams_store(st
 {
 	int num;
 	struct zram *zram = dev_to_zram(dev);
+	int ret;
 
-	if (kstrtoint(buf, 0, &num))
-		goto out;
+	ret = kstrtoint(buf, 0, &num);
+	if (ret < 0)
+		return ret;
 	if (num < 1)
-		goto out;
+		return -EINVAL;
 
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		if (!zcomp_set_max_streams(zram->comp, num)) {
 			pr_info("Cannot change max compression streams\n");
-			goto out_unlock;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
 	zram->max_comp_streams = num;
-	return len;
-out_unlock:
-	up_write(&zram->init_lock);
+	ret = len;
 out:
-	return -EINVAL;
+	up_write(&zram->init_lock);
+	return ret;
 }
 
 static ssize_t comp_algorithm_show(struct device *dev,
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
zram-propagate-error-to-user.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

