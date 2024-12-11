Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201A970803
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877749; cv=none; b=QSx/cFOHXuc++85XsHYM3drSSyxWxZtVJOwN8MB2K1CPYI3WvbFY2l945nPrQJ8xJxufvqGvccjYN0wqXvEFmME2vRPW/I6MUr+bh6MEvoUUQ6VVIAO09mIv1wOuYbdZ4wXJwZdll+fREnszFoJpEVl3F6N3yscp5s919DioZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877749; c=relaxed/simple;
	bh=1W3CzvL0DDlBqraXoterXnGCHjHptkq/CUR4uaumyoA=;
	h=Date:To:From:Subject:Message-Id; b=PuXf/0Ahc0JSuL0gQ8CMprWdf/s0ZEPY099Rx/2ivD2GlxV2dGkotinGHmq67os5gsNtg6gRA3gPKxvIUEqBknztM623yWa7Tv05h9qz2M2qD19U9zPZa9zTCVJcfd9x/nF5quoecnGCIMWjXX7ORshHKkGj0lQTq3MncgObH2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xnreb9GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xnreb9GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B8AC4CED6;
	Wed, 11 Dec 2024 00:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877747;
	bh=1W3CzvL0DDlBqraXoterXnGCHjHptkq/CUR4uaumyoA=;
	h=Date:To:From:Subject:From;
	b=Xnreb9GCG2YqZxjHOkmbBBVul5JgYtWYmWUlajr7IZDpoFbfO9kzclO5mL6sKnGje
	 559cJmZ+9+49gZjJghZntVcg9iZVnhF6emhlkrLEKUnQHAbN0y/6Sivv6aRhAL3xEx
	 VqPnZI4g36sfZfJxbrXvJgd7n+sa8L2L6IxEzTjU=
Date: Tue, 10 Dec 2024 16:42:26 -0800
To: mm-commits@vger.kernel.org,zhangpeng.00@bytedance.com,vbabka@suse.cz,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,Liam.Howlett@Oracle.com,kan.liang@linux.intel.com,jolsa@kernel.org,jannh@google.com,irogers@google.com,david@redhat.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch added to mm-hotfixes-unstable branch
Message-Id: <20241211004227.89B8AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: avoid inappropriate uprobe access to invalid mm
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fork: avoid inappropriate uprobe access to invalid mm
Date: Tue, 10 Dec 2024 17:24:12 +0000

If dup_mmap() encounters an issue, currently uprobe is able to access the
relevant mm via the reverse mapping (in build_map_info()), and if we are
very unlucky with a race window, observe invalid XA_ZERO_ENTRY state which
we establish as part of the fork error path.

This occurs because uprobe_write_opcode() invokes anon_vma_prepare() which
in turn invokes find_mergeable_anon_vma() that uses a VMA iterator,
invoking vma_iter_load() which uses the advanced maple tree API and thus
is able to observe XA_ZERO_ENTRY entries added to dup_mmap() in commit
d24062914837 ("fork: use __mt_dup() to duplicate maple tree in
dup_mmap()").

This change was made on the assumption that only process tear-down code
would actually observe (and make use of) these values.  However this very
unlikely but still possible edge case with uprobes exists and
unfortunately does make these observable.

The uprobe operation prevents races against the dup_mmap() operation via
the dup_mmap_sem semaphore, which is acquired via uprobe_start_dup_mmap()
and dropped via uprobe_end_dup_mmap(), and held across
register_for_each_vma() prior to invoking build_map_info() which does the
reverse mapping lookup.

Currently these are acquired and dropped within dup_mmap(), which exposes
the race window prior to error handling in the invoking dup_mm() which
tears down the mm.

We can avoid all this by just moving the invocation of
uprobe_start_dup_mmap() and uprobe_end_dup_mmap() up a level to dup_mm()
and only release this lock once the dup_mmap() operation succeeds or clean
up is done.

This means that the uprobe code can never observe an incompletely
constructed mm and resolves the issue in this case.

Link: https://lkml.kernel.org/r/20241210172412.52995-1-lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: syzbot+2d788f4f7cb660dac4b7@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6756d273.050a0220.2477f.003d.GAE@google.com/
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/kernel/fork.c~fork-avoid-inappropriate-uprobe-access-to-invalid-mm
+++ a/kernel/fork.c
@@ -639,11 +639,8 @@ static __latent_entropy int dup_mmap(str
 	LIST_HEAD(uf);
 	VMA_ITERATOR(vmi, mm, 0);
 
-	uprobe_start_dup_mmap();
-	if (mmap_write_lock_killable(oldmm)) {
-		retval = -EINTR;
-		goto fail_uprobe_end;
-	}
+	if (mmap_write_lock_killable(oldmm))
+		return -EINTR;
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*
@@ -782,8 +779,6 @@ out:
 		dup_userfaultfd_complete(&uf);
 	else
 		dup_userfaultfd_fail(&uf);
-fail_uprobe_end:
-	uprobe_end_dup_mmap();
 	return retval;
 
 fail_nomem_anon_vma_fork:
@@ -1692,9 +1687,11 @@ static struct mm_struct *dup_mm(struct t
 	if (!mm_init(mm, tsk, mm->user_ns))
 		goto fail_nomem;
 
+	uprobe_start_dup_mmap();
 	err = dup_mmap(mm, oldmm);
 	if (err)
 		goto free_pt;
+	uprobe_end_dup_mmap();
 
 	mm->hiwater_rss = get_mm_rss(mm);
 	mm->hiwater_vm = mm->total_vm;
@@ -1709,6 +1706,8 @@ free_pt:
 	mm->binfmt = NULL;
 	mm_init_owner(mm, NULL);
 	mmput(mm);
+	if (err)
+		uprobe_end_dup_mmap();
 
 fail_nomem:
 	return NULL;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

docs-mm-add-vma-locks-documentation.patch
mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
mm-correctly-reference-merged-vma.patch
fork-avoid-inappropriate-uprobe-access-to-invalid-mm.patch
mm-vma-move-brk-internals-to-mm-vmac.patch
mm-vma-move-brk-internals-to-mm-vmac-fix.patch
mm-vma-move-unmapped_area-internals-to-mm-vmac.patch
mm-abstract-get_arg_page-stack-expansion-and-mmap-read-lock.patch
mm-vma-move-stack-expansion-logic-to-mm-vmac.patch
mm-vma-move-__vm_munmap-to-mm-vmac.patch
selftests-mm-add-fork-cow-guard-page-test.patch
mm-enforce-__must_check-on-vma-merge-and-split.patch
mm-perform-all-memfd-seal-checks-in-a-single-place.patch
mm-perform-all-memfd-seal-checks-in-a-single-place-fix.patch

