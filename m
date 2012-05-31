From: akpm@linux-foundation.org
Subject: [merged] mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch removed from -mm tree
Date: Thu, 31 May 2012 12:14:03 -0700
Message-ID: <20120531191403.6878BA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51543 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab2EaTOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:14:04 -0400
Received: by mail-fa0-f74.google.com with SMTP id a25so75194faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:14:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use kcalloc() instead of kzalloc() to allocate array
has been removed from the -mm tree.  Its filename was
     mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: mm: use kcalloc() instead of kzalloc() to allocate array

The advantage of kcalloc is, that will prevent integer overflows which
could result from the multiplication of number of elements and size and it
is also a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~mm-use-kcalloc-instead-of-kzalloc-to-allocate-array mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-kcalloc-instead-of-kzalloc-to-allocate-array
+++ a/mm/vmalloc.c
@@ -2375,8 +2375,8 @@ struct vm_struct **pcpu_get_vm_areas(con
 		return NULL;
 	}
 
-	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
-	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
+	vms = kcalloc(nr_vms, sizeof(vms[0]), GFP_KERNEL);
+	vas = kcalloc(nr_vms, sizeof(vas[0]), GFP_KERNEL);
 	if (!vas || !vms)
 		goto err_free2;
 
_

Patches currently in -mm which might be from thomas@m3y3r.de are

origin.patch

