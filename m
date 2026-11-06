Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928461;
	b=SxNraOMvUF8+mpGtgi/xNmT5rluda92M8x9e7u92Ldm+OXOEdK163CHJzuPg/uVFP4b2
	 h4JuAOe4jFEHjVK6EGzcR1RZBlF001qr92bsDGtZW1Go3WR46BzNGV3h5/1I6+YNxqwYG
	 rbv/cCo/ArNv5SsD3EU8huVeY+wsf29U85Vjkn1c27pHIT3Gmmht3HtnB6O9oDUy9UIsS
	 wplSP/3P2QToTF/J31CChE9XlaTMDvFf/1DxDPAP8yloPA87jsLnSyyHxFfkWnglIQthR
	 SmEQl66Smo+Ae0sHmTpuOzOHOPLoVymftgN8f9eQXYRLeO1aJAjJ535VC+FbQRjTVwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928461;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=UA4I2C0IDBZc2AhFEnRCyrcOhMleqA17fWTumlqO104=;
	b=qgTXjGi8lbOzdKqZ0gcFjJJxJuiXZyV18xwaCCbQ4AFAIccpmy5QJDN25Cq2+m97RL+R
	 7nCRa6VFUVNGWFSEqTg1C4R3QSH49VLq38cghNDKyc6ebkgxBR4/FfdGe7tYF16i9yWsg
	 b3qeCedRprCQdRNwxrYqBhEljlQiXd76vDAVAxltXx/YiUM9yOgRoNxGL/pqnCaeWWRr3
	 IvGMDzYbQqW31uMu7lzlM5dQqtntgdRElKWKNfjjHvvY1SgjxuWWZkLKEYCZlxz9f+fa7
	 P8AF8z1yK7qpg6vrBXdL2b0ONAgB6MpfhgU0lElibiIpkp0lYTwlQqs9VpQNHowDjHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AEnBv9Ly;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7476606A31B
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=AEnBv9Ly
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ADE1F0089F;
	Fri,  6 Nov 2026 01:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928460;
	bh=UA4I2C0IDBZc2AhFEnRCyrcOhMleqA17fWTumlqO104=;
	h=Date:To:From:Subject;
	b=AEnBv9LyNKEFPbFnP0bBU/oKs3N2yen/gMotxTm+KDRI1XwBTBgdz4GKgH4NLnfXy
	 pRVM8q0cvoGfIrJ8WVpZd8TO+JTPv9mLr7hw7AaS6HrJJf5eMPMS7K4a0cGMzRLEcP
	 ZidUzf09T5kGPDxSNRcjnTtSD+oJjgiZV71BHTxM=
Date: Thu, 05 Nov 2026 17:27:40 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sarthak.sharma@arm.com,
	pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,
	liam@infradead.org,jannh@google.com,david@kernel.org,azpijr@gmail.com,
	josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-mremap-with-an-old-size-of-0.patch added to mm-new branch
Message-Id: <20261106012740.84ADE1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: test mremap() with an old size of 0
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-test-mremap-with-an-old-size-of-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-mremap-with-an-old-size-of-0.patch

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
From: Josef Bacik <josef@toxicpanda.com>
Subject: selftests/mm: test mremap() with an old size of 0
Date: Thu, 05 Nov 2026 14:02:07 +0000

mremap() with an old size of 0 duplicates a shared mapping, and
mremap_test has no case for it.

Duplicate a shared anonymous mapping, once from its start and once from
the middle.  Check that the source and the duplicate are mapped by one VMA
each and that they show the same pages.

Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-5-f8789de76849@toxicpanda.com
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>
---

 tools/testing/selftests/mm/mremap_test.c |   51 ++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-test-mremap-with-an-old-size-of-0
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -604,6 +604,53 @@ out:
 				      inplace ? " [inplace]" : "");
 }
 
+/*
+ * An old size of 0 duplicates a shared mapping: the pages show up at a second
+ * address, and the mapping they were taken from stays as it is.
+ */
+static void mremap_duplicate_shared(FILE *maps_fp, unsigned long page_size,
+				    unsigned long offset)
+{
+	char *test_name = "mremap duplicate shared mapping";
+	const size_t size = 3 * page_size;
+	const size_t dup_size = size - offset;
+	char *dup = MAP_FAILED;
+	bool success = false;
+	char *ptr;
+
+	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_SHARED | MAP_ANON, -1, 0);
+	if (ptr == MAP_FAILED) {
+		ksft_perror("mmap");
+		goto out;
+	}
+	memset(ptr, 'a', size);
+
+	dup = mremap(ptr + offset, 0, dup_size, MREMAP_MAYMOVE);
+	if (dup == MAP_FAILED) {
+		ksft_perror("mremap");
+		goto out_unmap;
+	}
+
+	/* Both are mapped, each by a single VMA. */
+	if (!is_ptr_mapped(maps_fp, ptr, size) ||
+	    !is_ptr_mapped(maps_fp, dup, dup_size))
+		goto out_unmap;
+
+	/* They show the same pages. */
+	ptr[offset] = 'b';
+	dup[dup_size - 1] = 'c';
+	success = dup[0] == 'b' && ptr[size - 1] == 'c' && ptr[0] != 'c';
+
+out_unmap:
+	if (dup != MAP_FAILED)
+		munmap(dup, dup_size);
+	munmap(ptr, size);
+out:
+	ksft_test_result(success, "%s%s\n", test_name,
+			 offset ? " [from the middle]" : "");
+}
+
 static void mremap_move_multiple_vmas_split(unsigned int pattern_seed,
 					    unsigned long page_size,
 					    bool dont_unmap)
@@ -1249,7 +1296,7 @@ int main(int argc, char **argv)
 	char *rand_addr;
 	size_t rand_size;
 	int num_expand_tests = 2;
-	int num_misc_tests = 9;
+	int num_misc_tests = 11;
 	struct test test_cases[MAX_TEST] = {};
 	struct test perf_test_cases[MAX_PERF_TEST];
 	int page_size;
@@ -1386,6 +1433,8 @@ int main(int argc, char **argv)
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ false);
 	mremap_move_multiple_vmas_split(pattern_seed, page_size, /* dontunmap= */ true);
 	mremap_move_multi_invalid_vmas(maps_fp, page_size);
+	mremap_duplicate_shared(maps_fp, page_size, 0);
+	mremap_duplicate_shared(maps_fp, page_size, page_size);
 
 	fclose(maps_fp);
 
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-zswap-drop-the-stale-zswap-entry-of-a-zero-folio.patch
mm-swap-account-synchronous-swap-reads-as-memory-stall.patch
mm-mremap-fix-hugetlb-reservation-leak-on-partial-move.patch
selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch
mm-mremap-reaccount-on-unmap-failure-only-if-accounted.patch
mm-mremap-restore-vma_account_bit-if-the-unmap-fails.patch
selftests-mm-test-mremap-with-an-old-size-of-0.patch
zram-lz4-lz4hc-accept-dictionaries-of-more-than-64-kib.patch

