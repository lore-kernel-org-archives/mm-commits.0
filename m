From: akpm@linux-foundation.org
Subject: [merged] lru_cache-use-correct-type-in-sizeof-for-allocation.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:08 -0700
Message-ID: <201105252030.p4PKUVsP014970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932207Ab1EYUbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:31:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imirkin@alum.mit.edu, lars@linbit.com, mm-commits@vger.kernel.org


The patch titled
     lru_cache: use correct type in sizeof for allocation
has been removed from the -mm tree.  Its filename was
     lru_cache-use-correct-type-in-sizeof-for-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lru_cache: use correct type in sizeof for allocation
From: Ilia Mirkin <imirkin@alum.mit.edu>

This has no actual effect, since sizeof(struct hlist_head) ==
sizeof(struct hlist_head *), but it's still the wrong type to use.

The semantic match that finds this problem:
// <smpl>
@@
type T;
identifier x;
@@
T *x;
...
* x = kzalloc(... * sizeof(T*) * ..., ...);
// </smpl>

[akpm@linux-foundation.org: use kcalloc()]
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Acked-by: Lars Ellenberg <lars@linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/lru_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation lib/lru_cache.c
--- a/lib/lru_cache.c~lru_cache-use-correct-type-in-sizeof-for-allocation
+++ a/lib/lru_cache.c
@@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *
 	if (e_count > LC_MAX_ACTIVE)
 		return NULL;
 
-	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
+	slot = kcalloc(e_count, sizeof(struct hlist_head), GFP_KERNEL);
 	if (!slot)
 		goto out_fail;
 	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
_

Patches currently in -mm which might be from imirkin@alum.mit.edu are

origin.patch

