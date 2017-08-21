From: akpm@linux-foundation.org
Subject: [merged]
 slub-fix-per-memcg-cache-leak-on-css-offline.patch removed from -mm tree
Date: Mon, 21 Aug 2017 11:30:10 -0700
Message-ID: <20170821183010.3LOH2YdZk%akpm__24524.5980717757$1503340223$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50366 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753778AbdHUSaL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 14:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@gmail.com, cl@linux.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com


The patch titled
     Subject: slub: fix per memcg cache leak on css offline
has been removed from the -mm tree.  Its filename was
     slub-fix-per-memcg-cache-leak-on-css-offline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: slub: fix per memcg cache leak on css offline

To avoid a possible deadlock, sysfs_slab_remove() schedules an
asynchronous work to delete sysfs entries corresponding to the kmem cache.
To ensure the cache isn't freed before the work function is called, it
takes a reference to the cache kobject.  The reference is supposed to be
released by the work function.  However, the work function
(sysfs_slab_remove_workfn()) does nothing in case the cache sysfs entry
has already been deleted, leaking the kobject and the corresponding cache.
This may happen on a per memcg cache destruction, because sysfs entries
of a per memcg cache are deleted on memcg offline if the cache is empty
(see __kmemcg_cache_deactivate()).

The kmemleak report looks like this:

  unreferenced object 0xffff9f798a79f540 (size 32):
    comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.554s)
    hex dump (first 32 bytes):
      6b 6d 61 6c 6c 6f 63 2d 31 36 28 31 35 39 39 3a  kmalloc-16(1599:
      6e 65 77 72 6f 6f 74 29 00 23 6b c0 ff ff ff ff  newroot).#k.....
    backtrace:
      [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
      [<ffffffff9527a378>] __kmalloc_track_caller+0x148/0x2c0
      [<ffffffff95499466>] kvasprintf+0x66/0xd0
      [<ffffffff954995a9>] kasprintf+0x49/0x70
      [<ffffffff952305c6>] memcg_create_kmem_cache+0xe6/0x160
      [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
      [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
      [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
      [<ffffffff950d5169>] kthread+0x109/0x140
      [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
      [<ffffffffffffffff>] 0xffffffffffffffff
  unreferenced object 0xffff9f79b6136840 (size 416):
    comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
    hex dump (first 32 bytes):
      40 fb 80 c2 3e 33 00 00 00 00 00 40 00 00 00 00  @...>3.....@....
      00 00 00 00 00 00 00 00 10 00 00 00 10 00 00 00  ................
    backtrace:
      [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
      [<ffffffff95275bc8>] kmem_cache_alloc+0x128/0x280
      [<ffffffff9522fedb>] create_cache+0x3b/0x1e0
      [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
      [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
      [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
      [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
      [<ffffffff950d5169>] kthread+0x109/0x140
      [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
      [<ffffffffffffffff>] 0xffffffffffffffff

Fix the leak by adding the missing call to kobject_put() to
sysfs_slab_remove_workfn().

Link: http://lkml.kernel.org/r/20170812181134.25027-1-vdavydov.dev@gmail.com
Fixes: 3b7b314053d02 ("slub: make sysfs file removal asynchronous")
Signed-off-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Reported-by: Andrei Vagin <avagin@gmail.com>
Tested-by: Andrei Vagin <avagin@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[4.12.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-fix-per-memcg-cache-leak-on-css-offline mm/slub.c
--- a/mm/slub.c~slub-fix-per-memcg-cache-leak-on-css-offline
+++ a/mm/slub.c
@@ -5642,13 +5642,14 @@ static void sysfs_slab_remove_workfn(str
 		 * A cache is never shut down before deactivation is
 		 * complete, so no need to worry about synchronization.
 		 */
-		return;
+		goto out;
 
 #ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
+out:
 	kobject_put(&s->kobj);
 }
 
_

Patches currently in -mm which might be from vdavydov.dev@gmail.com are


