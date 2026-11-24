Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562969;
	b=sXOlkcazXssdwsa/x+/SrOmj4EWKxUFHW6vmasRhBBwB2ut6y74PF0ZLyh17K98F/h9B
	 tnbdDDekiUQS9Nf83q2noB6002it4s97q/CorVZr5ROTml/MDxv/9H5w793TFnemYzW3k
	 GGit9ajajPHJKhbY/UE1hEjBGtzP7VzCpvtUDTrQpO+SAWf9t61yg/c97uMfuXBFmdx6q
	 QNHptvwUIKgeGlfWNmBkDJ2RzSB94q/uhEcmK4fYRvfOe0moFSzoAg1HJjpx0tVCpT57f
	 Jd8YBPUM/kFwoLl79fnK1/4Z8TPdJLYyLsn3syU5lyqSEB8vd+tjuelMhgg2hl+AoNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562969;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=a/1Ab6LqXyvVjuUL1b1c+gCZOX9gTUoQ32uzt8gTbiU=;
	b=pVOr5mgqk9ZnbR1TWz6gfB+4DQvspqeoK/8iYNcPAKXd4jR7F3kQEwBmxYXZc/bLcvdB
	 EDAA0POLrJY/ZCL6YY/ug1dsAaRtrR1PfEKz6msUZe5s4O29a2aBPu7UJZbifZSb357Iu
	 Pe1y1eue8zJ/1fomm6PP7Yh3vwDhfyfD2ce6m8LIwFAiu/8A+lAPDSr/N/poksh9QUkKo
	 tctWP1tSb37A9e/c2hM49XfLMHQDzz6xxuriLxk2G2wFev/Sef4eETQ0VTAoZCUCuGwCt
	 xquLLNAiZV2n25Qwvvr18KZni0LK1tAnfuO9QIKpJt8A2wsjS9ZO5Y6t4WFirVQHIlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yq9UlVZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F723606A31E;
	Tue, 24 Nov 2026 23:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Yq9UlVZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00ED11F000CF;
	Tue, 24 Nov 2026 23:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562969;
	bh=a/1Ab6LqXyvVjuUL1b1c+gCZOX9gTUoQ32uzt8gTbiU=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Yq9UlVZ8B0lmu6ahQCpnrcTK//XXZK+gMGvf0yHeKzdStngFgFqXp83FEgGR7HzNK
	 c1BR3hjx7c0QEKAurUY8pxpk7XJ0YuMBN4vpzebW2cK9xCBBMrgSF06HRvfCDQ7YBN
	 qym7KdIt7EgSBc0TnbCc2LgGz8mVXLEia99lHLQ4=
Date: Tue, 24 Nov 2026 15:29:28 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	mason@kernel.org,liam@infradead.org,kees@kernel.org,josef@toxicpanda.com,
	joey.gouly@arm.com,jannh@google.com,hughd@google.com,gourry@gourry.net,
	david@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,
	bunk@stusta.de,azpijr@gmail.com,a.p.zijlstra@chello.nl,aaw@google.com,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
Subject: + mm-vma-lock-vmas-before-taking-mm_all_locks_mutex.patch added to mm-new branch
Message-Id: <20261124232929.00ED11F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: lock VMAs before taking mm_all_locks_mutex
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-lock-vmas-before-taking-mm_all_locks_mutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-lock-vmas-before-taking-mm_all_locks_mutex.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: lock VMAs before taking mm_all_locks_mutex
Date: Sat, 21 Nov 2026 16:02:28 +0000

If an mmu notifier is registered for an mm while one of its page faults
sleeps indefinitely under the VMA lock, the registration of mmu
notifiers for every other mm can hang un-killably.

mm_all_locks_mutex is shared by all mms, so its holder must not wait for
something that has no bound.

However, mm_take_all_locks() calls vma_start_write() on each VMA with the
mutex held, and thus waits for the readers of the VMA.

Since commit 4ed4379881aa ("mm: handle shared faults under the VMA lock"),
such a reader can sleep in ->page_mkwrite().

