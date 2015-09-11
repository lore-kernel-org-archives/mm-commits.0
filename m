From: akpm@linux-foundation.org
Subject: + zram-fix-possible-use-after-free-in-zcomp_create.patch added to -mm tree
Date: Fri, 11 Sep 2015 14:56:17 -0700
Message-ID: <55f34e01.8I4DmobmKKibXcoZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbIKV4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 17:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luis.henriques@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix possible use after free in zcomp_create()
has been added to the -mm tree.  Its filename is
     zram-fix-possible-use-after-free-in-zcomp_create.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-possible-use-after-free-in-zcomp_create.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-possible-use-after-free-in-zcomp_create.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Henriques <luis.henriques@canonical.com>
Subject: zram: fix possible use after free in zcomp_create()

zcomp_create() verifies the success of zcomp_strm_{multi,single}_create()
through comp->stream, which can potentially be pointing to memory that was
freed if these functions returned an error.

While at it, replace a 'ERR_PTR(-ENOMEM)' by a more generic
'ERR_PTR(error)' as in the future zcomp_strm_{multi,siggle}_create() could
return other error codes.  Function documentation updated accordingly.

Fixes: beca3ec71fe5 ("zram: add multi stream functionality")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-fix-possible-use-after-free-in-zcomp_create drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-fix-possible-use-after-free-in-zcomp_create
+++ a/drivers/block/zram/zcomp.c
@@ -330,12 +330,14 @@ void zcomp_destroy(struct zcomp *comp)
  * allocate new zcomp and initialize it. return compressing
  * backend pointer or ERR_PTR if things went bad. ERR_PTR(-EINVAL)
  * if requested algorithm is not supported, ERR_PTR(-ENOMEM) in
- * case of allocation error.
+ * case of allocation error, or any other error potentially
+ * returned by functions zcomp_strm_{multi,single}_create.
  */
 struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
 	struct zcomp *comp;
 	struct zcomp_backend *backend;
+	int error;
 
 	backend = find_backend(compress);
 	if (!backend)
@@ -347,12 +349,12 @@ struct zcomp *zcomp_create(const char *c
 
 	comp->backend = backend;
 	if (max_strm > 1)
-		zcomp_strm_multi_create(comp, max_strm);
+		error = zcomp_strm_multi_create(comp, max_strm);
 	else
-		zcomp_strm_single_create(comp);
-	if (!comp->stream) {
+		error = zcomp_strm_single_create(comp);
+	if (error) {
 		kfree(comp);
-		return ERR_PTR(-ENOMEM);
+		return ERR_PTR(error);
 	}
 	return comp;
 }
_

Patches currently in -mm which might be from luis.henriques@canonical.com are

zram-fix-possible-use-after-free-in-zcomp_create.patch

