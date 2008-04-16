From: akpm@linux-foundation.org
Subject: + aio-remove-misleading-comment-from-ioctx_lookup.patch added to -mm tree
Date: Tue, 15 Apr 2008 18:53:41 -0700
Message-ID: <200804160153.m3G1rffe026780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbYDPByu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 21:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, shen@cn.fujitsu.com, zach.brown@oracle.com


The patch titled
     aio: fix misleading comments
has been added to the -mm tree.  Its filename is
     aio-remove-misleading-comment-from-ioctx_lookup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -240,7 +240,7 @@ static struct kioctx *ioctx_alloc(unsign
 	if (ctx->max_reqs == 0)
 		goto out_cleanup;
 
-	/* now link into global list.  kludge.  FIXME */
+	/* now link into global list. */
 	write_lock(&mm->ioctx_list_lock);
 	ctx->next = mm->ioctx_list;
 	mm->ioctx_list = ctx;
@@ -542,9 +542,6 @@ int aio_put_req(struct kiocb *req)
 	return ret;
 }
 
-/*	Lookup an ioctx id.  ioctx_list is lockless for reads.
- *	FIXME: this is O(n) and is only suitable for development.
- */
 struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
 	struct kioctx *ioctx;
_

Patches currently in -mm which might be from jmoyer@redhat.com are

aio-io_getevents-should-return-if-io_destroy-is-invoked.patch
aio-remove-misleading-comment-from-ioctx_lookup.patch

