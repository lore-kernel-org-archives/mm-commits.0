From: akpm@linux-foundation.org
Subject: + mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch added to -mm tree
Date: Fri, 20 Apr 2012 13:08:31 -0700
Message-ID: <20120420200832.3A640A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62757 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2DTUIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 16:08:34 -0400
Received: by wejx9 with SMTP id x9so477027wej.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 13:08:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de


The patch titled
     Subject: mm: use kcalloc() instead of kzalloc() to allocate array
has been added to the -mm tree.  Its filename is
     mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: use kcalloc() instead of kzalloc() to allocate array

Patches currently in -mm which might be from thomas@m3y3r.de are

linux-next.patch
mm-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch
leds-use-kcalloc-instead-of-kzalloc-to-allocate-array.patch

