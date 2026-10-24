Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832471;
	b=EZNTRYpwgMQIwy0m3Du7nyu9emOtab2Wh1/Fi6c4167BgBUzZDtoyD9boJ0xHnHI7EJ9
	 8JZ09SsNAFjOAMsdZuHfYOtS24oaFxeVlFK2u8CelF1tapt++knhEZCb/T/p5g50jOCO4
	 yO9SU2qUG9uQP1srhMykamX87lbvXMF7Inz9tZBHc9Ir6OWRg9cNAlkhb/wbsxow57m8B
	 CTgd4KxJua8JNsVAXw8UuDYnV0IIFcRkblENSr+l5b6XD6PjNvhX0NtXOw7QwKFnsV5pm
	 0Q5tffpQMWPHDPbize0wCjaVf9mZEJ+vvbe0qrXVn9JAg5Gd6ojBgrP0qrsbk+C5eMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832471;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=wXuE/LhwDw4dTFV7U9C8X2MvISopcF1QumORNGJGh7k=;
	b=GHtDgPjdx4lvAcoZEYZOPNdoBTNlGzZfcxtBmUNgFVleVUQSH7MfwWacjINhgpdNsets
	 yCiTYz4lhfT5Ymknx4Y01oFnFiibbG+KL99Clq+nU32ORueuXfaKbTQFISVeRmoL6Z+BL
	 Qt1sCnthrPvvj8vUtjn/yiWJz3tkazQcNIpakof3vPhalyzgPOdv1+iCJh2WhKoiROCWa
	 jnjsjtuFINHADpO5VC04p+9xwFtQoelT+B7Qv8UahZiZFY2XyzqR2o7HZ1qzk9ZQxiTfv
	 hW/A8NpVC43raA0aksYFz1JqRMs8GH/2yinBSwYoWy20usGI+FOz+lzs9FEXbw7m6wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VYKjYy6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C31F606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=VYKjYy6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD321F01828;
	Sat, 24 Oct 2026 09:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832471;
	bh=wXuE/LhwDw4dTFV7U9C8X2MvISopcF1QumORNGJGh7k=;
	h=Date:To:From:Subject;
	b=VYKjYy6gwCBax6F0FzCZEfwOpnS22gP4c1MVQgLISOoveAuVcazdkjS7oEAV+QW5a
	 FgQh14FWzUPrk+95IBKYN4g1Axmz2kflUfulJjvms4/0gvHmvTNFRoldpFXn2a2OC5
	 PS4PK1Wl3EN0NURVTR0eMd2fMGCDpSgVtAWcvL4A=
Date: Sat, 24 Oct 2026 02:01:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sarthak.sharma@arm.com,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,azpijr@gmail.com,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch removed from -mm tree
Message-Id: <20261024090110.EAD321F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: fix uffd move-pmd test crash on 64K base page systems
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: fix uffd move-pmd test crash on 64K base page systems
Date: Mon, 12 Oct 2026 00:35:27 +0800

uffd_move_pmd_test()/uffd_move_test_common() splits the test area into
chunks of chunk_size and moves them one by one.  On arm64 with 64K base
pages the chunk_size (read_pmd_pagesize()) is 512MB, which is larger than
the whole 32MB (UFFD_TEST_MEM_SIZE) test area:

  step_count = nr_pages / (chunk_size / page_size) == 0

Because chunk_size > page_size, the test then aligns both areas up to
512MB, which points far outside of the 32MB mappings, and decrements
step_count, which underflows to ULONG_MAX.  The verification loop then
runs away and the first dereference of area_src faults with a SIGSEGV.

Skip the test when a single chunk cannot fit into the test area.

Link: https://lore.kernel.org/20261011163527.95988-1-zenghui.yu@linux.dev
Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-uffd-move-pmd-test-crash-on-64k-base-page-systems
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1937,6 +1937,11 @@ uffd_move_test_common(uffd_global_test_o
 
 	args.gopts = gopts;
 
+	if (chunk_size > gopts->nr_pages * gopts->page_size) {
+		uffd_test_skip("chunk size does not fit in the test area");
+		return;
+	}
+
 	/* Prevent source pages from being mapped more than once */
 	if (madvise(gopts->area_src, gopts->nr_pages * gopts->page_size, MADV_DONTFORK))
 		err("madvise(MADV_DONTFORK) failure");
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

mm-page_alloc-mark-pages-freed-by-__free_pages_core-as-not-tagged.patch

