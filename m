Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246355;
	b=4JMaNbyv/hFP+3/IiLF+rTlq7GPtPD6f0VIOtch0UbaFZqlQ1c6AU0aSSWCmkeku53qX
	 aJCgsIHAjHtNcwWJkXVd+czceHMkiJTbDAXHvD/jUzPYaOocGGjfoSHdq6QTVi1MtV7mJ
	 7ukhxNSkHfYlEhqq3dZ1EVfoFRt/os7XGq6Kr3I8EzDg6lfGkC/Razt7tSPlh3IKiFSEd
	 04FScM8QH3qbB2YOS8YFBcNOVQ75c0xAuJpcC5T/MfAJ25yCk3J/AdsG7BNo42rmlFlmB
	 SG9qmq2KzLyB4f16s0T+6PZ7GO8CHWTMtl8jHsyKa6LyWBnf0Buo0bj6pKpUmK8qVHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246355;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=/2RhOIXMC6semYQ1YGmr6CMCTp3y4rt+SV281ltu91k=;
	b=SCoxY9MHoW27iniPrRKCEEr0QNR9wGAXThb32MDU6ZVaPvNsiAOOPKAID3c9gQ2DUVKx
	 51KB7iVAIcM11erYXZJTELv36+ycW/APGyhE6cGs8RU1JWuvgAFzxz3ZmsStohi5igqRO
	 QPBfCE9MCigTHRStjNtyBbONOJZx8sc43qKqbL4fMpWeV5j6jjDl7KniA4mF0eb4c2cYX
	 C7/s16j3E2GUAjgxazkTHdshNaqr/tINWHN1UMjMXgtgbYbeO1/RS5Y8DW+d2jY9wcUed
	 H0gdmnFEtjz6hteAd4OwBJwQ2STK39nF9d0jSElUmYa1g3r+5+G0l0DtOrlDB/xwrMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X22vmfF4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C8606A32A
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X22vmfF4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2841F008A1;
	Mon,  9 Nov 2026 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246355;
	bh=/2RhOIXMC6semYQ1YGmr6CMCTp3y4rt+SV281ltu91k=;
	h=Date:To:Cc:From:Subject;
	b=X22vmfF4FOZhrmA1BAfgrEdBxhnYzn7vC8mXfLNlYDwHT1jRJwIzX9Ohm7DSeWtnP
	 4dNP2B0a1/yd+RkPthmGoIS1fYYBdWbUnVRoC6xnAaF9XAmhDtCBLKL97GZahR/g3t
	 hx0cC5AnIuWtjX1oDe7WALHVpe1bWbWqjvpxdQ/s=
Date: Mon, 09 Nov 2026 09:45:54 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-convert-remaining-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174555.1D2841F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/rmap: convert remaining VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-rmap-convert-remaining-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/rmap: convert remaining VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:30:54 +0000

Replace the remaining uses of the legacy vm_flags_t flags in the rmap logic
with vma_flags_t values.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-3-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
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

 mm/rmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-convert-remaining-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/rmap.c
@@ -1211,7 +1211,7 @@ static bool page_mkclean_one(struct foli
 
 static bool invalid_mkclean_vma(struct vm_area_struct *vma, void *arg)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return true;
@@ -1675,7 +1675,8 @@ void folio_add_new_anon_rmap(struct foli
 	 * VM_DROPPABLE mappings don't swap; instead they're just dropped when
 	 * under memory pressure.
 	 */
-	if (!folio_test_swapbacked(folio) && !(vma->vm_flags & VM_DROPPABLE))
+	if (!folio_test_swapbacked(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE))
 		__folio_set_swapbacked(folio);
 	__folio_set_anon(folio, vma, address, exclusive);
 
@@ -2109,7 +2110,8 @@ static bool ttu_anon_lazyfree_folio(stru
 	 */
 	smp_rmb();
 
-	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+	if (folio_test_dirty(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE)) {
 		/*
 		 * redirtied either using the page table or a previously
 		 * obtained GUP reference.
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t.patch
mm-convert-thp-vma-flag-tests-to-use-vma_flags_t.patch
mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

