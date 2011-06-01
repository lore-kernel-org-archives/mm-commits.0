From: akpm@linux-foundation.org
Subject: + memcg-add-documentation-for-the-memorynumastat-api.patch added to -mm tree
Date: Wed, 01 Jun 2011 16:13:34 -0700
Message-ID: <201106012313.p51NDYGp015424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab1FAXOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 19:14:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg: add documentation for the memory.numastat API
has been added to the -mm tree.  Its filename is
     memcg-add-documentation-for-the-memorynumastat-api.patch

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
Subject: memcg: add documentation for the memory.numastat API
From: Ying Han <yinghan@google.com>

Signed-off-by: Ying Han <yinghan@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-add-documentation-for-the-memorynumastat-api Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-documentation-for-the-memorynumastat-api
+++ a/Documentation/cgroups/memory.txt
@@ -70,6 +70,7 @@ Brief summary of control files.
 				 (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate # set/show controls of moving charges
  memory.oom_control		 # set/show oom controls.
+ memory.numa_stat		 # show the number of memory usage per numa node
 
 1. History
 
@@ -464,6 +465,23 @@ value for efficient access. (Of course, 
 If you want to know more exact memory usage, you should use RSS+CACHE(+SWAP)
 value in memory.stat(see 5.2).
 
+5.6 numa_stat
+
+This is similar to numa_maps but per-memcg basis. This is useful to add visibility
+of numa locality information in memcg since the pages are allowed to be allocated
+at any physical node. One of the usecase is evaluating application performance by
+combining this information with the cpu allocation to the application.
+
+We export "total", "file", "anon" and "unevictable" pages per-node for each memcg.
+The format ouput of the memory.numa_stat:
+
+total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
+file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
+anon=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
+unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
+
+And we have total = file + anon + unevictable.
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
_

Patches currently in -mm which might be from yinghan@google.com are

memcg-add-documentation-for-the-memorynumastat-api.patch

