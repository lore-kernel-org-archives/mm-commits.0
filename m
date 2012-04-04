From: akpm@linux-foundation.org
Subject: + memcg-fix-up-documentation-on-global-lru.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:14:57 -0700
Message-ID: <20120404221457.A9D10A042C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:61076 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2DDWPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:15:01 -0400
Received: by wibhj13 with SMTP id hj13so42600wib.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:14:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: fix up documentation on global LRU
has been added to the -mm tree.  Its filename is
     memcg-fix-up-documentation-on-global-lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: memcg: fix up documentation on global LRU

Patches currently in -mm which might be from yinghan@google.com are

memcg-fix-up-documentation-on-global-lru.patch

