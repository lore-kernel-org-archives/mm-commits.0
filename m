From: akpm@linux-foundation.org
Subject: - uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch removed from -mm tree
Date: Mon, 07 May 2007 17:07:17 -0700
Message-ID: <200705080007.l4807Hhr009267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967391AbXEHAHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pzijlstr@redhat.com, a.p.zijlstra@chello.nl, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: fixup allocation in the ubd driver
has been removed from the -mm tree.  Its filename was
     uml-send-pointers-instead-of-structures-to-i-o-thread-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fixup allocation in the ubd driver
From: Peter Zijlstra <pzijlstr@redhat.com>

Sanitise gfp flags; it actually is an atomic context, so drop the
GFP_KERNEL part.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-send-pointers-instead-of-structures-to-i-o-thread-fix arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-send-pointers-instead-of-structures-to-i-o-thread-fix
+++ a/arch/um/drivers/ubd_kern.c
@@ -1102,7 +1102,7 @@ static void do_ubd_request(request_queue
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
 			io_req = kmalloc(sizeof(struct io_thread_req),
-					 GFP_KERNEL | GFP_ATOMIC);
+					 GFP_ATOMIC);
 			if(io_req == NULL){
 				if(list_empty(&dev->restart))
 					list_add(&dev->restart, &restart);
_

Patches currently in -mm which might be from pzijlstr@redhat.com are

origin.patch
