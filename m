From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-x86_64.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:10 -0700
Message-ID: <200705080004.l4804AdX008994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967352AbXEHAEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on x86_64
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on x86_64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in x86_64 arch_get_unmapped_area(), simple case, just return
the address as passed in

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/sys_x86_64.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86_64/kernel/sys_x86_64.c~get_unmapped_area-handles-map_fixed-on-x86_64 arch/x86_64/kernel/sys_x86_64.c
--- a/arch/x86_64/kernel/sys_x86_64.c~get_unmapped_area-handles-map_fixed-on-x86_64
+++ a/arch/x86_64/kernel/sys_x86_64.c
@@ -93,6 +93,9 @@ arch_get_unmapped_area(struct file *filp
 	unsigned long start_addr;
 	unsigned long begin, end;
 	
+	if (flags & MAP_FIXED)
+		return addr;
+
 	find_start_end(flags, &begin, &end); 
 
 	if (len > end)
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed-powerpc-fixes.patch
use-slab_panic-flag-cleanup.patch
the-scheduled-removal-of-obsolete_oss-options.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
parport-dev-driver-model-support.patch
introduce-freezer-flags-rev-2.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-powerpc-optimization.patch
aty128fb-fix-blanking.patch
radeonfb-add-support-for-radeon-xpress-200m.patch
