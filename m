From: akpm@linux-foundation.org
Subject: [merged]
 cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:10:44 -0800
Message-ID: <548d0dc4.5Ubq7zGciMzu6BoG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaLNEKg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:10:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sj38.park@gmail.com, corbet@lwn.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: Documentation: fix trivial typos and wrong paragraph numberings
has been removed from the -mm tree.  Its filename was
     cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: cgroups: Documentation: fix trivial typos and wrong paragraph numberings

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cpusets.txt |    6 +++---
 Documentation/cgroups/memory.txt  |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN Documentation/cgroups/cpusets.txt~cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings Documentation/cgroups/cpusets.txt
--- a/Documentation/cgroups/cpusets.txt~cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings
+++ a/Documentation/cgroups/cpusets.txt
@@ -445,7 +445,7 @@ across partially overlapping sets of CPU
 that would be beyond our understanding.  So if each of two partially
 overlapping cpusets enables the flag 'cpuset.sched_load_balance', then we
 form a single sched domain that is a superset of both.  We won't move
-a task to a CPU outside it cpuset, but the scheduler load balancing
+a task to a CPU outside its cpuset, but the scheduler load balancing
 code might waste some compute cycles considering that possibility.
 
 This mismatch is why there is not a simple one-to-one relation
@@ -552,8 +552,8 @@ otherwise initial value -1 that indicate
    1  : search siblings (hyperthreads in a core).
    2  : search cores in a package.
    3  : search cpus in a node [= system wide on non-NUMA system]
- ( 4  : search nodes in a chunk of node [on NUMA system] )
- ( 5  : search system wide [on NUMA system] )
+   4  : search nodes in a chunk of node [on NUMA system]
+   5  : search system wide [on NUMA system]
 
 The system default is architecture dependent.  The system default
 can be changed using the relax_domain_level= boot parameter.
diff -puN Documentation/cgroups/memory.txt~cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~cgroups-documentation-fix-trivial-typos-and-wrong-paragraph-numberings
+++ a/Documentation/cgroups/memory.txt
@@ -326,7 +326,7 @@ per cgroup, instead of globally.
 
 * tcp memory pressure: sockets memory pressure for the tcp protocol.
 
-2.7.3 Common use cases
+2.7.2 Common use cases
 
 Because the "kmem" counter is fed to the main user counter, kernel memory can
 never be limited completely independently of user memory. Say "U" is the user
@@ -354,19 +354,19 @@ set:
 
 3. User Interface
 
-0. Configuration
+3.0. Configuration
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_MEMCG
 c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
-1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
+3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
 # mkdir /sys/fs/cgroup/memory
 # mount -t cgroup none /sys/fs/cgroup/memory -o memory
 
-2. Make the new group and move bash into it
+3.2. Make the new group and move bash into it
 # mkdir /sys/fs/cgroup/memory/0
 # echo $$ > /sys/fs/cgroup/memory/0/tasks
 
_

Patches currently in -mm which might be from sj38.park@gmail.com are

origin.patch
linux-next.patch

