Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793849867;
	b=m0c5ela0jDYfxEoaDPrbuPB/EF72nKXDR1XjQ/rJrRP+s/JLhmTfeUT1p6VTv8Dj6SM2
	 KlyE1QAGk89paRZERtXeweRDY5CbM9T0HNEAzhT3B0s12sVtikZLZxjAsx48mvxrrOrGb
	 qIMG1zRViUPiQn3jVf3+GX2YY6ir0VEixsGegXoPgP9dTSMIoOXErxf9eQ38xyYB6Tch7
	 I6Dvgnqmvum3M2vq2XyXNUCK9AcZM1Ehz0zZ2f9sMaH3ES0Dt5QpuJ3iwOuvT0wMhmxIy
	 xlujAfTCYlxvFGbfpRRM+mVwwyJ2IFPemLhVZoMn910rYhrMEc0LLFhyauLxUO/ZR/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793849867;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=+KZnt+f2oqpJPZc0tZvtGJKRpbyVhyLAHw1OzXj/ej8=;
	b=kvthxo7Y32GM93zpI9oDOukeZJI6+NZGov7OIbOzbYrLGnYYhyW0iwecfmSDoGJQesXh
	 vEPbVeBVHNhxAUJ/iwGlhDua97jCelC92j0e1COYLRCMe+/3ltD3ItbIEPsoOQN+ddVtt
	 WrlyrfxG8xOZBo8yUEQb7+o4kbFCxBGHVvbhsrFpWat6jDLbB1i5+M2R1Ai228CDqtC7K
	 Vu6qRXa0pMO4o/R8LvcdrGCIYXhGasEWKOZNOk1EvC/7GcR9lzun65swyQJjASoXH0FWT
	 t8rukYKVKEbixMQSvuBZFzc/sUe1y/3Et+vQu7+kRVgqYAsOS3khcDyijilxHm0Cycg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w4CUlKUi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B293606A331
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w4CUlKUi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13B51F00919;
	Thu,  5 Nov 2026 03:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793849867;
	bh=+KZnt+f2oqpJPZc0tZvtGJKRpbyVhyLAHw1OzXj/ej8=;
	h=Date:To:From:Subject;
	b=w4CUlKUi6o/WxoWtSXkesbuAGGHE20rAEguoaxjBlcT2z5UhYp/KUmuwfKcZLI8fR
	 eqlBYi7WwrEUGlqVmlNfcyJnYMRepPuLm6ApsUW5kMWgS4QtC0ObHb22a0EgfAyY6B
	 D5RrxM3ChCu1zO8ymJTw0qxT2bUHQ4swFa0L22pE=
Date: Wed, 04 Nov 2026 19:37:46 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	shuah@kernel.org,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,
	liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,dev.jain@arm.com,
	david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,
	sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch added to mm-new branch
Message-Id: <20261105033746.E13B51F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: skip split_huge_page_test without the split_huge_pages file
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch

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
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/mm: skip split_huge_page_test without the split_huge_pages file
Date: Wed,  4 Nov 2026 22:02:42 -0500

Every case in split_huge_page_test goes through
/sys/kernel/debug/split_huge_pages.  When that file does not exist,
because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
first write bails out of the whole test and it is reported as a failure:

  Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory

Skip the test in that case.

Link: https://lore.kernel.org/20261105030242.1241448-1-sashal@kernel.org
Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/split_huge_page_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/split_huge_page_test.c~selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file
+++ a/tools/testing/selftests/mm/split_huge_page_test.c
@@ -610,6 +610,9 @@ int main(int argc, char **argv)
 	if (!thp_is_enabled())
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
+	if (access(SPLIT_DEBUGFS, W_OK))
+		ksft_exit_skip("%s: %s\n", SPLIT_DEBUGFS, strerror(errno));
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
selftests-mm-skip-split_huge_page_test-without-the-split_huge_pages-file.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

