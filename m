From: akpm@linux-foundation.org
Subject: [merged]
 mm-postpone-the-disabling-of-kmemleak-early-logging.patch removed from -mm
 tree
Date: Mon, 12 May 2014 12:30:47 -0700
Message-ID: <53712167.mCLbOcGZgMoEzBvO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaELTax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 15:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, lizefan@huawei.com, catalin.marinas@arm.com

Subject: [merged] mm-postpone-the-disabling-of-kmemleak-early-logging.patch removed from -mm tree
To: catalin.marinas@arm.com,lizefan@huawei.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 12:30:47 -0700


The patch titled
     Subject: mm: postpone the disabling of kmemleak early logging
has been removed from the -mm tree.  Its filename was
     mm-postpone-the-disabling-of-kmemleak-early-logging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: postpone the disabling of kmemleak early logging

Commit 8910ae896c8c ("kmemleak: change some global variables to int"), in
addition to the atomic -> int conversion, moved the kmemleak_early_log
disabling at the beginning of the kmemleak_init() function, before the
full kmemleak tracing is actually enabled.  In this small window,
kmem_cache_create() is called by kmemleak which triggers additional memory
allocation that are not traced.  This patch restores the original logic
with kmemleak_early_log disabling when kmemleak is fully functional.

Fixes: 8910ae896c8c (kmemleak: change some global variables to int)

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kmemleak.c~mm-postpone-the-disabling-of-kmemleak-early-logging mm/kmemleak.c
--- a/mm/kmemleak.c~mm-postpone-the-disabling-of-kmemleak-early-logging
+++ a/mm/kmemleak.c
@@ -1775,10 +1775,9 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	kmemleak_early_log = 0;
-
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
+		kmemleak_early_log = 0;
 		kmemleak_disable();
 		return;
 	}
@@ -1796,6 +1795,7 @@ void __init kmemleak_init(void)
 
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
+	kmemleak_early_log = 0;
 	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
mm-kmemleakc-use-%u-to-print-checksum.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
mm-call-kmemleak-directly-from-memblock_allocfree.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

