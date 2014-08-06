From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch removed from -mm
 tree
Date: Wed, 06 Aug 2014 15:48:16 -0700
Message-ID: <53e2b0b0.91PELJt5H6aQ/nEK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34337 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaHFWsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:48:17 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so614438obc.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:48:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chaowang@redhat.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmallocc-clean-up-map_vm_area-third-argument-v2
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-clean-up-map_vm_area-third-argument-v2.patch

This patch was dropped because it was folded into mm-vmallocc-clean-up-map_vm_area-third-argument.patch

------------------------------------------------------
From: WANG Chao <chaowang@redhat.com>
Subject: mm-vmallocc-clean-up-map_vm_area-third-argument-v2

v2: Fix arch/tile/kernel/module.c::module_alloc().

Signed-off-by: WANG Chao <chaowang@redhat.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/tile/kernel/module.c~mm-vmallocc-clean-up-map_vm_area-third-argument-v2 arch/tile/kernel/module.c
--- a/arch/tile/kernel/module.c~mm-vmallocc-clean-up-map_vm_area-third-argument-v2
+++ a/arch/tile/kernel/module.c
@@ -58,7 +58,7 @@ void *module_alloc(unsigned long size)
 	area->nr_pages = npages;
 	area->pages = pages;
 
-	if (map_vm_area(area, prot_rwx, &pages)) {
+	if (map_vm_area(area, prot_rwx, pages)) {
 		vunmap(area->addr);
 		goto error;
 	}
_

Patches currently in -mm which might be from chaowang@redhat.com are

mm-vmallocc-clean-up-map_vm_area-third-argument.patch

