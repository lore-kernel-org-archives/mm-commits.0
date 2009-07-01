From: akpm@linux-foundation.org
Subject: [merged] cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:22 -0700
Message-ID: <200907011727.n61HRM92002194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbZGAR13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: document adding/removing cpus to cpuset elaborately
has been removed from the -mm tree.  Its filename was
     cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: document adding/removing cpus to cpuset elaborately
From: Nikanth Karthikesan <knikanth@suse.de>

By writing a tasks's pid to the file, a process adds that task to that
cgroup/cpuset.  But to add a cpu/mem to a cpuset, the new list of cpus
should be written to the cpuset.mems file which would replace the old list
of cpus.  Make this clearer in the documentation.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cpusets.txt |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN Documentation/cgroups/cpusets.txt~cpusets-document-adding-removing-cpus-to-cpuset-elaborately Documentation/cgroups/cpusets.txt
--- a/Documentation/cgroups/cpusets.txt~cpusets-document-adding-removing-cpus-to-cpuset-elaborately
+++ a/Documentation/cgroups/cpusets.txt
@@ -777,6 +777,18 @@ in cpuset directories:
 # /bin/echo 1-4 > cpus		-> set cpus list to cpus 1,2,3,4
 # /bin/echo 1,2,3,4 > cpus	-> set cpus list to cpus 1,2,3,4
 
+To add a CPU to a cpuset, write the new list of CPUs including the
+CPU to be added. To add 6 to the above cpuset:
+
+# /bin/echo 1-4,6 > cpus	-> set cpus list to cpus 1,2,3,4,6
+
+Similarly to remove a CPU from a cpuset, write the new list of CPUs
+without the CPU to be removed.
+
+To remove all the CPUs:
+
+# /bin/echo "" > cpus		-> clear cpus list
+
 2.3 Setting flags
 -----------------
 
_

Patches currently in -mm which might be from knikanth@suse.de are

origin.patch

