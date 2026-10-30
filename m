Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372260;
	b=j5+j7C9u5Kv721AbsxpDTW5amwRfl+hWj4AZ7MkgzgwjJICYnEvx0oKYk/ZqJ1y81J6k
	 hCmBCawepSNQDulv/CZJ9tTydSkL14mgypbwOh2Uh0sZGvOfCYH12fIuN5Tq4sy2p1pXV
	 ysEOY22xOCO0kUYmhTq1QErnGgBRlavafEaBTBWb1bfuwTu1PXvY96BxXK/qFekn81k2j
	 xayG6s2fmQjdgUYZN9X4gXFU1bPWkSZ6bWn+wM+NbpeoCgmMeJt6DcAwnWNKWK9iJxtCF
	 SNRlYkd3dLz2IUj4aDZ15S+oKNI9clPw3JjmQIhvvaO1g7nR/rL9nuiPQ2PR+yNfUPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372260;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BVY3EPzf3Uy8gF0c2FImzOB6TrZWlxF0/ecLYz9iARs=;
	b=rUj5WgyH4WcHAE4JLQvxQkzRu/YholUxNqmxoT1k0uzPmQZ4euBwqtps7aO7K0oqbosT
	 Ms9nqslFgv4/hS5WROJP9OgW0qSTp94RT8gX03FNQlhGtimJtk9vxwkJKyQk4C1qnTJm1
	 argOUHIj3MGKiWwd2VwV0TOoyiUjVwgj8U70AanX5xqiCDFOzS52z+gRV+CfJ2BKTtrZv
	 Iapjq5zzWw4+gNQpIpWHiGYbdhE/ImRVzc05IW8zQh/+6Fiwt96e9oZ/WmQXyuS5ThAjU
	 BnbG6P9fyd4lckRVa3UKD2X11IWRseaQF2XL/bVr+GBZU9jH6GfF2VvIlVoDCAjCF5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yLUyrnIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15282606A31E
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yLUyrnIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DC21F000C1;
	Fri, 30 Oct 2026 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793372259;
	bh=BVY3EPzf3Uy8gF0c2FImzOB6TrZWlxF0/ecLYz9iARs=;
	h=Date:To:From:Subject;
	b=yLUyrnIWEu9R7S6m1dfOL7fDal445mp66lB4m9mI3ZeHnrjtClrtSJa/xuxMHYorW
	 TE8pcO8YEaHzzs2HSWC9mIuiaFXgSTMs52cVjAY0ZGLmsOMvDTMLFLrI8NV4d7z1Au
	 +Aui/YA9rUI2WJJex5JKaCa3mhozkm+QBP4eMNlk=
Date: Fri, 30 Oct 2026 07:57:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch added to mm-new branch
Message-Id: <20261030145739.C6DC21F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch

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
From: "Gregory Price (Meta)" <gourry@gourry.net>
Subject: selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
Date: Mon, 19 Oct 2026 13:12:02 -0400

Neither hint may be applied to hugetlb memory, so madvise(2) must fail
with EINVAL for a hugetlb VMA. Locked VMAs are already checked here and
PFNMAP VMAs by the pfnmap test.

Check the hugetlb case for both hints. run_vmtests.sh does not reserve
hugetlb pages, so when run as root main() reserves the one page the test
needs, and restores the pool on exit. Otherwise the test skips if no
page is free.

Link: https://lore.kernel.org/20261019171206.3331374-4-gourry@gourry.net
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/madv_cold_pageout.c |   26 +++++++++++++++
 1 file changed, 26 insertions(+)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -141,6 +141,29 @@ TEST_F(madv_cold_pageout, locked_vma_is_
 	ASSERT_EQ(munmap(mapping, page_size), 0);
 }
 
+/* Neither hint may be applied to hugetlb memory. */
+TEST_F(madv_cold_pageout, hugetlb_vma_is_rejected)
+{
+	size_t size = default_huge_page_size();
+	char *mapping;
+
+	if (!size)
+		SKIP(return, "hugetlb is not supported");
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	if (mapping == MAP_FAILED)
+		SKIP(return, "no hugetlb pages are available");
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping, size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+}
+
 /* A zero-length range is accepted. */
 TEST_F(madv_cold_pageout, zero_length_is_accepted)
 {
@@ -276,6 +299,9 @@ int main(int argc, char **argv)
 	page_size = getpagesize();
 	/* The harness forks each test, which inherits this. */
 	pin_to_current_cpu();
+	/* Only root can reserve the page that hugetlb_vma_is_rejected maps. */
+	if (!geteuid())
+		hugetlb_setup_default(1);
 
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch
mm-memory-tiers-reset-demotion-targets-of-nodes-without-memory.patch
mm-mempolicy-convert-mempolicy-refcnt-to-refcount_t.patch
selftests-mm-add-madv_cold-and-madv_pageout-contract-tests.patch
selftests-mm-check-madv_cold-and-madv_pageout-range-handling.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-reject-hugetlb.patch
selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch
selftests-mm-check-madv_pageout-file-permissions.patch
selftests-mm-check-that-unauthorized-madv_pageout-skips-large-file-folios.patch

