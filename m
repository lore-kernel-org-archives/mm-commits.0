From: akpm@linux-foundation.org
Subject: + mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch added to -mm tree
Date: Thu, 03 Oct 2013 15:02:34 -0700
Message-ID: <524de97a.b646BOIEooHWM6b0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab3JCWCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 18:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, mhocko@suse.cz, mgorman@suse.de, hannes@cmpxchg.org, glommer@openvz.org, avagin@openvz.org

Subject: + mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch added to -mm tree
To: avagin@openvz.org,glommer@openvz.org,hannes@cmpxchg.org,mgorman@suse.de,mhocko@suse.cz,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 15:02:34 -0700


The patch titled
     Subject: mm/vmscan.c: don't forget to free shrinker->nr_deferred
has been added to the -mm tree.  Its filename is
     mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred
+++ a/mm/vmscan.c
@@ -211,6 +211,8 @@ void unregister_shrinker(struct shrinker
 	down_write(&shrinker_rwsem);
 	list_del(&shrinker->list);
 	up_write(&shrinker_rwsem);
+
+	kfree(shrinker->nr_deferred);
 }
 EXPORT_SYMBOL(unregister_shrinker);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

mm-vmscanc-dont-forget-to-free-shrinker-nr_deferred.patch

