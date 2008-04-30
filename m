From: akpm@linux-foundation.org
Subject: - aio-remove-misleading-comment-from-ioctx_lookup.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:46 -0700
Message-ID: <200804300549.m3U5nkqG030030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759035AbYD3Fun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, shen@cn.fujitsu.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: fix misleading comments
has been removed from the -mm tree.  Its filename was
     aio-remove-misleading-comment-from-ioctx_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: fix misleading comments
From: Jeff Moyer <jmoyer@redhat.com>

The FIXME comments are inaccurate.
The locking comment over lookup_ioctx() is wrong.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/aio.c~aio-remove-misleading-comment-from-ioctx_lookup fs/aio.c
--- a/fs/aio.c~aio-remove-misleading-comment-from-ioctx_lookup
+++ a/fs/aio.c
@@ -277,7 +277,7 @@ static struct kioctx *ioctx_alloc(unsign
 	if (ctx->max_reqs == 0)
 		goto out_cleanup;
 
-	/* now link into global list.  kludge.  FIXME */
+	/* now link into global list. */
 	write_lock(&mm->ioctx_list_lock);
 	ctx->next = mm->ioctx_list;
 	mm->ioctx_list = ctx;
@@ -553,9 +553,6 @@ int aio_put_req(struct kiocb *req)
 	return ret;
 }
 
-/*	Lookup an ioctx id.  ioctx_list is lockless for reads.
- *	FIXME: this is O(n) and is only suitable for development.
- */
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct kioctx *ioctx;
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch

