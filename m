From: akpm@linux-foundation.org
Subject: [failures]
 mm-postpone-the-disabling-of-kmemleak-early-logging.patch removed from -mm
 tree
Date: Tue, 06 May 2014 14:30:09 -0700
Message-ID: <53695461.644BIk/prfFuia6b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41444 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaEFVaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 17:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, catalin.marinas@arm.com

Subject: [failures] mm-postpone-the-disabling-of-kmemleak-early-logging.patch removed from -mm tree
To: catalin.marinas@arm.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 14:30:09 -0700


The patch titled
     Subject: mm/kmemleak.c: postpone the disabling of kmemleak early logging
has been removed from the -mm tree.  Its filename was
     mm-postpone-the-disabling-of-kmemleak-early-logging.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm/kmemleak.c: postpone the disabling of kmemleak early logging

Currently, kmemleak_early_log is disabled at the beginning of the
kmemleak_init() function, before the full kmemleak tracing is actually
enabled.  In this small window, kmem_cache_create() is called by kmemleak
which triggers additional memory allocation that are not traced.  This
patch moves the kmemleak_early_log disabling further down and at the same
time with full kmemleak enabling.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/kmemleak.c~mm-postpone-the-disabling-of-kmemleak-early-logging mm/kmemleak.c
--- a/mm/kmemleak.c~mm-postpone-the-disabling-of-kmemleak-early-logging
+++ a/mm/kmemleak.c
@@ -1809,8 +1809,6 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	kmemleak_early_log = 0;
-
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
 		kmemleak_disable();
@@ -1833,8 +1831,9 @@ void __init kmemleak_init(void)
 	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
-	} else
-		kmemleak_enabled = 1;
+	}
+	kmemleak_early_log = 0;
+	kmemleak_enabled = 1;
 	local_irq_restore(flags);
 
 	/*
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-kmemleakc-use-%u-to-print-checksum.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-update-the-kmemleak-stack-trace-for-mempool-allocations.patch
mm-call-kmemleak-directly-from-memblock_allocfree.patch
documentation-devicetree-bindings-add-documentation-for-the-apm-x-gene-soc-rtc-dts-binding.patch
drivers-rtc-add-apm-x-gene-soc-rtc-driver.patch
arm64-add-apm-x-gene-soc-rtc-dts-entry.patch
linux-next.patch

