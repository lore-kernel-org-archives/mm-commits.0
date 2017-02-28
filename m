From: akpm@linux-foundation.org
Subject: [merged] zswap-dont-param_set_charp-while-holding-spinlock.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:49:36 -0800
Message-ID: <58b5e260.5yLbEmLTfkG70D9p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdB1Vax (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 16:30:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap: don't param_set_charp while holding spinlock
has been removed from the -mm tree.  Its filename was
     zswap-dont-param_set_charp-while-holding-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: zswap: don't param_set_charp while holding spinlock

Change the zpool/compressor param callback function to release the
zswap_pools_lock spinlock before calling param_set_charp, since that
function may sleep when it calls kmalloc with GFP_KERNEL.

While this problem has existed for a while, I wasn't able to trigger it
using a tight loop changing either/both the zpool and compressor params; I
think it's very unlikely to be an issue on the stable kernels, especially
since most zswap users will change the compressor and/or zpool from sysfs
only one time each boot - or zero times, if they add the params to the
kernel boot.

Fixes: c99b42c3529e ("zswap: use charp for zswap param strings")
Link: http://lkml.kernel.org/r/20170126155821.4545-1-ddstreet@ieee.org
Signed-off-by: Dan Streetman <dan.streetman@canonical.com>
Reported-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/zswap.c~zswap-dont-param_set_charp-while-holding-spinlock mm/zswap.c
--- a/mm/zswap.c~zswap-dont-param_set_charp-while-holding-spinlock
+++ a/mm/zswap.c
@@ -704,18 +704,22 @@ static int __zswap_param_set(const char
 	pool = zswap_pool_find_get(type, compressor);
 	if (pool) {
 		zswap_pool_debug("using existing", pool);
+		WARN_ON(pool == zswap_pool_current());
 		list_del_rcu(&pool->list);
-	} else {
-		spin_unlock(&zswap_pools_lock);
-		pool = zswap_pool_create(type, compressor);
-		spin_lock(&zswap_pools_lock);
 	}
 
+	spin_unlock(&zswap_pools_lock);
+
+	if (!pool)
+		pool = zswap_pool_create(type, compressor);
+
 	if (pool)
 		ret = param_set_charp(s, kp);
 	else
 		ret = -EINVAL;
 
+	spin_lock(&zswap_pools_lock);
+
 	if (!ret) {
 		put_pool = zswap_pool_current();
 		list_add_rcu(&pool->list, &zswap_pools);
@@ -727,7 +731,11 @@ static int __zswap_param_set(const char
 		 */
 		list_add_tail_rcu(&pool->list, &zswap_pools);
 		put_pool = pool;
-	} else if (!zswap_has_pool) {
+	}
+
+	spin_unlock(&zswap_pools_lock);
+
+	if (!zswap_has_pool && !pool) {
 		/* if initial pool creation failed, and this pool creation also
 		 * failed, maybe both compressor and zpool params were bad.
 		 * Allow changing this param, so pool creation will succeed
@@ -738,8 +746,6 @@ static int __zswap_param_set(const char
 		ret = param_set_charp(s, kp);
 	}
 
-	spin_unlock(&zswap_pools_lock);
