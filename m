From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:08 -0800
Message-ID: <20120113203609.0BF0D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40171 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759146Ab2AMUgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:10 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt14so106252wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path

If either of the vas or vms arrays are not properly kzalloced, then the
code jumps to the err_free label.

The err_free label runs a loop to check and free each of the array members
of the vas and vms arrays which is not required for this situation as none
of the array members have been allocated till this point.

Eliminate the extra loop we have to go through by introducing a new label
err_free2 and then jumping to it.

[akpm@linux-foundation.org: remove now-unneeded tests]
Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path
+++ a/mm/vmalloc.c
@@ -2378,7 +2378,7 @@ struct vm_struct **pcpu_get_vm_areas(con
 	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
 	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
 	if (!vas || !vms)
-		goto err_free;
+		goto err_free2;
 
 	for (area = 0; area < nr_vms; area++) {
 		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
@@ -2476,11 +2476,10 @@ found:
 
 err_free:
 	for (area = 0; area < nr_vms; area++) {
-		if (vas)
-			kfree(vas[area]);
-		if (vms)
-			kfree(vms[area]);
+		kfree(vas[area]);
+		kfree(vms[area]);
 	}
+err_free2:
 	kfree(vas);
 	kfree(vms);
 	return NULL;
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

origin.patch

