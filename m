From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 14:28:31 -0800
Message-ID: <54de7a8f.UaKNKX/YkDhUeKsM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMW2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:28:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.hajda@samsung.com, cl@linux.com, geert@linux-m68k.org, greg@kroah.com, iamjoonsoo.kim@lge.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mturquette@linaro.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix
has been removed from the -mm tree.  Its filename was
     mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch

This patch was dropped because it was folded into mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix

mm/slab_common.c:391: warning: assignment discards qualifiers from pointer target type

make the handling of kmem_cache.name const-correct

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <greg@kroah.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix mm/slab_common.c
--- a/mm/slab_common.c~mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix
+++ a/mm/slab_common.c
@@ -295,8 +295,8 @@ unsigned long calculate_alignment(unsign
 }
 
 static struct kmem_cache *
-do_kmem_cache_create(char *name, size_t object_size, size_t size, size_t align,
-		     unsigned long flags, void (*ctor)(void *),
+do_kmem_cache_create(const char *name, size_t object_size, size_t size,
+		     size_t align, unsigned long flags, void (*ctor)(void *),
 		     struct mem_cgroup *memcg, struct kmem_cache *root_cache)
 {
 	struct kmem_cache *s;
@@ -363,7 +363,7 @@ kmem_cache_create(const char *name, size
 		  unsigned long flags, void (*ctor)(void *))
 {
 	struct kmem_cache *s;
-	char *cache_name;
+	const char *cache_name;
 	int err;
 
 	get_online_cpus();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
module_device_table-fix-some-callsites.patch
kasan-enable-instrumentation-of-global-variables-fix.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch

