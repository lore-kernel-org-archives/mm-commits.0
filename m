Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537125;
	b=rHPtxl3vEkeTd7x24TeT+nJkjUGo9bPQvnvDrOA+J0tLpcpjk9aiXvHvzW3zXqSFMsm7
	 i03VMAsa8Cx4ZCciXikPGAkW4v3ypQVHVvqqQSeKWfAUvLqYfi8nfJ2d5RbQimNYm+3gF
	 91KDokLh2QVLsgGCUaAm08OqgCHByEhYFVj7bDfEzzJp1e8uimuJOwVMXzKXaHlVQHU1b
	 53ngPBgDc39TUtoelXfy27aJLJLM1TGtjqmrU7i+b5KeCrLXgp0/LF1+/FyMgCRMd4Swo
	 hRGq6MWOK9w3M1gRC75x5pIOO7lPjOomlBIctxugCKXvkVgiGJ7EZ+9KTa1Jh1D/EXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537125;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=MqH6Gxm9nM1rtjpK13MiGdBA9/H3IcCHAVFZDbymFCY=;
	b=VnJDoTuyb9zg8CDD3uDQBo4e2ykyb41mF/Ka1k4b/NtNFrtpEplM6IPlDchdDgl94Dmj
	 9slnvZlXKJjseDMIXWPQsDkgQHIudXYgPC7CmBhOM/oI+h8bGlhCereUCUA0nSYJahzd0
	 tyMLasNzriRV563v8VswGGmE5DuEJeMWQ5rMs8mBNMapM1gHYulaOdmnv/hF3pGCfzvFL
	 mwJHSCyC3yc1REV8y0ZMzsFUBRI1SB18vV25CPjdfz1Kysd27dU2+CaJgZtWBzcyEsYpS
	 ssQO2AjqgDtkPzbcaaCnaGG/EVOoZWUmxbFLU8l8ZF9EctUQNyZCiU1GzocyaiiZEhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H8x6ejmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E76A606A323
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=H8x6ejmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C081F000CA;
	Tue, 24 Nov 2026 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537125;
	bh=MqH6Gxm9nM1rtjpK13MiGdBA9/H3IcCHAVFZDbymFCY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=H8x6ejmtpO4vxY/5JFptYHuHLX1r0cyphJUG3kIxGhieTipB5iAZpiC3rm8mgM/r9
	 XJFLYYvpuVMEUOQDc1jgdfdlnL7qQTrrPxgSgI8lhmveA55ekCM0FE9+ZrYrrQLDCK
	 e3zNjYKGnaKFqQRXqAYjWfc2yBaa9z3tgWY54xKU=
Date: Tue, 24 Nov 2026 08:18:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,
	rppt@kernel.org,rientjes@google.com,rick.p.edgecombe@intel.com,
	pfalcato@suse.de,peng.fan@nxp.com,nphamcs@gmail.com,mhocko@suse.com,
	matthew.brost@intel.com,mason@kernel.org,liam@infradead.org,
	kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,jglisse@redhat.com,
	jbacik@fb.com,jannh@google.com,jack@suse.cz,hannes@cmpxchg.org,
	gourry@gourry.net,dennisszhou@gmail.com,dennis@kernel.org,david@kernel.org,
	dave.hansen@linux.intel.com,cl@gentwo.org,chris@chrisdown.name,
	byungchul@sk.com,broonie@kernel.org,bp@alien8.de,balbirs@nvidia.com,
	apopple@nvidia.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
Subject: + percpu-fix-contig-hints-that-are-too-low.patch added to mm-unstable branch
Message-Id: <20261124161844.C7C081F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: percpu: fix contig hints that are too low
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-fix-contig-hints-that-are-too-low.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-fix-contig-hints-that-are-too-low.patch

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
Subject: percpu: fix contig hints that are too low
Date: Fri, 13 Nov 2026 21:45:29 +0000

pcpu_find_block_fit() skips a chunk or block whose contig_hint is too
small for the request, so a contig_hint must never be smaller than the
largest free area.

If it is, atomic and reserved chunk allocations can fail spuriously, and
others can create a chunk which is not needed.

There are three ways in which this can happen:

Firstly, when an allocation breaks a contig_hint, both
pcpu_block_refresh_hint() and pcpu_chunk_refresh_hint() promote the
scan_hint to contig_hint and scan only what follows it. However a free
can set the scan_hint regardless of what precedes it:

    free areas    A = 10 bits, then C = 50 bits
    hints         contig_hint = C
                  scan_hint = 0, cleared by an earlier allocation
    free B        5 bits between A and C: scan_hint = B
    allocate C    contig_hint = B, the scan starts after B
    result        contig_hint = 5, but A has 10 bits

Secondly, when a free stays within one block,
pcpu_block_update_hint_free() passes the end of the free area to the
chunk hints as a block offset rather than a chunk offset, so in any block
but the first the chunk hints are not updated at all.

