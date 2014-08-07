From: akpm@linux-foundation.org
Subject: [merged] slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:03:31 -0700
Message-ID: <53e3db93.6ecRp8ZRZSyTqA7S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:63157 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaHGUDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:32 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so843811obc.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:03:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix the alias count (via sysfs) of slab cache
has been removed from the -mm tree.  Its filename was
     slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: slab: fix the alias count (via sysfs) of slab cache

We mark some slab caches (e.g.  kmem_cache_node) as unmergeable by
setting refcount to -1, and their alias should be 0, not refcount-1, so
correct it here.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slab-fix-the-alias-countvia-sysfs-of-slab-cache mm/slub.c
--- a/mm/slub.c~slab-fix-the-alias-countvia-sysfs-of-slab-cache
+++ a/mm/slub.c
@@ -4466,7 +4466,7 @@ SLAB_ATTR_RO(ctor);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->refcount - 1);
+	return sprintf(buf, "%d\n", s->refcount < 0 ? 0 : s->refcount - 1);
 }
 SLAB_ATTR_RO(aliases);
 
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

origin.patch
x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
linux-next.patch

