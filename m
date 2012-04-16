From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-up-documentation-on-global-lru.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:18 -0700
Message-ID: <20120416201518.7E02CA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:41089 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2DPUPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:19 -0400
Received: by yenq2 with SMTP id q2so644423yen.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix up documentation on global LRU
has been removed from the -mm tree.  Its filename was
     memcg-fix-up-documentation-on-global-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ying Han <yinghan@google.com>
Subject: memcg: fix up documentation on global LRU

In v3.3-rc1, the global LRU has been removed with commit "mm: make
per-memcg LRU lists exclusive".  The patch fixes up the memcg docs.

I left the swap session to someone who has better understanding of
'memory+swap'.

Signed-off-by: Ying Han <yinghan@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-up-documentation-on-global-lru Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-up-documentation-on-global-lru
+++ a/Documentation/cgroups/memory.txt
@@ -34,8 +34,7 @@ Current Status: linux-2.6.34-mmotm(devel
 
 Features:
  - accounting anonymous pages, file caches, swap caches usage and limiting them.
- - private LRU and reclaim routine. (system's global LRU and private LRU
-   work independently from each other)
+ - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
  - hierarchical accounting
  - soft limit
@@ -154,7 +153,7 @@ updated. page_cgroup has its own LRU on 
 2.2.1 Accounting details
 
 All mapped anon pages (RSS) and cache pages (Page Cache) are accounted.
-Some pages which are never reclaimable and will not be on the global LRU
+Some pages which are never reclaimable and will not be on the LRU
 are not accounted. We just account pages under usual VM management.
 
 RSS pages are accounted at page_fault unless they've already been accounted
_

Patches currently in -mm which might be from yinghan@google.com are

mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch

