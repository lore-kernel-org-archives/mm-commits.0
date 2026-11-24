Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537114;
	b=dv7In34B7cNR6XEINIGvwfRxzRZnMa9/yon5zxPfe9WhhurPXODC0+RqmGsxfllvYYAs
	 lfTWr2GYLwOciQanYI4Y0eJ6PJfIoqb3qPQHwfmgSDc6Xi+j3FL8Kyu3yRPhIWGuStgSe
	 EBbxQ1oqBYslKmwPMotZAjb/gV5XT8zvYY7mLbj366ydqUIXIQrbgp0iQvLiQWsli6pvr
	 mVvLxPzwU/B8/IqDilAZOJZyxxtKaHG1082TuwhkMGnuJlJAQ6LEpUcDggJhtf9BVodiG
	 oof8FYFQHmmx94xXrgPmLDQHHHA3ZQ3mENorwXR5c+g4rKMb1+WEd5VveioCYqt4lzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537114;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=cVSASMMamRzfAO13EBoPnkGpTtet3ES2npaDEh4mRdg=;
	b=BnX7Tl4Jr8unVyr7xWJueOHYl+W97bMUgwTdLaeMus1t7u2xuP6PYyIvcIr6Qw2kuKUw
	 HATe/vCckXybx2f3NZOtHxFFhMy6POF0ZriEwCICKfhNTSflQPhfPYShx1AIFHICmZ1az
	 EqD1cQcSV9iI5uWN33s8qAeU2AZcusKmW2EehTgEs/vOVVoFx87g6dBxJzw2nc/+SSiYV
	 EgrClHIAwgvGa0QoqiyUMJEolvy0VeuPLETMxPFAYsisEnXxueNw93ojbrIxSflMe3U/8
	 8rBuJOvIUty2UGuM0d7Xbmrc1ukUuOho/+iFgP5S/UWnAARURthyVXKP87kikReibbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Y+nZKbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32463606A321;
	Tue, 24 Nov 2026 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2Y+nZKbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834211F000E0;
	Tue, 24 Nov 2026 16:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537113;
	bh=cVSASMMamRzfAO13EBoPnkGpTtet3ES2npaDEh4mRdg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=2Y+nZKbMTueUg/4Mum21lkV+2xy8xd7cI2MSZagsmsHhzcaWJEeyvF/s6ONExEilZ
	 57U/vhDftmAmkmYZE5JHB2HO/vVLaquJ/DF7XEUphnnjkFA7y/fO7BmXoCo0QpoDaS
	 7KGo6ftUOAsjlUiPmR6lqNwGES36lTd4XuEqMERg=
Date: Tue, 24 Nov 2026 08:18:32 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,
	rick.p.edgecombe@intel.com,pfalcato@suse.de,peng.fan@nxp.com,
	nphamcs@gmail.com,mhocko@suse.com,matthew.brost@intel.com,mason@kernel.org,
	liam@infradead.org,kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jglisse@redhat.com,jbacik@fb.com,jannh@google.com,jack@suse.cz,
	hannes@cmpxchg.org,gourry@gourry.net,dennisszhou@gmail.com,dennis@kernel.org,
	david@kernel.org,dave.hansen@linux.intel.com,cl@gentwo.org,
	chris@chrisdown.name,byungchul@sk.com,broonie@kernel.org,bp@alien8.de,
	balbirs@nvidia.com,apopple@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org>
Subject: + mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch added to mm-unstable branch
Message-Id: <20261124161833.834211F000E0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/mmap: free gathered pages before MMF_OOM_SKIP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/mmap: free gathered pages before MMF_OOM_SKIP
Date: Fri, 13 Nov 2026 21:45:19 +0000

The OOM killer can quickly trigger again after having selected a
victim. That victim might not have freed its memory yet, but its mm will
be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.

This can cause the OOM killer to kill an innocent process when the first
might have freed enough memory to relieve the memory pressure.

exit_mmap() marks the mm MMF_OOM_SKIP once unmap_vmas() returns.
However unmap_vmas() does not free the last batch of pages it
gathered. That is left to tlb_finish_mmu(), which runs after
MMF_OOM_SKIP is set, and the batch can be large.

Fix the issue by freeing the gathered pages of an OOM victim before
marking the mm MMF_OOM_SKIP.

Note that the task which calls mmput() might not be the victim - if it
took a reference on the mm (e.g. ptrace), it may hold the last reference
and release it when it calls mmput().

Therefore we cannot rely on current to tell whether the mm belongs to an
OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
mark_oom_victim() sets on the victim's mm, and check that.

Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-1-50a2ed382b61@kernel.org
Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
  Link: https://lore.kernel.org/20261114115630.0b75d0b49869d4fa@chrisdown.name
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Yu, Yu-cheng <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dennis Zhou (Facebook) <dennisszhou@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>

 include/linux/mm_types.h |    2 ++
 include/linux/oom.h      |    9 +++++++++
 mm/mmap.c                |    9 ++++++++-
 mm/oom_kill.c            |    4 +++-
 4 files changed, 22 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~mm-mmap-free-gathered-pages-before-mmf_oom_skip
+++ a/include/linux/mm_types.h
@@ -2030,6 +2030,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_OOM_VICTIM		32	/* mm is the oom victim */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
--- a/include/linux/oom.h~mm-mmap-free-gathered-pages-before-mmf_oom_skip
+++ a/include/linux/oom.h
@@ -77,6 +77,15 @@ static inline bool tsk_is_oom_victim(str
 }
 
 /*
+ * Use this helper if tsk->mm != mm and the victim mm needs a special
+ * handling. This is guaranteed to stay true after once set.
+ */
+static inline bool mm_is_oom_victim(struct mm_struct *mm)
+{
+	return mm_flags_test(MMF_OOM_VICTIM, mm);
+}
+
+/*
  * Checks whether a page fault on the given mm is still reliable.
  * This is no longer true if the oom reaper started to reap the
  * address space which is reflected by MMF_UNSTABLE flag set in
--- a/mm/mmap.c~mm-mmap-free-gathered-pages-before-mmf_oom_skip
+++ a/mm/mmap.c
@@ -1317,11 +1317,18 @@ void exit_mmap(struct mm_struct *mm)
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
 	unmap_vmas(&tlb, &unmap);
+
+	/*
+	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
+	 * killer will only skip this mm if it's already freed all it can.
+	 */
+	if (mm_is_oom_victim(mm))
+		tlb_flush_mmu(&tlb);
 	mmap_read_unlock(mm);
 
 	/*
 	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
-	 * because the memory has been already freed.
+	 * because the memory has been already unmapped.
 	 */
 	mm_flags_set(MMF_OOM_SKIP, mm);
 	mmap_write_lock(mm);
--- a/mm/oom_kill.c~mm-mmap-free-gathered-pages-before-mmf_oom_skip
+++ a/mm/oom_kill.c
@@ -752,8 +752,10 @@ static void mark_oom_victim(struct task_
 		return;
 
 	/* oom_mm is bound to the signal struct life time. */
-	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
+	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm)) {
 		mmgrab(tsk->signal->oom_mm);
+		mm_flags_set(MMF_OOM_VICTIM, mm);
+	}
 
 	/*
 	 * Make sure that the process is woken up from uninterruptible sleep
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch

