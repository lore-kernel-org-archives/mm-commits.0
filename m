From: akpm@linux-foundation.org
Subject: - memcontrol-move-mm_cgroup-to-header-file.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:30 -0800
Message-ID: <200802080803.m1883BJP014098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34212 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760781AbYBHIYy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:24:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcontrol: move mm_cgroup to header file
has been removed from the -mm tree.  Its filename was
     memcontrol-move-mm_cgroup-to-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcontrol: move mm_cgroup to header file
From: David Rientjes <rientjes@google.com>

Inline functions must preceed their use, so mm_cgroup() should be defined
in linux/memcontrol.h.

include/linux/memcontrol.h:48: warning: 'mm_cgroup' declared inline after
	being called
include/linux/memcontrol.h:48: warning: previous declaration of
	'mm_cgroup' was here

[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: nuther build fix]
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 +++++++++--
 mm/memcontrol.c            |    5 -----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-move-mm_cgroup-to-header-file include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-move-mm_cgroup-to-header-file
+++ a/include/linux/memcontrol.h
@@ -20,6 +20,9 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 
+#include <linux/rcupdate.h>
+#include <linux/mm.h>
+
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
@@ -45,7 +48,11 @@ extern unsigned long mem_cgroup_isolate_
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 					gfp_t gfp_mask);
-extern struct mem_cgroup *mm_cgroup(struct mm_struct *mm);
+
+static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
+{
+	return rcu_dereference(mm->mem_cgroup);
+}
 
 static inline void mem_cgroup_uncharge_page(struct page *page)
 {
@@ -98,7 +105,7 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline struct mem_cgroup *mm_cgroup(struct mm_struct *mm)
+static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
 {
 	return NULL;
 }
diff -puN mm/memcontrol.c~memcontrol-move-mm_cgroup-to-header-file mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-move-mm_cgroup-to-header-file
+++ a/mm/memcontrol.c
@@ -110,11 +110,6 @@ struct mem_cgroup *mem_cgroup_from_task(
 				struct mem_cgroup, css);
 }
 
-inline struct mem_cgroup *mm_cgroup(struct mm_struct *mm)
-{
-	return rcu_dereference(mm->mem_cgroup);
-}
-
 void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p)
 {
 	struct mem_cgroup *mem;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
