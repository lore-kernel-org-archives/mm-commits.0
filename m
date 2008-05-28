From: akpm@linux-foundation.org
Subject: + cpusets-fix-and-update-documentation.patch added to -mm tree
Date: Tue, 27 May 2008 20:37:15 -0700
Message-ID: <200805280337.m4S3bFIx027151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYE1DhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 23:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, pj@sgi.com


The patch titled
     cpusets: fix and update Documentation
has been added to the -mm tree.  Its filename is
     cpusets-fix-and-update-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: fix and update Documentation
From: Miao Xie <miaox@cn.fujitsu.com>

Make the doc consistent with current cpusets implementation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN Documentation/cpusets.txt~cpusets-fix-and-update-documentation Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpusets-fix-and-update-documentation
+++ a/Documentation/cpusets.txt
@@ -199,7 +199,7 @@ using the sched_setaffinity, mbind and s
 The following rules apply to each cpuset:
 
  - Its CPUs and Memory Nodes must be a subset of its parents.
- - It can only be marked exclusive if its parent is.
+ - It can't be marked exclusive unless its parent is.
  - If its cpu or memory is exclusive, they may not overlap any sibling.
 
 These rules, and the natural hierarchy of cpusets, enable efficient
@@ -345,7 +345,7 @@ is modified to perform an inline check f
 flag, and if set, a call to a new routine cpuset_mem_spread_node()
 returns the node to prefer for the allocation.
 
-Similarly, setting 'memory_spread_cache' turns on the flag
+Similarly, setting 'memory_spread_slab' turns on the flag
 PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
@@ -709,7 +709,10 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-cpus  cpu_exclusive  mems  mem_exclusive mem_hardwall  tasks
+cpu_exclusive  memory_migrate      mems                      tasks
+cpus           memory_pressure     notify_on_release
+mem_exclusive  memory_spread_page  sched_load_balance
+mem_hardwall   memory_spread_slab  sched_relax_domain_level
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

cpusets-fix-and-update-documentation.patch

