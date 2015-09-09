From: akpm@linux-foundation.org
Subject: [merged]
 kmemleak-record-accurate-early-log-buffer-count-and-report-when-exceeded.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:18 -0700
Message-ID: <55f08e2e.KtzoMJq2Mq4lNeXF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbbIITxS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: morgan.wang@huawei.com, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: record accurate early log buffer count and report when exceeded
has been removed from the -mm tree.  Its filename was
     kmemleak-record-accurate-early-log-buffer-count-and-report-when-exceeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Kai <morgan.wang@huawei.com>
Subject: kmemleak: record accurate early log buffer count and report when exceeded

In log_early function, crt_early_log should also count once when
'crt_early_log >= ARRAY_SIZE(early_log)'.  Otherwise the reported count
from kmemleak_init is one less than 'actual number'.

Then, in kmemleak_init, if early_log buffer size equal actual number,
kmemleak will init sucessful, so change warning condition to
'crt_early_log > ARRAY_SIZE(early_log)'.

Signed-off-by: Wang Kai <morgan.wang@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-record-accurate-early-log-buffer-count-and-report-when-exceeded mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-record-accurate-early-log-buffer-count-and-report-when-exceeded
+++ a/mm/kmemleak.c
@@ -838,6 +838,7 @@ static void __init log_early(int op_type
 	}
 
 	if (crt_early_log >= ARRAY_SIZE(early_log)) {
+		crt_early_log++;
 		kmemleak_disable();
 		return;
 	}
@@ -1882,7 +1883,7 @@ void __init kmemleak_init(void)
 	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);
 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);
 
-	if (crt_early_log >= ARRAY_SIZE(early_log))
+	if (crt_early_log > ARRAY_SIZE(early_log))
 		pr_warning("Early log buffer exceeded (%d), please increase "
 			   "DEBUG_KMEMLEAK_EARLY_LOG_SIZE\n", crt_early_log);
 
_

Patches currently in -mm which might be from morgan.wang@huawei.com are


