From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch removed from -mm
 tree
Date: Thu, 17 Oct 2013 11:12:59 -0700
Message-ID: <526028ab.z0p/UR2gyKF3VM72%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSNA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@openvz.org, chuck.lever@oracle.com, avagin@openvz.org

Subject: [merged] mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch removed from -mm tree
To: avagin@openvz.org,chuck.lever@oracle.com,glommer@openvz.org,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:12:59 -0700


The patch titled
     Subject: mm/vmscan.c: don't forget to free shrinker->nr_deferred
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Vagin <avagin@openvz.org>
Subject: mm/vmscan.c: don't forget to free shrinker->nr_deferred

This leak was added by 1d3d4437eae ("vmscan: per-node deferred work").

unreferenced object 0xffff88006ada3bd0 (size 8):
  comm "criu", pid 14781, jiffies 4295238251 (age 105.641s)
  hex dump (first 8 bytes):
    00 00 00 00 00 00 00 00                          ........
  backtrace:
    [<ffffffff8170caee>] kmemleak_alloc+0x5e/0xc0
    [<ffffffff811c0527>] __kmalloc+0x247/0x310
    [<ffffffff8117848c>] register_shrinker+0x3c/0xa0
    [<ffffffff811e115b>] sget+0x5ab/0x670
    [<ffffffff812532f4>] proc_mount+0x54/0x170
    [<ffffffff811e1893>] mount_fs+0x43/0x1b0
    [<ffffffff81202dd2>] vfs_kern_mount+0x72/0x110
    [<ffffffff81202e89>] kern_mount_data+0x19/0x30
    [<ffffffff812530a0>] pid_ns_prepare_proc+0x20/0x40
    [<ffffffff81083c56>] alloc_pid+0x466/0x4a0
    [<ffffffff8105aeda>] copy_process+0xc6a/0x1860
    [<ffffffff8105beab>] do_fork+0x8b/0x370
    [<ffffffff8105c1a6>] SyS_clone+0x16/0x20
    [<ffffffff8171f739>] stub_clone+0x69/0x90
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred
+++ a/mm/vmscan.c
@@ -211,6 +211,7 @@ void unregister_shrinker(struct shrinker
 	down_write(&shrinker_rwsem);
 	list_del(&shrinker->list);
 	up_write(&shrinker_rwsem);
+	kfree(shrinker->nr_deferred);
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch

