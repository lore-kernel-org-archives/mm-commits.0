From: akpm@linux-foundation.org
Subject: + memcontrol-add-vm_match_cgroup.patch added to -mm tree
Date: Fri, 08 Feb 2008 13:12:28 -0800
Message-ID: <200802082112.m18LCSmG013526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54946 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbYBHVND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:13:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@in.ibm.com, bunk@stusta.de


The patch titled
     memcontrol: add vm_match_cgroup()
has been added to the -mm tree.  Its filename is
     memcontrol-add-vm_match_cgroup.patch

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
Subject: memcontrol: add vm_match_cgroup()
From: David Rientjes <rientjes@google.com>

mm_cgroup() is exclusively used to test whether an mm's mem_cgroup pointer
is pointing to a specific cgroup.  Instead of returning the pointer, we can
just do the test itself in a new macro:

	vm_match_cgroup(mm, cgroup)

returns non-zero if the mm's mem_cgroup points to cgroup.  Otherwise it
returns zero.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++------
 mm/memcontrol.c            |    2 +-
 mm/rmap.c                  |    4 ++--
 3 files changed, 7 insertions(+), 9 deletions(-)

diff -puN include/linux/memcontrol.h~memcontrol-add-vm_match_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcontrol-add-vm_match_cgroup
+++ a/include/linux/memcontrol.h
@@ -51,10 +51,8 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
-static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
-{
-	return rcu_dereference(mm->mem_cgroup);
-}
+#define vm_match_cgroup(mm, cgroup)	\
+	((cgroup) == rcu_dereference((mm)->mem_cgroup))
 
 extern int mem_cgroup_prepare_migration(struct page *page);
 extern void mem_cgroup_end_migration(struct page *page);
@@ -123,9 +121,9 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
+static inline int vm_match_cgroup(struct mm_struct *mm, struct mem_cgroup *mem)
 {
-	return NULL;
+	return 1;
 }
 
 static inline int task_in_mem_cgroup(struct task_struct *task,
diff -puN mm/memcontrol.c~memcontrol-add-vm_match_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcontrol-add-vm_match_cgroup
+++ a/mm/memcontrol.c
@@ -399,7 +399,7 @@ int task_in_mem_cgroup(struct task_struc
 	int ret;
 
 	task_lock(task);
-	ret = task->mm && mm_cgroup(task->mm) == mem;
+	ret = task->mm && vm_match_cgroup(task->mm, mem);
 	task_unlock(task);
 	return ret;
 }
diff -puN mm/rmap.c~memcontrol-add-vm_match_cgroup mm/rmap.c
--- a/mm/rmap.c~memcontrol-add-vm_match_cgroup
+++ a/mm/rmap.c
@@ -321,7 +321,7 @@ static int page_referenced_anon(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+		if (mem_cont && !vm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
 		referenced += page_referenced_one(page, vma, &mapcount);
 		if (!mapcount)
@@ -382,7 +382,7 @@ static int page_referenced_file(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+		if (mem_cont && !vm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
 		if ((vma->vm_flags & (VM_LOCKED|VM_MAYSHARE))
 				  == (VM_LOCKED|VM_MAYSHARE)) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
memcontrol-add-vm_match_cgroup.patch
