From: akpm@linux-foundation.org
Subject: + add-check-do_direct_io-return-val.patch added to -mm tree
Date: Thu, 26 Jul 2007 22:14:08 -0700
Message-ID: <200707270514.l6R5E84g006900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45900 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757170AbXG0FPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 01:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe.jin@oracle.com, pbadari@us.ibm.com, stable@kernel.org, zach.brown@oracle.com


The patch titled
     add check do_direct_IO() return val
has been added to the -mm tree.  Its filename is
     add-check-do_direct_io-return-val.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add check do_direct_IO() return val
From: Joe Jin <joe.jin@oracle.com>

At do_direct_IO(), sometimes dio_get_page() will return -EFAULT/-ENOMEM,
according to orig source, it will go on left work. buf for dio_get_page()
return a error will made many useful member of dio not initialized like
dio->map_bh and others, at this point, kernel will panic.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/direct-io.c~add-check-do_direct_io-return-val fs/direct-io.c
--- a/fs/direct-io.c~add-check-do_direct_io-return-val
+++ a/fs/direct-io.c
@@ -1033,7 +1033,7 @@ direct_io_worker(int rw, struct kiocb *i
 
 		if (ret) {
 			dio_cleanup(dio);
-			break;
+			goto out;
 		}
 	} /* end iovec loop */
 
@@ -1112,7 +1112,7 @@ direct_io_worker(int rw, struct kiocb *i
 		kfree(dio);
 	} else
 		BUG_ON(ret != -EIOCBQUEUED);
-
+out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from joe.jin@oracle.com are

add-check-do_direct_io-return-val.patch
