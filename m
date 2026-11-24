Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540400;
	b=EecfAiv0Wd0Dvv83tKOZA5OGIsBNAPU2NXDst2QB7aeZW3j2WGt3lgfSiRfW+XINH+YI
	 A5ECz90djw2228upmEpJFRVZE2/stYYTR8O1SySJisiDjNJf8HZenX4AOgjnE9hh1/ygD
	 NMbDx6yA/HSoYH7mkavU+EXEOmKXaPnTMUDwzXw5UMEsWEkhV1AQde1FRCsHbLISd186i
	 Xvm/zky8myZcX7bG78Jp0B0dFI11UslzvXUfid08psPAB9OkWrvCokT1JXVGdeMGCg1NR
	 QzYDdvbUkPBF7VQ8yWgSlj824978/EfHmK//5WDvqrbC7QPE/zZhgHD633ZkinZjhdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540400;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=gZUr0K7ecy97bpbHsrEJJizhZVvILe97qxf/C1V9a0E=;
	b=ln3/vCpgMZuoWy+sbY5UonmiHblQyyqNCt2abWiDr1O0vROp7wIoNb/xg0zOf9RiXAzY
	 CoYYcOCqwTzTfTANEv8ceFXQ0qP8z3d8B4w8NfNNtCv06Cv7z4xIUCLiiLrrHaXKzZDaV
	 h+/heMURIHr8NiAdNRxtGZL/Vp4dAO+ntBSg+oihwScVSaijufGBjz6jj9bNpSCwclD0T
	 OAeLeytns32/1Qk9OO4OCPIxv20yma4px07JMLzaO9m2pcqVjSzSwzl3R84L0BbINSAnY
	 V6Qcktgg7wWAWCoJoyhWPCRjxmDxMncuvI9+uIf/7a/x0Pvc6hSqZqAw1Kdt1rOAMUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VG4fPCCK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F066606A31E;
	Tue, 24 Nov 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VG4fPCCK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450EB1F000D1;
	Tue, 24 Nov 2026 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540399;
	bh=gZUr0K7ecy97bpbHsrEJJizhZVvILe97qxf/C1V9a0E=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=VG4fPCCKhCAfpHGwIZ0tDPCD1AWlcUGC6HJYT1iaUKSjAZhfZjaIm5xcoikxpv9By
	 WtLJ2Xv+DIGsSH9TGgKWMO9vYvu02zFg+f3T1SrNkaMcZ9BojcwFQYP8AnY3NCsYSm
	 53sa6vSemcFuMYzygPz8yetX+KgBkDxwcp3xh5VA=
Date: Tue, 24 Nov 2026 09:13:18 -0800
To: mm-commits@vger.kernel.org,vschneid@redhat.com,vincent.guittot@linaro.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,
	puranjay@kernel.org,pfalcato@suse.de,peterz@infradead.org,mingo@redhat.com,
	mhocko@suse.com,mgorman@suse.de,mason@kernel.org,liam@infradead.org,
	kprateek.nayak@amd.com,kees@kernel.org,juri.lelli@redhat.com,
	jannh@google.com,dietmar.eggemann@arm.com,david@kernel.org,
	bsegall@google.com,ast@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
Subject: + mm-vma-drop-mm-asynchronously-in-vma_start_read.patch added to mm-hotfixes-unstable branch
Message-Id: <20261124171319.450EB1F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: drop mm asynchronously in vma_start_read()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-drop-mm-asynchronously-in-vma_start_read.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-drop-mm-asynchronously-in-vma_start_read.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/vma: drop mm asynchronously in vma_start_read()
Date: Tue, 24 Nov 2026 12:26:19 +0000

Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
per-VMA locks") open-codes a lock_next_vma() implementation that does
roughly the same thing in bpf_iter_task_vma_find_next(), only without
fallback to an mmap_lock.

This is because bpf_iter_task_vma_find_next() can be called from
non-sleepable contexts.

However, lock_vma_under_rcu() gave no guarantee as to which contexts it is
safe to be called from, and indeed it turns out this assumption is unsafe.

Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
vma->vm_refcnt got dropped"), this call chain is possible on x86:

