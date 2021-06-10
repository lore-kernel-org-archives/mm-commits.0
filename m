Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FD7C48BD1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3135A61414
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 20:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFJUhC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 16:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230077AbhFJUhA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 16:37:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1C946023D;
        Thu, 10 Jun 2021 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623357288;
        bh=bwvP1hKGSy1IGwDjXaBEY/OSbCTNO85VOe/OBFoZCzk=;
        h=Date:From:To:Subject:From;
        b=cvGieSXt6aqqtSwpN1zXLox+1Ae6FuL9in8G0XasI8reNzxF1QxjRJ0i9vuBWm1ps
         T/ed5Fm74KlLvPYwKLYP6vrPXKanSRkGyTi+VfWiNwgnN3I4VFTZnBv4Krwv98wkzV
         InmCaUgcE5WXC1pCwiZWsrP7Qa2wgjIZxEorhWCU=
Date:   Thu, 10 Jun 2021 13:34:47 -0700
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, chris@chrisdown.name, hannes@cmpxchg.org,
        mhocko@suse.com, ming.lei@redhat.com, mm-commits@vger.kernel.org,
        schatzberg.dan@gmail.com, shakeelb@google.com, tj@kernel.org
Subject:  + mm-charge-active-memcg-when-no-mm-is-set.patch added to
 -mm tree
Message-ID: <20210610203447.yn0cCm7SR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: charge active memcg when no mm is set
has been added to the -mm tree.  Its filename is
     mm-charge-active-memcg-when-no-mm-is-set.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-charge-active-memcg-when-no-mm-is-set.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-charge-active-memcg-when-no-mm-is-set.patch

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

set_active_memcg() worked for kernel allocations but was silently ignored
for user pages.

This patch establishes a precedence order for who gets charged:

1. If there is a memcg associated with the page already, that memcg is
   charged. This happens during swapin.

2. If an explicit mm is passed, mm->memcg is charged. This happens
   during page faults, which can be triggered in remote VMs (eg gup).

3. Otherwise consult the current process context. If there is an
   active_memcg, use that. Otherwise, current->mm->memcg.

Previously, if a NULL mm was passed to mem_cgroup_charge (case 3) it would
always charge the root cgroup.  Now it looks up the active_memcg first
(falling back to charging the root cgroup if not set).

Link: https://lkml.kernel.org/r/20210610173944.1203706-3-schatzberg.dan@gmail.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c    |    2 +-
 mm/memcontrol.c |   41 +++++++++++++++++++++++++++--------------
 mm/shmem.c      |    4 ++--
 3 files changed, 30 insertions(+), 17 deletions(-)

--- a/mm/filemap.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/filemap.c
@@ -872,7 +872,7 @@ noinline int __add_to_page_cache_locked(
 	page->index = offset;
 
 	if (!huge) {
-		error = mem_cgroup_charge(page, current->mm, gfp);
+		error = mem_cgroup_charge(page, NULL, gfp);
 		if (error)
 			goto error;
 		charged = true;
--- a/mm/memcontrol.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/memcontrol.c
@@ -897,13 +897,24 @@ struct mem_cgroup *mem_cgroup_from_task(
 }
 EXPORT_SYMBOL(mem_cgroup_from_task);
 
+static __always_inline struct mem_cgroup *active_memcg(void)
+{
+	if (in_interrupt())
+		return this_cpu_read(int_active_memcg);
+	else
+		return current->active_memcg;
+}
+
 /**
  * get_mem_cgroup_from_mm: Obtain a reference on given mm_struct's memcg.
  * @mm: mm from which memcg should be extracted. It can be NULL.
  *
- * Obtain a reference on mm->memcg and returns it if successful. Otherwise
- * root_mem_cgroup is returned. However if mem_cgroup is disabled, NULL is
- * returned.
+ * Obtain a reference on mm->memcg and returns it if successful. If mm
+ * is NULL, then the memcg is chosen as follows:
+ * 1) The active memcg, if set.
+ * 2) current->mm->memcg, if available
+ * 3) root memcg
+ * If mem_cgroup is disabled, NULL is returned.
  */
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 {
@@ -921,8 +932,17 @@ struct mem_cgroup *get_mem_cgroup_from_m
 	 * counting is disabled on the root level in the
 	 * cgroup core. See CSS_NO_REF.
 	 */
-	if (unlikely(!mm))
-		return root_mem_cgroup;
+	if (unlikely(!mm)) {
+		memcg = active_memcg();
+		if (unlikely(memcg)) {
+			/* remote memcg must hold a ref */
+			css_get(&memcg->css);
+			return memcg;
+		}
+		mm = current->mm;
+		if (unlikely(!mm))
+			return root_mem_cgroup;
+	}
 
 	rcu_read_lock();
 	do {
@@ -935,14 +955,6 @@ struct mem_cgroup *get_mem_cgroup_from_m
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-static __always_inline struct mem_cgroup *active_memcg(void)
-{
-	if (in_interrupt())
-		return this_cpu_read(int_active_memcg);
-	else
-		return current->active_memcg;
-}
-
 static __always_inline bool memcg_kmem_bypass(void)
 {
 	/* Allow remote memcg charging from any context. */
@@ -6711,7 +6723,8 @@ out:
  * @gfp_mask: reclaim mode
  *
  * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary.
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
  *
  * Do not use this for pages allocated for swapin.
  *
--- a/mm/shmem.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/shmem.c
@@ -1695,7 +1695,7 @@ static int shmem_swapin_page(struct inod
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
-	struct mm_struct *charge_mm = vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
 	struct swap_info_struct *si;
 	struct page *page = NULL;
 	swp_entry_t swap;
@@ -1828,7 +1828,7 @@ repeat:
 	}
 
 	sbinfo = SHMEM_SB(inode->i_sb);
-	charge_mm = vma ? vma->vm_mm : current->mm;
+	charge_mm = vma ? vma->vm_mm : NULL;
 
 	page = pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
_

Patches currently in -mm which might be from schatzberg.dan@gmail.com are

loop-use-worker-per-cgroup-instead-of-kworker.patch
mm-charge-active-memcg-when-no-mm-is-set.patch
loop-charge-i-o-to-mem-and-blk-cg.patch

