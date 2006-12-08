From: akpm@osdl.org
Subject: + cpu-hotplug-broken-with-2gb-vmsplit.patch added to -mm tree
Date: Fri, 08 Dec 2006 01:34:17 -0800
Message-ID: <200612080934.kB89YHYa015077@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41531 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425287AbWLHJe0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, jens.axboe@oracle.com


The patch titled
     CPU hotplug broken with 2GB VMSPLIT
has been added to the -mm tree.  Its filename is
     cpu-hotplug-broken-with-2gb-vmsplit.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CPU hotplug broken with 2GB VMSPLIT
From: Shaohua Li <shaohua.li@intel.com>

In VMSPLIT mode, kernel PGD might have more entries than user space.

Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smpboot.c~cpu-hotplug-broken-with-2gb-vmsplit arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~cpu-hotplug-broken-with-2gb-vmsplit
+++ a/arch/i386/kernel/smpboot.c
@@ -1118,7 +1118,7 @@ static int __cpuinit __smp_prepare_cpu(i
 
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			KERNEL_PGD_PTRS);
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
 	flush_tlb_all();
 	schedule_work(&info.task);
 	wait_for_completion(&done);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
cpu-hotplug-broken-with-2gb-vmsplit.patch