Consider fuse_page_mkwrite(), which sleeps until the FUSE server replies to
a write request:

    mm A, thread 1          mm A, thread 2         mm B
    ==============          ==============         ====
    lock_vma_under_rcu()
    fuse_page_mkwrite()
      folio_wait_writeback()
                            mm_take_all_locks()
                              mutex_lock()
                              vma_start_write()
                                                   mm_take_all_locks()
                                                     mutex_lock()

Fix the issue by locking the VMAs before the mutex is taken.

Additionally, make the VMA write lock killable so a fatal signal returns as
quickly as possible.

Finally, update the comments to reflect the change, dropping the lock
ordering list which begs for bitrot.

Note that the lock order at the top of mm/rmap.c doesn't appear to be right
- the hugetlb locks are taken after the VMA write locks. However, this was
already the case, and can be addressed in a follow-up in any case.

Target commit 4ed4379881aa ("mm: handle shared faults under the VMA lock")
as this is where it became possible for VMA lock readers to sleep in
->page_mkwrite().

Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org
Fixes: 4ed4379881aa ("mm: handle shared faults under the VMA lock")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536280440.412063.5336368383648661511.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>

 mm/vma.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/mm/vma.c~mm-vma-lock-vmas-before-taking-mm_all_locks_mutex
+++ a/mm/vma.c
@@ -2375,15 +2375,10 @@ static void vm_lock_mapping(struct mm_st
  * mapping->flags avoid to take the same lock twice, if more than one
  * vma in this mm is backed by the same anon rmap or address_space.
  *
- * We take locks in following order, accordingly to comment at beginning
- * of mm/rmap.c:
- *   - all hugetlbfs_i_mmap_rwsem_key locks (aka mapping->i_mmap_rwsem for
- *     hugetlb mapping);
- *   - all vmas marked locked
- *   - all i_mmap_rwsem locks;
- *   - all anon_vma->rwseml
+ * Mark all vmas locked, before taking mm_all_locks_mutex. Then take remaining
+ * locks in the order mandated by the comment at the top of mm/rmap.c.
  *
- * We can take all locks within these types randomly because the VM code
+ * We can take locks of the same type in arbitrary order because the VM code
  * doesn't nest them and we protected from parallel mm_take_all_locks() by
  * mm_all_locks_mutex.
  *
@@ -2400,20 +2395,24 @@ int mm_take_all_locks(struct mm_struct *
 
 	mmap_assert_write_locked(mm);
 
-	mutex_lock(&mm_all_locks_mutex);
-
 	/*
-	 * vma_start_write() does not have a complement in mm_drop_all_locks()
-	 * because vma_start_write() is always asymmetrical; it marks a VMA as
+	 * VMA write locks do not have a complement in mm_drop_all_locks(),
+	 * because VMA write locking is always asymmetrical; it marks a VMA as
 	 * being written to until mmap_write_unlock() or mmap_write_downgrade()
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
+		int err;
+
 		if (signal_pending(current))
-			goto out_unlock;
-		vma_start_write(vma);
+			return -EINTR;
+		err = vma_start_write_killable(vma);
+		if (err)
+			return err;
 	}
 
+	mutex_lock(&mm_all_locks_mutex);
+
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
 		if (signal_pending(current))
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch
apparmor-convert-vma-flag-tests-to-use-vma_flags_t.patch
ima-convert-vma-flag-tests-to-use-vma_flags_t.patch
ipe-convert-vma-flag-tests-to-use-vma_flags_t.patch
xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch
kvm-ppc-book3s-convert-spapr-tce-mmap-hook-to-mmap_prepare.patch
mshv_vtl-convert-mmap-hooks-to-mmap_prepare.patch
x86-sgx-convert-vepc-mmap-hook-to-mmap_prepare.patch
udf-convert-mmap-hook-to-mmap_prepare.patch
selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch
xen-convert-xenstore-interface-mmap-hooks-to-mmap_prepare.patch
soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch
soc-qcom-rmtfs_mem-convert-mmap-hook-to-mmap_prepare.patch
tee-convert-shm-mmap-hook-to-mmap_prepare.patch
misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch
ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch
vhost-vdpa-convert-mmap-hook-to-mmap_prepare.patch
mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown.patch
mm-vma-lock-vmas-before-taking-mm_all_locks_mutex.patch

