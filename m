From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-pgpgin-pgpgout-documentation.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:27 -0800
Message-ID: <20120113203328.11CC95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49326 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab2AMUd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:29 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23664eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix pgpgin/pgpgout documentation
has been removed from the -mm tree.  Its filename was
     memcg-fix-pgpgin-pgpgout-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: memcg: fix pgpgin/pgpgout documentation

The two memcg stats pgpgin/pgpgout have different meaning than the ones in
vmstat, which indicates that we picked a bad naming for them.  It might be
late to change the stat name, but better documentation is always helpful.

Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-pgpgin-pgpgout-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-pgpgin-pgpgout-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -410,8 +410,11 @@ memory.stat file includes following stat
 cache		- # of bytes of page cache memory.
 rss		- # of bytes of anonymous and swap cache memory.
 mapped_file	- # of bytes of mapped file (includes tmpfs/shmem)
-pgpgin		- # of pages paged in (equivalent to # of charging events).
-pgpgout		- # of pages paged out (equivalent to # of uncharging events).
+pgpgin		- # of charging events to the memory cgroup. The charging
+		event happens each time a page is accounted as either mapped
+		anon page(RSS) or cache page(Page Cache) to the cgroup.
+pgpgout		- # of uncharging events to the memory cgroup. The uncharging
+		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
 inactive_anon	- # of bytes of anonymous memory and swap cache memory on
 		LRU list.
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

