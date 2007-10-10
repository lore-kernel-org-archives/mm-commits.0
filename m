From: akpm@linux-foundation.org
Subject: - aio-fix-cleanup-in-io_submit_one.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:18 -0700
Message-ID: <200710102110.l9ALAIqe025918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293AbXJJVKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanzheng@21cn.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     AIO: fix cleanup in io_submit_one(...)
has been removed from the -mm tree.  Its filename was
     aio-fix-cleanup-in-io_submit_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: AIO: fix cleanup in io_submit_one(...)
From: "Yan Zheng" <yanzheng@21cn.com>

When IOCB_FLAG_RESFD flag is set and iocb->aio_resfd is incorrect,
statement 'goto out_put_req' is executed. At label 'out_put_req',
aio_put_req(..) is called, which requires 'req->ki_filp' set.

Signed-off-by: Yan Zheng<yanzheng@21cn.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/aio.c~aio-fix-cleanup-in-io_submit_one fs/aio.c
--- a/fs/aio.c~aio-fix-cleanup-in-io_submit_one
+++ a/fs/aio.c
@@ -1562,6 +1562,7 @@ int fastcall io_submit_one(struct kioctx
 		fput(file);
 		return -EAGAIN;
 	}
+	req->ki_filp = file;
 	if (iocb->aio_flags & IOCB_FLAG_RESFD) {
 		/*
 		 * If the IOCB_FLAG_RESFD flag of aio_flags is set, get an
@@ -1576,7 +1577,6 @@ int fastcall io_submit_one(struct kioctx
 		}
 	}
 
-	req->ki_filp = file;
 	ret = put_user(req->ki_key, &user_iocb->aio_key);
 	if (unlikely(ret)) {
 		dprintk("EFAULT: aio_key\n");
_

Patches currently in -mm which might be from yanzheng@21cn.com are

anon-inodes-use-open-coded-atomic_inc-for-the-shared-inode.patch