lock_vma_under_rcu()
  -> vma_start_read()
    -> mmdrop()
      -> __mmdrop()
        -> mm_free_pgd()
          -> pgd_free()
            -> pgd_dtor()
              -> spin_lock(&pgd_lock)

Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
called. Since bpf_iter_task_vma_find_next() can be called in softirq
context, this can deadlock, for example:

pgd_alloc()
  -> spin_lock(&pgd_lock)
    <softirq>
    bpf_iter_task_vma_next()
      -> lock_vma_under_rcu()
        ...
	  -> spin_lock(&pgd_lock) [ DEADLOCK ]

Alexei Starovoitov also pointed out that a BPF program attached to
trace_contention_end() can similarly cause a deadlock:

  pgd_alloc()
    spin_lock(&pgd_lock)
      queued_spin_lock_slowpath()
        trace_contention_end()          <- pgd_lock is held
          tp_btf/contention_end prog
            bpf_iter_task_vma_next()
              lock_vma_under_rcu()
                vma_start_read()
                  mmdrop(other_mm)      <- last put takes pgd_lock again

Resolve the issue by having vma_start_read() use mmdrop_async() instead of
mmdrop() so the work is deferred to a work queue.

Make mmdrop_async() an internal mm function, defined in mm/internal.h, to
avoid abuse elsewhere (kernel/fork.c includes this header, so still retains
access).

Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
failure") accounted for the fact that the RCU lock had to be dropped for
this operation, which is no longer applicable.

For the sake of a backported fix, retain this behaviour, however drop the
RCU lock last and remove the now irrelevant comment.

Link: https://patch.msgid.link/20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org
Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kees Cook <kees@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: <stable@vger.kernel.org>

 kernel/fork.c  |   16 ----------------
 mm/internal.h  |    3 +++
 mm/mmap_lock.c |   21 ++++++++++++++++++---
 3 files changed, 21 insertions(+), 19 deletions(-)

--- a/kernel/fork.c~mm-vma-drop-mm-asynchronously-in-vma_start_read
+++ a/kernel/fork.c
@@ -744,22 +744,6 @@ void __mmdrop(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(__mmdrop);
 
-static void mmdrop_async_fn(struct work_struct *work)
-{
-	struct mm_struct *mm;
-
-	mm = container_of(work, struct mm_struct, async_put_work);
-	__mmdrop(mm);
-}
-
-static void mmdrop_async(struct mm_struct *mm)
-{
-	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
-		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
-		schedule_work(&mm->async_put_work);
-	}
-}
-
 static inline void free_signal_struct(struct signal_struct *sig)
 {
 	taskstats_tgid_free(sig);
--- a/mm/internal.h~mm-vma-drop-mm-asynchronously-in-vma_start_read
+++ a/mm/internal.h
@@ -1691,4 +1691,7 @@ static inline bool can_spin_trylock(void
 /* char-mem.c */
 bool file_is_dev_zero(const struct file *file);
 
+/* mmap_lock.c */
+void mmdrop_async(struct mm_struct *mm);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/mmap_lock.c~mm-vma-drop-mm-asynchronously-in-vma_start_read
+++ a/mm/mmap_lock.c
@@ -306,11 +306,10 @@ err_unstable:
 	 */
 	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
 
-	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
-	rcu_read_unlock();
 	mmgrab(other_mm);
 	vma_refcount_put(vma);
-	mmdrop(other_mm);
+	mmdrop_async(other_mm);
+	rcu_read_unlock();
 
 	return NULL;
 }
@@ -560,6 +559,22 @@ void __mm_reset_vma_seqcounts(struct mm_
 }
 EXPORT_SYMBOL(__mm_reset_vma_seqcounts);
 
+static void mmdrop_async_fn(struct work_struct *work)
+{
+	struct mm_struct *mm;
+
+	mm = container_of(work, struct mm_struct, async_put_work);
+	__mmdrop(mm);
+}
+
+void mmdrop_async(struct mm_struct *mm)
+{
+	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
+		INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
+		schedule_work(&mm->async_put_work);
+	}
+}
+
 #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
 #include <linux/extable.h>
 
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

