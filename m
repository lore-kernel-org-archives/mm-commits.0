From: akpm@linux-foundation.org
Subject: - get_unmapped_area-handles-map_fixed-on-alpha.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:56 -0700
Message-ID: <200705080003.l4803uBg008973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967354AbXEHAE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     get_unmapped_area handles MAP_FIXED on alpha
has been removed from the -mm tree.  Its filename was
     get_unmapped_area-handles-map_fixed-on-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: get_unmapped_area handles MAP_FIXED on alpha
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Handle MAP_FIXED in alpha's arch_get_unmapped_area(), simple case, just return
the address as passed in

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/osf_sys.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/alpha/kernel/osf_sys.c~get_unmapped_area-handles-map_fixed-on-alpha arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~get_unmapped_area-handles-map_fixed-on-alpha
+++ a/arch/alpha/kernel/osf_sys.c
@@ -1267,6 +1267,9 @@ arch_get_unmapped_area(struct file *filp
 	if (len > limit)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* First, see if the given suggestion fits.
 
 	   The OSF/1 loader (/sbin/loader) relies on us returning an
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