Thirdly, that free area stops at the block boundary, even if the free
bits continue into a neighbouring block.

Fix these by always rescanning when a contig_hint is broken, passing the
correct offset, and refreshing the chunk hints whenever a free area
reaches a block boundary.

Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org
Fixes: da3afdd5bb54 ("percpu: use block scan_hint to only scan forward")
Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Fixes: d33d9f3dd96b ("percpu: use chunk scan_hint to skip some scanning")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
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
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Balbir Singh <balbirs@nvidia.com>
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
Cc: Chris Down <chris@chrisdown.name>

 mm/percpu.c |   59 +++++++++++---------------------------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

--- a/mm/percpu.c~percpu-fix-contig-hints-that-are-too-low
+++ a/mm/percpu.c
@@ -733,30 +733,16 @@ static void pcpu_block_update_scan(struc
 /**
  * pcpu_chunk_refresh_hint - updates metadata about a chunk
  * @chunk: chunk of interest
- * @full_scan: if we should scan from the beginning
  *
  * Iterates over the metadata blocks to find the largest contig area.
- * A full scan can be avoided on the allocation path as this is triggered
- * if we broke the contig_hint.  In doing so, the scan_hint will be before
- * the contig_hint or after if the scan_hint == contig_hint.  This cannot
- * be prevented on freeing as we want to find the largest area possibly
- * spanning blocks.
  */
-static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
+static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk)
 {
 	struct pcpu_block_md *chunk_md = &chunk->chunk_md;
-	int bit_off, bits;
+	int bit_off = chunk_md->first_free, bits;
 
-	/* promote scan_hint to contig_hint */
-	if (!full_scan && chunk_md->scan_hint) {
-		bit_off = chunk_md->scan_hint_start + chunk_md->scan_hint;
-		chunk_md->contig_hint_start = chunk_md->scan_hint_start;
-		chunk_md->contig_hint = chunk_md->scan_hint;
-		chunk_md->scan_hint = 0;
-	} else {
-		bit_off = chunk_md->first_free;
-		chunk_md->contig_hint = 0;
-	}
+	chunk_md->contig_hint = 0;
+	chunk_md->scan_hint = 0;
 
 	pcpu_for_each_md_free_region(chunk, bit_off, bits)
 		pcpu_block_update(chunk_md, bit_off, bit_off + bits);
@@ -774,19 +760,10 @@ static void pcpu_block_refresh_hint(stru
 {
 	struct pcpu_block_md *block = chunk->md_blocks + index;
 	unsigned long *alloc_map = pcpu_index_alloc_map(chunk, index);
-	unsigned int start, end;	/* region start, region end */
-
-	/* promote scan_hint to contig_hint */
-	if (block->scan_hint) {
-		start = block->scan_hint_start + block->scan_hint;
-		block->contig_hint_start = block->scan_hint_start;
-		block->contig_hint = block->scan_hint;
-		block->scan_hint = 0;
-	} else {
-		start = block->first_free;
-		block->contig_hint = 0;
-	}
+	unsigned int start = block->first_free, end;
 
+	block->contig_hint = 0;
+	block->scan_hint = 0;
 	block->right_free = 0;
 
 	/* iterate over free areas and update the contig hints */
@@ -938,7 +915,7 @@ static void pcpu_block_update_hint_alloc
 				chunk_md->contig_hint,
 				bit_off,
 				bit_off + bits))
-		pcpu_chunk_refresh_hint(chunk, false);
+		pcpu_chunk_refresh_hint(chunk);
 }
 
 /**
@@ -952,12 +929,8 @@ static void pcpu_block_update_hint_alloc
  * forward and backward to determine the extent of the free area.  This is
  * capped at the boundary of blocks.
  *
- * A chunk update is triggered if a page becomes free, a block becomes free,
- * or the free spans across blocks.  This tradeoff is to minimize iterating
- * over the block metadata to update chunk_md->contig_hint.
- * chunk_md->contig_hint may be off by up to a page, but it will never be more
- * than the available space.  If the contig hint is contained in one block, it
- * will be accurate.
+ * The chunk metadata is refreshed if the free area reaches a block boundary,
+ * as it may then extend into neighbouring blocks.
  */
 static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 					int bits)
@@ -1042,18 +1015,12 @@ static void pcpu_block_update_hint_free(
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, nr_empty_pages);
 
-	/*
-	 * Refresh chunk metadata when the free makes a block free or spans
-	 * across blocks.  The contig_hint may be off by up to a page, but if
-	 * the contig_hint is contained in a block, it will be accurate with
-	 * the else condition below.
-	 */
-	if (((end - start) >= PCPU_BITMAP_BLOCK_BITS) || s_index != e_index)
-		pcpu_chunk_refresh_hint(chunk, true);
+	if (!start || end == PCPU_BITMAP_BLOCK_BITS || s_index != e_index)
+		pcpu_chunk_refresh_hint(chunk);
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(s_index, end));
 }
 
 /**
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

