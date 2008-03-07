From: akpm@linux-foundation.org
Subject: + memory-controller-make-memory-resource-control-aware-of-boot-options.patch added to -mm tree
Date: Fri, 07 Mar 2008 01:12:53 -0800
Message-ID: <200803070912.m279CrsM014765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760045AbYCGJNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 04:13:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, skumar@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memory controller: make memory resource control aware of boot options
has been added to the -mm tree.  Its filename is
     memory-controller-make-memory-resource-control-aware-of-boot-options.patch

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
Subject: memory controller: make memory resource control aware of boot options
From: Balbir Singh <balbir@linux.vnet.ibm.com>

A boot option for the memory controller was discussed on lkml.  It is a good
idea to add it, since it saves memory for people who want to turn off the
memory controller.

By default the option is on for the following two reasons:

1. It provides compatibility with the current scheme where the memory
   controller turns on if the config option is enabled
2. It allows for wider testing of the memory controller, once the config
   option is enabled

We still allow the create, destroy callbacks to succeed, since they are not
aware of boot options.  We do not populate the directory will memory resource
controller specific files.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN mm/memcontrol.c~memory-controller-make-memory-resource-control-aware-of-boot-options mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-make-memory-resource-control-aware-of-boot-options
+++ a/mm/memcontrol.c
@@ -533,6 +533,9 @@ static int mem_cgroup_charge_common(stru
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup_per_zone *mz;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * Should page_cgroup's go to their own slab?
 	 * One could optimize the performance of the charging routine
@@ -665,6 +668,9 @@ void mem_cgroup_uncharge_page(struct pag
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	/*
 	 * Check if our page_cgroup is valid
 	 */
@@ -705,6 +711,9 @@ int mem_cgroup_prepare_migration(struct 
 {
 	struct page_cgroup *pc;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
 	if (pc)
@@ -803,6 +812,9 @@ static int mem_cgroup_force_empty(struct
 	int ret = -EBUSY;
 	int node, zid;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
@@ -1022,6 +1034,8 @@ static void mem_cgroup_destroy(struct cg
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
 	return cgroup_add_files(cont, ss, mem_cgroup_files,
 					ARRAY_SIZE(mem_cgroup_files));
 }
@@ -1034,6 +1048,9 @@ static void mem_cgroup_move_task(struct 
 	struct mm_struct *mm;
 	struct mem_cgroup *mem, *old_mem;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	mm = get_task_mm(p);
 	if (mm == NULL)
 		return;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

git-kvm.patch
cgroups-add-cgroup-support-for-enabling-controllers-at-boot-time.patch
memory-controller-make-memory-resource-control-aware-of-boot-options.patch

