From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-dont-call-idr_remove-from-zram_remove-fix.patch removed from -mm tree
Date: Fri, 15 Jan 2016 16:25:31 -0800
Message-ID: <56998dfb.ui1AxG4Py4uC4yLX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304AbcAPAZc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 19:25:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jmarchan@redhat.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-dont-call-idr_remove-from-zram_remove-fix
has been removed from the -mm tree.  Its filename was
     zram-dont-call-idr_remove-from-zram_remove-fix.patch

This patch was dropped because it was folded into zram-dont-call-idr_remove-from-zram_remove.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zram-dont-call-idr_remove-from-zram_remove-fix

fix coding stype, per Sergey

Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-dont-call-idr_remove-from-zram_remove-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1369,8 +1369,9 @@ static ssize_t hot_remove_store(struct c
 	if (zram) {
 		ret = zram_remove(zram);
 		idr_remove(&zram_index_idr, dev_id);
-	} else
+	} else {
 		ret = -ENODEV;
+	}
 
 	mutex_unlock(&zram_index_mutex);
 	return ret ? ret : count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zram-dont-call-idr_remove-from-zram_remove.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix-fix-2-fix-3.patch
mm-mlockc-change-can_do_mlock-return-value-type-to-boolean-fix.patch
mm-hugetlbfs-unmap-pages-if-page-fault-raced-with-hole-punch-fix.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp-fix.patch
kernel-stop_machinec-remove-config_smp-dependencies.patch
kernel-stop_machinec-remove-config_smp-dependencies-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch

