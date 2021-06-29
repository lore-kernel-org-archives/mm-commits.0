Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDD4C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4840461D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhF2Ckr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231706AbhF2Ckq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FAD161D06;
        Tue, 29 Jun 2021 02:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934299;
        bh=QTpZnCIGkmcLmfF8MnVYDLDtYBAIw97oaZnwM/CnWVk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EQbZ4kygpdbwQTHDLlFo9m1/Q5BayqyH1/d2noles+dZeVsLL+ZIs+vDQMVvePfwP
         L+YK8TCMchgv605mM+vaQvpNxDb3ClCG3hWxX6hBGFRB/4wnoMqDiAuPplL0gokbU0
         JbIa7Ghj+1j+jzKdYordQvWvJqkFdRbLG68AITno=
Date:   Mon, 28 Jun 2021 19:38:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, chris@chrisdown.name,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        ming.lei@redhat.com, mkoutny@suse.com, mm-commits@vger.kernel.org,
        schatzberg.dan@gmail.com, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 095/192] mm: charge active memcg when no mm is set
Message-ID: <20210629023818.N6ePXOQRY%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Dan Schatzberg <schatzberg.dan@gmail.com>
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

Link: https://lkml.kernel.org/r/20210610173944.1203706-3-schatzberg.dan@gma=
il.com
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
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
 	page->index =3D offset;
=20
 	if (!huge) {
-		error =3D mem_cgroup_charge(page, current->mm, gfp);
+		error =3D mem_cgroup_charge(page, NULL, gfp);
 		if (error)
 			goto error;
 		charged =3D true;
--- a/mm/memcontrol.c~mm-charge-active-memcg-when-no-mm-is-set
+++ a/mm/memcontrol.c
@@ -897,13 +897,24 @@ struct mem_cgroup *mem_cgroup_from_task(
 }
 EXPORT_SYMBOL(mem_cgroup_from_task);
=20
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
+		memcg =3D active_memcg();
+		if (unlikely(memcg)) {
+			/* remote memcg must hold a ref */
+			css_get(&memcg->css);
+			return memcg;
+		}
+		mm =3D current->mm;
+		if (unlikely(!mm))
+			return root_mem_cgroup;
+	}
=20
 	rcu_read_lock();
 	do {
@@ -935,14 +955,6 @@ struct mem_cgroup *get_mem_cgroup_from_m
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
=20
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
 	struct address_space *mapping =3D inode->i_mapping;
 	struct shmem_inode_info *info =3D SHMEM_I(inode);
-	struct mm_struct *charge_mm =3D vma ? vma->vm_mm : current->mm;
+	struct mm_struct *charge_mm =3D vma ? vma->vm_mm : NULL;
 	struct swap_info_struct *si;
 	struct page *page =3D NULL;
 	swp_entry_t swap;
@@ -1828,7 +1828,7 @@ repeat:
 	}
=20
 	sbinfo =3D SHMEM_SB(inode->i_sb);
-	charge_mm =3D vma ? vma->vm_mm : current->mm;
+	charge_mm =3D vma ? vma->vm_mm : NULL;
=20
 	page =3D pagecache_get_page(mapping, index,
 					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
_
