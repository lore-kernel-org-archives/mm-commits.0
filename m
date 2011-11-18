From: akpm@linux-foundation.org
Subject: + mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch added to -mm tree
Date: Fri, 18 Nov 2011 12:00:03 -0800
Message-ID: <201111182000.pAIK03Sh009025@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51276 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1KRUAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2011 15:00:07 -0500
Received: by eyg5 with SMTP id 5so81212eyg.1
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2011 12:00:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com


The patch titled
     Subject: mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path
has been added to the -mm tree.  Its filename is
     mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path
+++ a/mm/vmalloc.c
@@ -2351,7 +2351,7 @@ struct vm_struct **pcpu_get_vm_areas(con
 	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
 	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
 	if (!vas || !vms)
-		goto err_free;
+		goto err_free2;
 
 	for (area = 0; area < nr_vms; area++) {
 		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
@@ -2454,6 +2454,7 @@ err_free:
 		if (vms)
 			kfree(vms[area]);
 	}
+err_free2:
 	kfree(vas);
 	kfree(vms);
 	return NULL;
_
Subject: Subject: mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas error path

Patches currently in -mm which might be from consul.kautuk@gmail.com are

linux-next.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch

