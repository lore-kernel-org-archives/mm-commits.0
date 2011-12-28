From: akpm@linux-foundation.org
Subject: [merged] vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:49 -0800
Message-ID: <20111228220450.2FFBD5C0076@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:61594 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:51 -0500
Received: by mail-ee0-f74.google.com with SMTP id c1so429359eek.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2011 14:04:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: remove static declaration of va from __get_vm_area_node
has been removed from the -mm tree.  Its filename was
     vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: mm/vmalloc.c: remove static declaration of va from __get_vm_area_node

Static storage is not required for the struct vmap_area in
__get_vm_area_node.

Removing "static" to store this variable on the stack instead.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-remove-static-declaration-of-va-from-__get_vm_area_node
+++ a/mm/vmalloc.c
@@ -1290,7 +1290,7 @@ static struct vm_struct *__get_vm_area_n
 		unsigned long align, unsigned long flags, unsigned long start,
 		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
-	static struct vmap_area *va;
+	struct vmap_area *va;
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch

