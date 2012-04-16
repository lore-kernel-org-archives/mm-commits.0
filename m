From: akpm@linux-foundation.org
Subject: + memcg-add-memory-controller-documentation-for-hugetlb-management.patch added to -mm tree
Date: Mon, 16 Apr 2012 16:16:26 -0700
Message-ID: <20120416231627.076FCA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59642 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2DPXQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 19:16:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so668703qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 16:16:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: add memory controller documentation for hugetlb management
has been added to the -mm tree.  Its filename is
     memcg-add-memory-controller-documentation-for-hugetlb-management.patch

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
@@ -278,6 +285,15 @@ per cgroup, instead of globally.
 
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
@@ -286,6 +302,7 @@ a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_RESOURCE_COUNTERS
 c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
+f. Enable CONFIG_MEM_RES_CTLR_HUGETLB (to use HugeTLB extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
@@ -509,6 +526,18 @@ unevictable=<total anon pages> N0=<node 
 
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
Subject: Subject: memcg: add memory controller documentation for hugetlb management

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlbfs-lockdep-annotate-root-inode-properly.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch

