From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-charge-active-memcg-when-no-mm-is-set.patch added to
 -mm tree
Date: Mon, 24 Feb 2020 14:55:43 -0800
Message-ID: <20200224225543.ijEqT1MI6%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgBXWzp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 17:55:45 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, lizefan@huawei.com, mhocko@kernel.org, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, shakeelb@google.com, tglx@linutronix.de, tj@kernel.org, vdavydov.dev@gmail.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: charge active memcg when no mm is set
has been added to the -mm tree.  Its filename is
     mm-charge-active-memcg-when-no-mm-is-set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-charge-active-memcg-when-no-mm-is-set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-charge-active-memcg-when-no-mm-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: mm: charge active memcg when no mm is set

memalloc_use_memcg() worked for kernel allocations but was silently
ignored for user pages.

This patch establishes a precedence order for who gets charged:

1. If there is a memcg associated with the page already, that memcg is
   charged. This happens during swapin.

2. If an explicit mm is passed, mm->memcg is charged. This happens
   during page faults, which can be triggered in remote VMs (eg gup).

3. Otherwise consult the current process context. If it has configured
   a current->active_memcg, use that. Otherwise, current->mm->memcg.

Previously, if a NULL mm was passed to mem_cgroup_try_charge (case 3) it
would always charge the root cgroup.  Now it looks up the current
active_memcg first (falling back to charging the root cgroup if not set).

Link: http://lkml.kernel.org/r/4456276af198412b2d41cd09d246cd20e0c6d22a.1582581887.git.schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 mm/shmem.c      |    4 ++--
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/memcontrol.c
@@ -6320,7 +6320,8 @@ exit:
  * @compound: charge the page as compound or small page
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. If @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Returns 0 on success, with *@memcgp pointing to the charged memcg.
  * Otherwise, an error code is returned.
@@ -6364,8 +6365,12 @@ int mem_cgroup_try_charge(struct page *p
 		}
 	}
 
-	if (!memcg)
-		memcg = get_mem_cgroup_from_mm(mm);
+	if (!memcg) {
+		if (!mm)
+			memcg = get_mem_cgroup_from_current();
+		else
+			memcg = get_mem_cgroup_from_mm(mm);
+	}
 
 	ret = try_charge(memcg, gfp_mask, nr_pages);
 
--- a/mm/shmem.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/shmem.c
@@ -1631,7 +1631,7 @@ static int shmem_swapin_page(struct inod
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct mem_cgroup *memcg;
 	struct page *page;
 	swp_entry_t swap;
@@ -1766,7 +1766,7 @@ repeat:
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = find_lock_entry(mapping, index);
 	if (xa_is_value(page)) {
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

loop-use-worker-per-cgroup-instead-of-kworker.patch
mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch
