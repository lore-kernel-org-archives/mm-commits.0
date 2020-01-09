From: akpm@linux-foundation.org
Subject: [to-be-updated]
 =?US-ASCII?Q?mm-rmap-fix-and-simplify-reusing-mergeable-anon=5Fvma-as-pa?=
 =?US-ASCII?Q?rent-when-fork.patch?= removed from -mm tree
Date: Thu, 09 Jan 2020 13:36:51 -0800
Message-ID: <20200109213651.vDb8eU6O4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgAIVgw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 16:36:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, lixinhai.lxh@gmail.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, riel@redhat.com


The patch titled
     Subject: mm/rmap: fix and simplify reusing mergeable anon_vma as parent when fork
has been removed from the -mm tree.  Its filename was
     mm-rmap-fix-and-simplify-reusing-mergeable-anon_vma-as-parent-when-fork.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm/rmap: fix and simplify reusing mergeable anon_vma as parent when fork

This fixes some misconceptions in commit 4e4a9eb92133 ("mm/rmap.c: reuse
mergeable anon_vma as parent when fork").  It merges anon-vma in
unexpected way but fortunately still produces valid anon-vma tree, so
nothing crashes.

If in parent VMAs: SRC1 SRC2 ..  SRCn share anon-vma ANON0, then after
fork before all patches in child process related VMAs: DST1 DST2 ..  DSTn
will fork indepndent anon-vmas: ANON1 ANON2 ..  ANONn (each is child of
ANON0).  Before this patch only DST1 will fork new ANON1 and following
DST2 ..  DSTn will share parent's ANON0 (i.e.  anon-vma tree is valid but
isn't optimal).  With this patch DST1 will create new ANON1 and DST2 .. 
DSTn will share it.

Root problem caused by initialization order in dup_mmap(): vma->vm_prev is
set after calling anon_vma_fork().  Thus in anon_vma_fork() it points to
previous VMA in parent mm.

Second problem is hidden behind first one: assumption "Parent has vm_prev,
which implies we have vm_prev" is wrong if first VMA in parent mm has set
flag VM_DONTCOPY.  Luckily prev->anon_vma doesn't dereference NULL pointer
because in current code 'prev' actually is same as 'pprev'.

Third hidden problem is linking between VMA and anon-vmas whose pages it
could contain.  Loop in anon_vma_clone() attaches only parent's anon-vmas,
shared anon-vma isn't attached.  But every mapped page stays reachable in
rmap because we erroneously share anon-vma from parent's previous VMA.

This patch moves sharing logic out of anon_vma_clone() into more specific
anon_vma_fork() because this supposed to work only at fork() and simply
reuses anon_vma from previous VMA if it is forked from the same anon-vma.

Link: http://lkml.kernel.org/r/157839239609.694.10268055713935919822.stgit@buzz
Link: https://lore.kernel.org/linux-mm/CALYGNiNzz+dxHX0g5-gNypUQc3B=8_Scp53-NTOh=zWsdUuHAw@mail.gmail.com/T/#t
Fixes: 4e4a9eb92133 ("mm/rmap.c: reuse mergeable anon_vma as parent when fork")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Li Xinhai <lixinhai.lxh@gmail.com>
Reviewed-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 kernel/fork.c        |    2 +-
 mm/rmap.c            |   23 +++++++++--------------
 3 files changed, 12 insertions(+), 16 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-fix-and-simplify-reusing-mergeable-anon_vma-as-parent-when-fork
+++ a/include/linux/rmap.h
@@ -143,7 +143,8 @@ void anon_vma_init(void);	/* create anon
 int  __anon_vma_prepare(struct vm_area_struct *);
 void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma,
+		  struct vm_area_struct *prev);
 
 static inline int anon_vma_prepare(struct vm_area_struct *vma)
 {
--- a/kernel/fork.c~mm-rmap-fix-and-simplify-reusing-mergeable-anon_vma-as-parent-when-fork
+++ a/kernel/fork.c
@@ -556,7 +556,7 @@ static __latent_entropy int dup_mmap(str
 			tmp->anon_vma = NULL;
 			if (anon_vma_prepare(tmp))
 				goto fail_nomem_anon_vma_fork;
-		} else if (anon_vma_fork(tmp, mpnt))
+		} else if (anon_vma_fork(tmp, mpnt, prev))
 			goto fail_nomem_anon_vma_fork;
 		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 		tmp->vm_next = tmp->vm_prev = NULL;
--- a/mm/rmap.c~mm-rmap-fix-and-simplify-reusing-mergeable-anon_vma-as-parent-when-fork
+++ a/mm/rmap.c
@@ -269,19 +269,6 @@ int anon_vma_clone(struct vm_area_struct
 {
 	struct anon_vma_chain *avc, *pavc;
 	struct anon_vma *root = NULL;
-	struct vm_area_struct *prev = dst->vm_prev, *pprev = src->vm_prev;
-
-	/*
-	 * If parent share anon_vma with its vm_prev, keep this sharing in in
-	 * child.
-	 *
-	 * 1. Parent has vm_prev, which implies we have vm_prev.
-	 * 2. Parent and its vm_prev have the same anon_vma.
-	 */
-	if (!dst->anon_vma && src->anon_vma &&
-	    pprev && pprev->anon_vma == src->anon_vma)
-		dst->anon_vma = prev->anon_vma;
-
 
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
@@ -332,7 +319,8 @@ int anon_vma_clone(struct vm_area_struct
  * the corresponding VMA in the parent process is attached to.
  * Returns 0 on success, non-zero on failure.
  */
-int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma,
+		  struct vm_area_struct *prev)
 {
 	struct anon_vma_chain *avc;
 	struct anon_vma *anon_vma;
@@ -342,6 +330,13 @@ int anon_vma_fork(struct vm_area_struct
 	if (!pvma->anon_vma)
 		return 0;
 
+	/* Share anon_vma with previous VMA if it has the same parent. */
+	if (prev && prev->anon_vma &&
+	    prev->anon_vma->parent == pvma->anon_vma) {
+		vma->anon_vma = prev->anon_vma;
+		return anon_vma_clone(vma, prev);
+	}
+
 	/* Drop inherited anon_vma, we'll reuse existing or allocate new. */
 	vma->anon_vma = NULL;
 
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

kernel-fork-set-vmas-mm-prev-next-right-after-vm_area_dup-in-dup_mmap.patch
