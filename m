From: akpm@linux-foundation.org
Subject: + smbfs-double-free-memory-corruption.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:22 -0800
Message-ID: <200703151848.l2FImOWm023240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbXCOStC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:49:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru


The patch titled
     smbfs: double free memory corruption
has been added to the -mm tree.  Its filename is
     smbfs-double-free-memory-corruption.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

smbfs-double-free-memory-corruption.patch
