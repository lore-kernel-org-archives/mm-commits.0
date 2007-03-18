From: akpm@linux-foundation.org
Subject: - smbfs-double-free-memory-corruption.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:43 -0800
Message-ID: <200703180909.l2I99hhc020033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60493 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXCRJKV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vvs@sw.ru, mm-commits@vger.kernel.org


The patch titled
     smbfs: double free memory corruption
has been removed from the -mm tree.  Its filename was
     smbfs-double-free-memory-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smbfs: double free memory corruption
From: Vasily Averin <vvs@sw.ru>

smbfs allocates rq_trans2buffer to handle server's multi transaction2 response
messages.  As struct smb_request may be reused, rq_trans2buffer is freed
before each new request.  However if last servers's response is not multi but
single trans2 message then new rq_trans2buffer is not allocated but last
smb_rput still tries to free it again.

To prevent this issue rq_trans2buffer pointer should be set to NULL after
kfree.

Signed-off-by:	Vasily Averin <vvs@sw.ru>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/request.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/smbfs/request.c~smbfs-double-free-memory-corruption fs/smbfs/request.c
--- a/fs/smbfs/request.c~smbfs-double-free-memory-corruption
+++ a/fs/smbfs/request.c
@@ -181,6 +181,7 @@ static int smb_setup_request(struct smb_
 	req->rq_errno = 0;
 	req->rq_fragment = 0;
 	kfree(req->rq_trans2buffer);
+	req->rq_trans2buffer = NULL;
 
 	return 0;
 }
_

Patches currently in -mm which might be from vvs@sw.ru are

origin.patch
