From: akpm@linux-foundation.org
Subject: - leak-in-do_ubd_request.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:22:27 -0800
Message-ID: <200712010022.lB10MRAJ031892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757371AbXLAA1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:27:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, jdike@addtoit.com, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     leak in do_ubd_request
has been removed from the -mm tree.  Its filename was
     leak-in-do_ubd_request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: leak in do_ubd_request
From: Miklos Szeredi <miklos@szeredi.hu>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/drivers/ubd_kern.c~leak-in-do_ubd_request arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~leak-in-do_ubd_request
+++ a/arch/um/drivers/ubd_kern.c
@@ -1128,6 +1128,7 @@ static void do_ubd_request(struct reques
 					       "errno = %d\n", -n);
 				else if(list_empty(&dev->restart))
 					list_add(&dev->restart, &restart);
+				kfree(io_req);
 				return;
 			}
 
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
