Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928455;
	b=3gDdUlgRXJ0Dnw/Jmc9x60cyrENaOiCf6R2GTH1NCFEsn6ecxeGzyWOnOY0mfHs+7DBe
	 aEI+nh9wyiX09AUproJbv4IAeWCb25U+IPuZMiJePSfM1mEu+mXYjZ5UYc5Owp4Kf8l6A
	 2HDwKyPK1Eb0KWzKmF7CRkLENgj5clLkllDEvj+oMz+FME1lnbhvsImFiu7/UcYm2AjyO
	 nP/OpkOe1du6CtViCV91JJ5lHHFLLfguRhBa+P2yoZC8A6EOXb9RcIUslNPU1opydFTMQ
	 5sAa//tMm7wmHiEU+xMtnjv6p3FJMUYUOyIuoJ/5Y7Cvs5akEy+NCEiywygJTxg7+kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928455;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=NaqG/3AxA1nrwpZ+hKhOXwxGYPE1n+mhYAZPwMvmZxA=;
	b=buJiFHpEDIg0kLG0v/GEAHnnEjJSX4yBkMa3uhBSS6tZHDU6BNv4jXw3CdU/siOg7JtP
	 nz96eKOftOahVIZnomFWIHcbRzICSzGMz94RZ/NqBFhds1sZjgC+yurijQgLVO4if4atn
	 tOtJdE6UQP0AKJq7QzN6SRhQHrtHDfftm9hWnzxrQOv3dmLDV+SrqhR3KnNdNNXs8Edjm
	 z9lkUcGCPqIHD7SUslYxl/GT19r03v1xP+tpRtMbuPVwW0JZ/pajQ73QKOF2d1qqlEJ3f
	 fQ4ioQVTgl7ZclfoOKG8XubEB+Oc/yP5TJE+W7lTybVe/XEUN9EiX5tyBP5pA7yGkaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SwfHJK7Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515C2606A334
	for <mm-commits@vger.kernel.org>; Fri,  6 Nov 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SwfHJK7Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4191F008A1;
	Fri,  6 Nov 2026 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793928454;
	bh=NaqG/3AxA1nrwpZ+hKhOXwxGYPE1n+mhYAZPwMvmZxA=;
	h=Date:To:From:Subject;
	b=SwfHJK7ZDBZejgt3FeTnMoQoG78CtB4eXycvPig2DNaHmoLnkyiFvH7XBofDNeG7d
	 Z9fSo9WkuquwdqjAanTTUjMly4zjxdMaO3vliTCsLOQD31ALGf3G3mAF5SOQi7wHKH
	 2xX4PHsgnuUk7QM0s6zVlDtI6NdH8UksTwsoqNw0=
Date: Thu, 05 Nov 2026 17:27:34 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sarthak.sharma@arm.com,
	pfalcato@suse.de,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,
	liam@infradead.org,jannh@google.com,david@kernel.org,azpijr@gmail.com,
	josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch added to mm-new branch
Message-Id: <20261106012734.CE4191F008A1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: test a partial mremap() of hugetlb memory
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-test-a-partial-mremap-of-hugetlb-memory.patch

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
Subject: selftests/mm: test a partial mremap() of hugetlb memory
Date: Thu, 05 Nov 2026 14:02:04 +0000

hugetlb-mremap only moves whole mappings, so it did not catch the
reservation leak of a partial move.

Map four private huge pages without touching them, move the second one,
unmap everything, and check that the number of reserved huge pages is back
where it was.

Link: https://lore.kernel.org/20261105-b4-mremap-pre-split-v3-2-f8789de76849@toxicpanda.com
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

 tools/testing/selftests/mm/hugetlb-mremap.c |   52 +++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-mremap.c~selftests-mm-test-a-partial-mremap-of-hugetlb-memory
+++ a/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -100,6 +100,51 @@ static void register_region_with_uffd(ch
 	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
+/*
+ * Move one page out of the middle of a private mapping that has not been
+ * touched, so that every page of it still holds its reservation.  Once all of
+ * it is unmapped, all of the reservations have to be back in the pool.
+ */
+static void test_partial_move(unsigned long hugepage_size)
+{
+	const int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
+	const int prot = PROT_READ | PROT_WRITE;
+	const unsigned long nr = 4;
+	unsigned long resv = hugetlb_nr_resv_pages(hugepage_size);
+	unsigned long resv_after;
+	char *src, *dst, *addr;
+
+	/* The pages of the test before this one can still be in use. */
+	if (!hugetlb_setup_default(resv + nr + 1)) {
+		ksft_test_result_skip("Partial move: not enough free huge pages\n");
+		return;
+	}
+
+	src = mmap(NULL, nr * hugepage_size, prot, flags, -1, 0);
+	if (src == MAP_FAILED)
+		ksft_exit_fail_msg("mmap src: %s\n", strerror(errno));
+
+	/* The destination has to be hugetlb-backed, mremap() replaces it. */
+	dst = mmap(NULL, hugepage_size, prot, flags, -1, 0);
+	if (dst == MAP_FAILED)
+		ksft_exit_fail_msg("mmap dst: %s\n", strerror(errno));
+
+	addr = mremap(src + hugepage_size, hugepage_size, hugepage_size,
+		      MREMAP_MAYMOVE | MREMAP_FIXED, dst);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("partial mremap: %s\n", strerror(errno));
+
+	munmap(addr, hugepage_size);
+	munmap(src, nr * hugepage_size);
+
+	resv_after = hugetlb_nr_resv_pages(hugepage_size);
+	if (resv_after != resv)
+		ksft_print_msg("Reserved huge pages: %lu before, %lu after\n",
+			       resv, resv_after);
+	ksft_test_result(resv_after == resv,
+			 "Partial move returns all reservations\n");
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long hugepage_size;
@@ -107,7 +152,7 @@ int main(int argc, char *argv[])
 	size_t length = 0;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(2);
 
 	if (argc >= 2 && !strcmp(argv[1], "-h"))
 		ksft_exit_fail_msg("Usage: %s [length_in_MB]\n", argv[0]);
@@ -175,5 +220,8 @@ int main(int argc, char *argv[])
 	close(fd);
 
 	ksft_test_result(!ret, "Read same data\n");
-	ksft_exit(!ret);
+
+	test_partial_move(hugepage_size);
+
+	ksft_finished();
 }
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

