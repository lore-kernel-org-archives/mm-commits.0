From: akpm@linux-foundation.org
Subject: + mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
 added to -mm tree
Date: Tue, 13 Jan 2015 15:49:30 -0800
Message-ID: <54b5af0a.6idHeo/XODae8f3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbAMXtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 18:49:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: convert cache name allocations to kstrdup_const
has been added to the -mm tree.  Its filename is
     mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrzej Hajda <a.hajda@samsung.com>
Subject: mm/slab: convert cache name allocations to kstrdup_const

slab frequently performs duplication of strings located in read-only
memory section.  Replacing kstrdup by kstrdup_const allows to avoid such
operations.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const
+++ a/mm/slab_common.c
@@ -388,7 +388,7 @@ kmem_cache_create(const char *name, size
 	if (s)
 		goto out_unlock;
 
-	cache_name = kstrdup(name, GFP_KERNEL);
+	cache_name = kstrdup_const(name, GFP_KERNEL);
 	if (!cache_name) {
 		err = -ENOMEM;
 		goto out_unlock;
@@ -399,7 +399,7 @@ kmem_cache_create(const char *name, size
 				 flags, ctor, NULL, NULL);
 	if (IS_ERR(s)) {
 		err = PTR_ERR(s);
-		kfree(cache_name);
+		kfree_const(cache_name);
 	}
 
 out_unlock:
@@ -565,7 +565,7 @@ void memcg_destroy_kmem_caches(struct me
 void slab_kmem_cache_release(struct kmem_cache *s)
 {
 	memcg_free_cache_params(s);
-	kfree(s->name);
+	kfree_const(s->name);
 	kmem_cache_free(kmem_cache, s);
 }
 
_

Patches currently in -mm which might be from a.hajda@samsung.com are

mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch

