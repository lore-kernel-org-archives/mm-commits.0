From: akpm@linux-foundation.org
Subject: + memcg-fix-pgpgin-pgpgout-documentation.patch added to -mm tree
Date: Tue, 22 Nov 2011 13:25:31 -0800
Message-ID: <201111222125.pAMLPW80031513@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:52246 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab1KVVZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2011 16:25:36 -0500
Received: by wwe5 with SMTP id 5so25028wwe.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2011 13:25:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: memcg: fix pgpgin/pgpgout documentation
has been added to the -mm tree.  Its filename is
     memcg-fix-pgpgin-pgpgout-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-pgpgin-pgpgout-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-pgpgin-pgpgout-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -386,8 +386,11 @@ memory.stat file includes following stat
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
Subject: Subject: memcg: fix pgpgin/pgpgout documentation

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
memcg-fix-pgpgin-pgpgout-documentation.patch

