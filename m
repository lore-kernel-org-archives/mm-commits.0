Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246361;
	b=fvA+XwU+Yhe0jRAvGXy8RYoZuM2X/T6RBOuDzKFn4K4nIjayYwIFmQAjR5r1APxxQmAJ
	 ox2vXu6tCo8wdIZcwO251AQxuYyXwTHmN318tG9qDEkXyT37qoSeBvlIM6/rMOjcCrZCc
	 Tcl5+Xvf3/tXjSjeDzhOU/O/NgZhjaV+G6c0fdtCjTul4HQy8KJXqztjCEIq8UCCuVFiQ
	 Ssc/j8CEkrYysC7DYAB/+nbO6CL5ZIVFXHk1oeC9LjkFdztg0wdrimKuFDrdSLaCO3KxG
	 M78IIh3IynZt9/mc7VxYaNnaYPfZjrEj2vf6LXFTqmFDto8R5NVuFrdH5rmRq1DaQbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246361;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=/Is03Ts2xR+RrpO4+h9WsHmP6tCaCtiEJL9pr8naUMI=;
	b=a35OcICJjICs6XNTQ1zC2DVoqM1LVAMSRQIA8OtucRk80YY7W+/T4RzRcpA/6SmkDQSD
	 ewHu4ddqStERb7c1ysOfCD4jj4mLm9CLTFFix8Rw9ZEEWTAAwfsMVS10enXGl6YfnGOp6
	 D6zK55D4hsXpHUy9w1qZO5wAn/03Q1n0fwf13YkQpWj5WvjZvrG0fNiNT3M0ZTA8tqEtZ
	 g8iknoZ1cWRwGVsMpsvoR5DaI8A7rYbKMNDxQgHZn9QY3WUIzQ1z/RlkXa0iQRHnX6IUw
	 L3GoRU8wi8oy/yZtooaJhHpX5tqfSPFjBnK7Z5hTrvoKKph6ycC4UXKFXczTYD54QBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UO9v1P3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB13D606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UO9v1P3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22ED11F008A2;
	Mon,  9 Nov 2026 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246360;
	bh=/Is03Ts2xR+RrpO4+h9WsHmP6tCaCtiEJL9pr8naUMI=;
	h=Date:To:Cc:From:Subject;
	b=UO9v1P3SK4f4pNoabdyod7/FjXlgb8xq0GLMHeyRYuIahHbDiQ9vUFctOgr6Ev+Ws
	 EwBfz0/w9ayTkmwBF/u6BJFABtWKBgEInodluoYFaraVT2mYGl6yNBPeiSa4rSQfsJ
	 nKgbmeK1yvwSuONMnsWupir1efiPpjwJbsAFrF9s=
Date: Mon, 09 Nov 2026 09:45:59 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174600.22ED11F008A2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/ksm: convert VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/ksm: convert VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:30:57 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
KSM tests VMA flags directly.

The ksm_madvise() interface continues to take legacy flags for the time
being.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-6-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Georgia Garcia <georgia.garcia@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: Fan Wu <wufan@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>
---

 mm/ksm.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/ksm.c
@@ -781,7 +781,7 @@ static struct vm_area_struct *find_merge
 	if (ksm_test_exit(mm))
 		return NULL;
 	vma = vma_lookup(mm, addr);
-	if (!vma || !(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
+	if (!vma || !vma_test(vma, VMA_MERGEABLE_BIT) || !vma_has_anon_rmap(vma))
 		return NULL;
 	return vma;
 }
@@ -1245,7 +1245,8 @@ static int unmerge_and_remove_all_rmap_i
 			goto mm_exiting;
 
 		for_each_vma(vmi, vma) {
-			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
+			if (!vma_test(vma, VMA_MERGEABLE_BIT) ||
+			    !vma_has_anon_rmap(vma))
 				continue;
 			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
 			if (err)
@@ -2700,7 +2701,7 @@ next_mm:
 		goto no_vmas;
 
 	for_each_vma(vmi, vma) {
-		if (!(vma->vm_flags & VM_MERGEABLE))
+		if (!vma_test(vma, VMA_MERGEABLE_BIT))
 			continue;
 		if (ksm_scan.address < vma->vm_start)
 			ksm_scan.address = vma->vm_start;
@@ -2892,7 +2893,7 @@ static int __ksm_del_vma(struct vm_area_
 {
 	int err;
 
-	if (!(vma->vm_flags & VM_MERGEABLE))
+	if (!vma_test(vma, VMA_MERGEABLE_BIT))
 		return 0;
 
 	if (vma_has_anon_rmap(vma)) {
@@ -3029,7 +3030,7 @@ int ksm_madvise(struct vm_area_struct *v
 
 	switch (advice) {
 	case MADV_MERGEABLE:
-		if (vma->vm_flags & VM_MERGEABLE)
+		if (vma_test(vma, VMA_MERGEABLE_BIT))
 			return 0;
 		if (!vma_ksm_compatible(vma))
 			return 0;
@@ -3514,7 +3515,7 @@ bool ksm_process_mergeable(struct mm_str
 	mmap_assert_locked(mm);
 	VMA_ITERATOR(vmi, mm, 0);
 	for_each_vma(vmi, vma)
-		if (vma->vm_flags & VM_MERGEABLE)
+		if (vma_test(vma, VMA_MERGEABLE_BIT))
 			return true;
 
 	return false;
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

