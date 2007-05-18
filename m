From: akpm@linux-foundation.org
Subject: - make-__vunmap-static.patch removed from -mm tree
Date: Fri, 18 May 2007 00:06:09 -0700
Message-ID: <200705180706.l4I768M0010149@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbXERHHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Make __vunmap static
has been removed from the -mm tree.  Its filename was
     make-__vunmap-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make __vunmap static
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

__vunmap doesn't seem to be used outside of mm/vmalloc.c, and has
no prototype in any header so let's make it static

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~make-__vunmap-static mm/vmalloc.c
--- a/mm/vmalloc.c~make-__vunmap-static
+++ a/mm/vmalloc.c
@@ -311,7 +311,7 @@ struct vm_struct *remove_vm_area(void *a
 	return v;
 }
 
-void __vunmap(void *addr, int deallocate_pages)
+static void __vunmap(void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
do-not-select-macintosh-drivers-by-default.patch
8xx-mpc885ads-pcmcia-support.patch
8xx-mpc885ads-pcmcia-support-fix.patch
8xx-fix-whitespace-and-indentation.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
unmap_vm_area-becomes-unmap_kernel_range.patch
make-map_vm_area-static.patch
