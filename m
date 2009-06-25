From: akpm@linux-foundation.org
Subject: + cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch added to -mm tree
Date: Thu, 25 Jun 2009 12:45:44 -0700
Message-ID: <200906251945.n5PJjiJq012696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZFYTqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 15:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: knikanth@suse.de, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     cpusets: document adding/removing cpus to cpuset elaborately
has been added to the -mm tree.  Its filename is
     cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch

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

cpusets-document-adding-removing-cpus-to-cpuset-elaborately.patch

