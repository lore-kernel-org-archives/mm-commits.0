From: akpm@linux-foundation.org
Subject: + hugetlb-cgroup-add-hugetlb-controller-documentation.patch added to -mm tree
Date: Wed, 13 Jun 2012 13:46:25 -0700
Message-ID: <20120613204625.E6A3EA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:44222 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab2FMUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 16:46:27 -0400
Received: by vbnl22 with SMTP id l22so106076vbn.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 13:46:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: hugetlb/cgroup: add HugeTLB controller documentation
has been added to the -mm tree.  Its filename is
     hugetlb-cgroup-add-hugetlb-controller-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: add HugeTLB controller documentation

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
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
Subject: Subject: hugetlb/cgroup: add HugeTLB controller documentation

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
10-15-hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch

