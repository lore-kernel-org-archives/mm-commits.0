From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-frv.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:00 -0700
Message-ID: <200705080004.l48040Ln008979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967352AbXEHAE2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on frv
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-frv.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on frv
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in arch_get_unmapped_area on frv.  Trivial case, just return
the address.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/elf-fdpic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/frv/mm/elf-fdpic.c~get_unmapped_area-handles-map_fixed-on-frv arch/frv/mm/elf-fdpic.c
--- a/arch/frv/mm/elf-fdpic.c~get_unmapped_area-handles-map_fixed-on-frv
+++ a/arch/frv/mm/elf-fdpic.c
@@ -64,6 +64,10 @@ unsigned long arch_get_unmapped_area(str
 	if (len > TASK_SIZE)
 		return -ENOMEM;
 
+	/* handle MAP_FIXED */
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* only honour a hint if we're not going to clobber something doing so */
 	if (addr) {
 		addr = PAGE_ALIGN(addr);
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
