From: akpm@linux-foundation.org
Subject: + fix-sparc-compile-error.patch added to -mm tree
Date: Fri, 08 Feb 2008 12:55:19 -0800
Message-ID: <200802082055.m18KtKv0012781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbYBHU56 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:57:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@linux.vnet.ibm.com, bunk@stusta.de


The patch titled
     fix sparc compile error
has been added to the -mm tree.  Its filename is
     fix-sparc-compile-error.patch

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
Subject: fix sparc compile error
From: David Rientjes <rientjes@google.com>

3062fc67 introduced far too many build errors for the convenience it
allows.  It's not even always necessary to rcu deference mm->mem_cgroup in
the first place, so we'll use it on a case by case basis.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reported-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 -------------
 mm/memcontrol.c            |    2 +-
 mm/rmap.c                  |    6 ++++--
 3 files changed, 5 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~fix-sparc-compile-error include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~fix-sparc-compile-error
+++ a/include/linux/memcontrol.h
@@ -20,9 +20,6 @@
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
 
-#include <linux/rcupdate.h>
-#include <linux/mm.h>
-
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
@@ -51,11 +48,6 @@ extern int mem_cgroup_cache_charge(struc
 					gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
-static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
-{
-	return rcu_dereference(mm->mem_cgroup);
-}
-
 extern int mem_cgroup_prepare_migration(struct page *page);
 extern void mem_cgroup_end_migration(struct page *page);
 extern void mem_cgroup_page_migration(struct page *page, struct page *newpage);
@@ -123,11 +115,6 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline struct mem_cgroup *mm_cgroup(const struct mm_struct *mm)
-{
-	return NULL;
-}
-
 static inline int task_in_mem_cgroup(struct task_struct *task,
 				     const struct mem_cgroup *mem)
 {
diff -puN mm/memcontrol.c~fix-sparc-compile-error mm/memcontrol.c
--- a/mm/memcontrol.c~fix-sparc-compile-error
+++ a/mm/memcontrol.c
@@ -399,7 +399,7 @@ int task_in_mem_cgroup(struct task_struc
 	int ret;
 
 	task_lock(task);
-	ret = task->mm && mm_cgroup(task->mm) == mem;
+	ret = task->mm && rcu_dereference(task->mm->mem_cgroup) == mem;
 	task_unlock(task);
 	return ret;
 }
diff -puN mm/rmap.c~fix-sparc-compile-error mm/rmap.c
--- a/mm/rmap.c~fix-sparc-compile-error
+++ a/mm/rmap.c
@@ -321,7 +321,8 @@ static int page_referenced_anon(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+		if (mem_cont && mem_cont !=
+		    rcu_dereference(vma->vm_mm->mem_cgroup))
 			continue;
 		referenced += page_referenced_one(page, vma, &mapcount);
 		if (!mapcount)
@@ -382,7 +383,8 @@ static int page_referenced_file(struct p
 		 * counting on behalf of references from different
 		 * cgroups
 		 */
-		if (mem_cont && (mm_cgroup(vma->vm_mm) != mem_cont))
+		if (mem_cont && mem_cont !=
+		    rcu_dereference(vma->vm_mm->mem_cgroup))
 			continue;
 		if ((vma->vm_flags & (VM_LOCKED|VM_MAYSHARE))
 				  == (VM_LOCKED|VM_MAYSHARE)) {
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-sparc-compile-error.patch
