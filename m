From: akpm@linux-foundation.org
Subject: - add-check-do_direct_io-return-val.patch removed from -mm tree
Date: Fri, 27 Jul 2007 23:31:22 -0700
Message-ID: <200707280636.l6S6a3fq029449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53453 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbXG1GgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Jul 2007 02:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.jin@oracle.com, pbadari@us.ibm.com, stable@kernel.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     add check do_direct_IO() return val
has been removed from the -mm tree.  Its filename was
     add-check-do_direct_io-return-val.patch

This patch was dropped because an updated version will be merged

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

 fs/direct-io.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/direct-io.c~add-check-do_direct_io-return-val fs/direct-io.c
--- a/fs/direct-io.c~add-check-do_direct_io-return-val
+++ a/fs/direct-io.c
@@ -1032,18 +1032,19 @@ direct_io_worker(int rw, struct kiocb *i
 					blkbits);
 
 		if (ret) {
+			if (ret == -ENOTBLK && (rw & WRITE)) {
+				/*
+				 * The remaining part of the request will be
+				 * be handled by buffered I/O when we return
+				 */
+				ret = 0;
+				break;
+			}
 			dio_cleanup(dio);
-			break;
+			goto out;
 		}
 	} /* end iovec loop */
 
-	if (ret == -ENOTBLK && (rw & WRITE)) {
-		/*
-		 * The remaining part of the request will be
-		 * be handled by buffered I/O when we return
-		 */
-		ret = 0;
-	}
 	/*
 	 * There may be some unwritten disk at the end of a part-written
 	 * fs-block-sized block.  Go zero that now.
_

Patches currently in -mm which might be from joe.jin@oracle.com are

add-check-do_direct_io-return-val.patch
