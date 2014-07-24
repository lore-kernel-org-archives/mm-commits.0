From: akpm@linux-foundation.org
Subject: + slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch added to
 -mm tree
Date: Thu, 24 Jul 2014 15:16:37 -0700
Message-ID: <53d185c5.sDe+ARbLv2grJwoA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:49916 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaGXWQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 18:16:38 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so954679pde.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 15:16:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guz.fnst@cn.fujitsu.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: fix the alias count (via sysfs) of slab cache
has been added to the -mm tree.  Its filename is
     slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -4468,7 +4468,7 @@ SLAB_ATTR_RO(ctor);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->refcount - 1);
+	return sprintf(buf, "%d\n", s->refcount < 0 ? 0 : s->refcount - 1);
 }
 SLAB_ATTR_RO(aliases);
 
_

Patches currently in -mm which might be from guz.fnst@cn.fujitsu.com are

x86mem-hotplug-pass-sync_global_pgds-a-correct-argument-in-remove_pagetable.patch
x86mem-hotplug-modify-pgd-entry-when-removing-memory.patch
bio-integrity-remove-the-needless-fail-handle-of-bip_slab-creating.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
mem-hotplug-avoid-illegal-state-prefixed-with-legal-state-when-changing-state-of-memory_block.patch
mem-hotplug-introduce-mmop_offline-to-replace-the-hard-coding-1.patch
linux-next.patch

