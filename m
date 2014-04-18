From: akpm@linux-foundation.org
Subject: + memcg-un-export-__memcg_kmem_get_cache.patch added to -mm tree
Date: Fri, 18 Apr 2014 13:09:16 -0700
Message-ID: <5351866c.V8Up8THUBsQUGVsy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRUJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 16:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com

Subject: + memcg-un-export-__memcg_kmem_get_cache.patch added to -mm tree
To: vdavydov@parallels.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 13:09:16 -0700


The patch titled
     Subject: memcg: un-export __memcg_kmem_get_cache
has been added to the -mm tree.  Its filename is
     memcg-un-export-__memcg_kmem_get_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-un-export-__memcg_kmem_get_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-un-export-__memcg_kmem_get_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: un-export __memcg_kmem_get_cache

It is only used in slab and should not be used anywhere else so there is
no need in exporting it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-un-export-__memcg_kmem_get_cache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-un-export-__memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -3504,7 +3504,6 @@ out:
 	rcu_read_unlock();
 	return cachep;
 }
-EXPORT_SYMBOL(__memcg_kmem_get_cache);
 
 /*
  * We need to verify if the allocation against current->mm->owner's memcg is
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slub-fix-memcg_propagate_slab_attrs.patch
slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
mm-get-rid-of-__gfp_kmemcg-fix.patch
slab-document-kmalloc_order.patch
memcg-un-export-__memcg_kmem_get_cache.patch

