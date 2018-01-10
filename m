From: akpm@linux-foundation.org
Subject: + zswap-only-save-zswap-header-when-necessary-v3.patch added to
 -mm tree
Date: Wed, 10 Jan 2018 15:37:28 -0800
Message-ID: <5a56a3b8.IwLKkxtVK7cD1gYS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbeAJXhc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 18:37:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, ddstreet@ieee.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, sjenning@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-only-save-zswap-header-when-necessary-v3
has been added to the -mm tree.  Its filename is
     zswap-only-save-zswap-header-when-necessary-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zswap-only-save-zswap-header-when-necessary-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zswap-only-save-zswap-header-when-necessary-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: zswap-only-save-zswap-header-when-necessary-v3

The zpool->" prefix is a result out copy & paste.

Link: http://lkml.kernel.org/r/20180110225626.110330-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zpool.c~zswap-only-save-zswap-header-when-necessary-v3 mm/zpool.c
--- a/mm/zpool.c~zswap-only-save-zswap-header-when-necessary-v3
+++ a/mm/zpool.c
@@ -181,8 +181,7 @@ struct zpool *zpool_create_pool(const ch
 	zpool->driver = driver;
 	zpool->pool = driver->create(name, gfp, ops, zpool);
 	zpool->ops = ops;
-	zpool->evictable = zpool->driver->shrink &&
-			   zpool->ops && zpool->ops->evict;
+	zpool->evictable = driver->shrink && ops && ops->evict;
 
 	if (!zpool->pool) {
 		pr_err("couldn't create %s pool\n", type);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-dont-expose-page-to-fast-gup-before-its-ready.patch
zswap-only-save-zswap-header-when-necessary.patch
zswap-only-save-zswap-header-when-necessary-v3.patch
memcg-refactor-mem_cgroup_resize_limit.patch

