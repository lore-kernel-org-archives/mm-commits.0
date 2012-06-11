From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-memory-controller-documentation-for-hugetlb-management.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:21 -0700
Message-ID: <20120611211021.6B060A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:33499 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2FKVKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:23 -0400
Received: by eeit10 with SMTP id t10so257420eei.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add memory controller documentation for hugetlb management
has been removed from the -mm tree.  Its filename was
     memcg-add-memory-controller-documentation-for-hugetlb-management.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: memcg: add memory controller documentation for hugetlb management

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN Documentation/cgroups/memory.txt~memcg-add-memory-controller-documentation-for-hugetlb-management Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-memory-controller-documentation-for-hugetlb-management
+++ a/Documentation/cgroups/memory.txt
@@ -42,6 +42,7 @@ Features:
  - usage threshold notifier
  - oom-killer disable knob and oom-notifier
  - Root cgroup has no limit controls.
+ - resource accounting for HugeTLB pages
 
  Kernel memory support is work in progress, and the current version provides
  basically functionality. (See Section 2.7)
@@ -74,6 +75,12 @@ Brief summary of control files.
  memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
  memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
 
+
+ memory.hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
+ memory.hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
+ memory.hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
+						  # see 5.7 for details
+
 1. History
 
 The memory controller has a long history. A request for comments for the memory
@@ -280,6 +287,15 @@ per cgroup, instead of globally.
 
 * tcp memory pressure: sockets memory pressure for the tcp protocol.
 
+2.8 HugeTLB extension
+
+This extension allows to limit the HugeTLB usage per control group and
+enforces the controller limit during page fault. Since HugeTLB doesn't
+support page reclaim, enforcing the limit at page fault time implies that,
+the application will get SIGBUS signal if it tries to access HugeTLB pages
+beyond its limit. This requires the application to know beforehand how much
+HugeTLB pages it would require for its use.
+
 3. User Interface
 
 0. Configuration
@@ -288,6 +304,7 @@ a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_RESOURCE_COUNTERS
 c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
+f. Enable CONFIG_MEM_RES_CTLR_HUGETLB (to use HugeTLB extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
@@ -507,6 +524,18 @@ unevictable=<total anon pages> N0=<node 
 
 And we have total = file + anon + unevictable.
 
+5.7 HugeTLB resource control files
+For a system supporting two hugepage size (16M and 16G) the control
+files include:
+
+ memory.hugetlb.16GB.limit_in_bytes
+ memory.hugetlb.16GB.max_usage_in_bytes
+ memory.hugetlb.16GB.usage_in_bytes
+ memory.hugetlb.16MB.limit_in_bytes
+ memory.hugetlb.16MB.max_usage_in_bytes
+ memory.hugetlb.16MB.usage_in_bytes
+
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

