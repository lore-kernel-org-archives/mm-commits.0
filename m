From: akpm@linux-foundation.org
Subject: + revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch added to -mm tree
Date: Wed, 11 Nov 2015 13:52:03 -0800
Message-ID: <5643b883.11lqHDIh4owqAotl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbbKKVwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 16:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, cl@linux.com, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "kernfs: do not account ino_ida allocations to memcg"
has been added to the -mm tree.  Its filename is
     revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Revert "kernfs: do not account ino_ida allocations to memcg"

Currently, all kmem allocations (namely every kmem_cache_alloc, kmalloc,
alloc_kmem_pages call) are accounted to memory cgroup automatically. 
Callers have to explicitly opt out if they don't want/need accounting for
some reason.  Such a design decision leads to several problems:

 - kmalloc users are highly sensitive to failures, many of them
   implicitly rely on the fact that kmalloc never fails, while memcg
   makes failures quite plausible.

 - A lot of objects are shared among different containers by design.
   Accounting such objects to one of containers is just unfair.
   Moreover, it might lead to pinning a dead memcg along with its kmem
   caches, which aren't tiny, which might result in noticeable increase
   in memory consumption for no apparent reason in the long run.

 - There are tons of short-lived objects. Accounting them to memcg will
   only result in slight noise and won't change the overall picture, but
   we still have to pay accounting overhead.

For more info, see

 - http://lkml.kernel.org/r/20151105144002.GB15111%40dhcp22.suse.cz
 - http://lkml.kernel.org/r/20151106090555.GK29259@esperanza

Therefore this patchset switches to the white list policy.  Now kmalloc
users have to explicitly opt in by passing __GFP_ACCOUNT flag.

Currently, the list of accounted objects is quite limited and only
includes those allocations that (1) are known to be easily triggered from
userspace and (2) can fail gracefully (for the full list see patch no.  6)
and it still misses many object types.  However, accounting only those
objects should be a satisfactory approximation of the behavior we used to
have for most sane workloads.


This patch (of 6):

Revert 499611ed451508a42d1d7d ("kernfs: do not account ino_ida allocations
to memcg").

Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
fragile and difficult to maintain, because there seem to be many more
allocations that should not be accounted than those that should be. 
Besides, false accounting an allocation might result in much worse
consequences than not accounting at all, namely increased memory
consumption due to pinned dead kmem caches.

So it was decided to switch to the white-list policy.  This patch reverts
bits introducing the black-list policy.  The white-list policy will be
introduced later in the series.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/dir.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/kernfs/dir.c~revert-kernfs-do-not-account-ino_ida-allocations-to-memcg fs/kernfs/dir.c
--- a/fs/kernfs/dir.c~revert-kernfs-do-not-account-ino_ida-allocations-to-memcg
+++ a/fs/kernfs/dir.c
@@ -541,14 +541,7 @@ static struct kernfs_node *__kernfs_new_
 	if (!kn)
 		goto err_out1;
 
-	/*
-	 * If the ino of the sysfs entry created for a kmem cache gets
-	 * allocated from an ida layer, which is accounted to the memcg that
-	 * owns the cache, the memcg will get pinned forever. So do not account
-	 * ino ida allocations.
-	 */
-	ret = ida_simple_get(&root->ino_ida, 1, 0,
-			     GFP_KERNEL | __GFP_NOACCOUNT);
+	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto err_out2;
 	kn->ino = ret;
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch

