From: akpm@linux-foundation.org
Subject: + mm-fix-faulty-initialization-in-vmalloc_init.patch added to -mm tree
Date: Thu, 24 May 2012 15:12:43 -0700
Message-ID: <20120524221243.8D664A0397@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35528 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329Ab2EXWMp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 May 2012 18:12:45 -0400
Received: by vcbfl13 with SMTP id fl13so32982vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 24 May 2012 15:12:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pullip.cho@samsung.com


The patch titled
     Subject: mm: fix faulty initialization in vmalloc_init()
has been added to the -mm tree.  Its filename is
     mm-fix-faulty-initialization-in-vmalloc_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KyongHo <pullip.cho@samsung.com>
Subject: mm: fix faulty initialization in vmalloc_init()

vmalloc_init() adds 'vmap_area's for early 'vm_struct's.  This patch fixes
vmalloc_init() to correctly initialize vmap_area for the given vm_struct.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-fix-faulty-initialization-in-vmalloc_init mm/vmalloc.c
--- a/mm/vmalloc.c~mm-fix-faulty-initialization-in-vmalloc_init
+++ a/mm/vmalloc.c
@@ -1185,9 +1185,10 @@ void __init vmalloc_init(void)
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
 		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
-		va->flags = tmp->flags | VM_VM_AREA;
+		va->flags = VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
+		va->vm = tmp;
 		__insert_vmap_area(va);
 	}
 
_
Subject: Subject: mm: fix faulty initialization in vmalloc_init()

Patches currently in -mm which might be from pullip.cho@samsung.com are

linux-next.patch
mm-fix-faulty-initialization-in-vmalloc_init.patch

