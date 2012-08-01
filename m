From: akpm@linux-foundation.org
Subject: [merged] hugetlb-cgroup-add-hugetlb-controller-documentation.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:12:49 -0700
Message-ID: <20120801201250.383015C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50399 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:12:53 -0400
Received: by eekd4 with SMTP id d4so347787eek.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:12:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: add HugeTLB controller documentation
has been removed from the -mm tree.  Its filename was
     hugetlb-cgroup-add-hugetlb-controller-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add HugeTLB controller documentation

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/hugetlb.txt |   45 ++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN /dev/null Documentation/cgroups/hugetlb.txt
--- /dev/null
+++ a/Documentation/cgroups/hugetlb.txt
@@ -0,0 +1,45 @@
+HugeTLB Controller
+-------------------
+
+The HugeTLB controller allows to limit the HugeTLB usage per control group and
+enforces the controller limit during page fault. Since HugeTLB doesn't
+support page reclaim, enforcing the limit at page fault time implies that,
+the application will get SIGBUS signal if it tries to access HugeTLB pages
+beyond its limit. This requires the application to know beforehand how much
+HugeTLB pages it would require for its use.
+
+HugeTLB controller can be created by first mounting the cgroup filesystem.
+
+# mount -t cgroup -o hugetlb none /sys/fs/cgroup
+
+With the above step, the initial or the parent HugeTLB group becomes
+visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
+the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
+
+New groups can be created under the parent group /sys/fs/cgroup.
+
+# cd /sys/fs/cgroup
+# mkdir g1
+# echo $$ > g1/tasks
+
+The above steps create a new group g1 and move the current shell
+process (bash) into it.
+
+Brief summary of control files
+
+ hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
+ hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
+ hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
+ hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
+
+For a system supporting two hugepage size (16M and 16G) the control
+files include:
+
+hugetlb.16GB.limit_in_bytes
+hugetlb.16GB.max_usage_in_bytes
+hugetlb.16GB.usage_in_bytes
+hugetlb.16GB.failcnt
+hugetlb.16MB.limit_in_bytes
+hugetlb.16MB.max_usage_in_bytes
+hugetlb.16MB.usage_in_bytes
+hugetlb.16MB.failcnt
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch

