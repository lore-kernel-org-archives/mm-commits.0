Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755423;
	b=c951YNKMfzIGEItbbpTxNKxy9UWIZogvtITg4GkKAYnTCH93UdNtwTJqHSHdB+ZtVefd
	 AohWtf8m7EcQHoAV0n2ldo+Phx/p/E4CcxBTWDPf7FG04I4JVcrqmd+jxisIqifkoOWph
	 6jmcHt7sF9DACreIO1Cd5Y07gkGlQ7OKFE91gVKDue5uwrgB4a6ebEFKD4TRAWB0vD/Tj
	 j5s3ZvkD/9vRBMZuAQv5/PKMSbDeCvmr4R0izxnp8uOP6URcSa3JC72Ks2hNu4L1ghSYf
	 wGL/2VWyd22O2Ur4nebkKbd5De6IV+GmC9WYbB+CB+rKzDYdsQHszxRCcoViI4iecBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755423;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XGJEyi4KPPOX4vlrrloG0GkXUqkByULrYCbrh7L8J20=;
	b=5gelMq4G801hiiwXSJiP1h0Xe8L27rFYGH4JNuCM913DXxkiRqEHJxuyq1wxKwTVA6BH
	 LnNTEWjwafPXpPuAlZlltXvindeoBL3NehFEUhucWVx12QSXFOgQryMwols1UiwhO2Hoy
	 l8C00JEIn7Y29h13iw3R1JWbipPxbwetWgA0Z8SiJwRKWVeJnYTK0yayS3g84Uf/ytn68
	 r5tfd4+gb802ZKX+MjRzUq979XHIFGfnVSk04w6tjckpIeCdjT4nzCFuqo6AhG7qk2urr
	 qHyPeewfSlaAP2YAn/C0fDShy1ABF4Wou1hJjuvk1Spx1E50OkO5lzQtNeKZk8ga3OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iMqpeicG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF59606A31B
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 01:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iMqpeicG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57451F00919;
	Wed,  4 Nov 2026 01:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793755422;
	bh=XGJEyi4KPPOX4vlrrloG0GkXUqkByULrYCbrh7L8J20=;
	h=Date:To:From:Subject;
	b=iMqpeicGhzem0IrV3o89T06QTzN8hHX9Eq+OIgPrIUtesKg5iQoVdHcvQv2dX7ft7
	 RZ1RdXWwkUfGFBTfT74u1IDOvnbwMxrWVy/BdbbZDR5frKyU6gsf0yRSQRr6vaMpGC
	 PnIwopFGttfrRFfVMUCxmOL90FdVO/QWyt3WbQUY=
Date: Tue, 03 Nov 2026 17:23:42 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,leon@kernel.org,jgg@ziepe.ca,
	david@kernel.org,akpm@linux-foundation.org,sashal@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch added to mm-new branch
Message-Id: <20261104012342.A57451F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: fix pointer width warnings on 32-bit architectures
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch

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
Subject: selftests/mm: fix pointer width warnings on 32-bit architectures
Date: Tue,  3 Nov 2026 16:28:05 -0500

Several mm tests convert between pointers and 64-bit integers with a
plain cast, which warns on 32-bit architectures, and hugetlb-mremap
passes 47-bit mmap() hints that don't fit in an unsigned long:

  uffd-unit-tests.c:344:31: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Add ptr_to_u64() and u64_to_ptr() to vm_util.h, which cast through
uintptr_t, and use them where pointers meet the 64-bit UAPI fields and
the 64-bit address arithmetic in mremap_test. The hugetlb-mremap hints
don't fit in a 32-bit address space, so only pass them when long is 64
bits.

Link: https://lore.kernel.org/20261103212805.1537354-1-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
  Link: https://lore.kernel.org/20261103172150.3753dfa00f3106b6014e4d2c@linux-foundation.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
---

 tools/testing/selftests/mm/hmm-tests.c       |    4 -
 tools/testing/selftests/mm/hugetlb-mremap.c  |   17 +++---
 tools/testing/selftests/mm/migration.c       |    4 -
 tools/testing/selftests/mm/mremap_test.c     |   13 ++--
 tools/testing/selftests/mm/uffd-common.c     |    2 
 tools/testing/selftests/mm/uffd-unit-tests.c |   48 ++++++++---------
 tools/testing/selftests/mm/vm_util.h         |   10 +++
 7 files changed, 57 insertions(+), 41 deletions(-)

--- a/tools/testing/selftests/mm/hmm-tests.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/hmm-tests.c
@@ -196,8 +196,8 @@ static int hmm_dmirror_cmd(int fd,
 	int ret;
 
 	/* Simulate a device reading system memory. */
-	cmd.addr = (__u64)buffer->ptr;
-	cmd.ptr = (__u64)buffer->mirror;
+	cmd.addr = ptr_to_u64(buffer->ptr);
+	cmd.ptr = ptr_to_u64(buffer->mirror);
 	cmd.npages = npages;
 
 	for (;;) {
--- a/tools/testing/selftests/mm/hugetlb-mremap.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -33,6 +33,11 @@
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_HUGETLB | MAP_SHARED)
 
+static void *addr_hint(unsigned long long addr)
+{
+	return sizeof(long) == 8 ? u64_to_ptr(addr) : NULL;
+}
+
 static void check_bytes(char *addr)
 {
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
@@ -130,21 +135,21 @@ int main(int argc, char *argv[])
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
-	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *haddr = mmap(addr_hint(0x7eaa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
-	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *daddr = mmap(addr_hint(0x7daa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
-	suggested_addr = 0x7faa40000000;
-	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *vaddr = mmap(addr_hint(0x7faa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
--- a/tools/testing/selftests/mm/migration.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/migration.c
@@ -236,7 +236,7 @@ TEST_F_TIMEOUT(migration, private_anon_t
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ptr = u64_to_ptr(ALIGN((uintptr_t) ptr, pmdsize));
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i < self->nthreads; i++)
@@ -270,7 +270,7 @@ TEST_F_TIMEOUT(migration, shared_anon_th
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ptr = u64_to_ptr(ALIGN((uintptr_t) ptr, pmdsize));
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
 	memset(ptr, 0xde, pmdsize);
--- a/tools/testing/selftests/mm/mremap_test.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/mremap_test.c
@@ -17,6 +17,7 @@
 #include <stdbool.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 #define EXPECT_SUCCESS 0
 #define EXPECT_FAILURE 1
@@ -190,7 +191,7 @@ retry:
 	if (addr < mmap_min_addr)
 		goto retry;
 
-	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
+	src_addr = mmap(u64_to_ptr(addr), c.region_size, PROT_READ | PROT_WRITE,
 					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
 					-1, 0);
 	if (src_addr == MAP_FAILED) {
@@ -206,8 +207,8 @@ retry:
 	 * requested alignment of 2MB. This is done to reduce coincidental
 	 * alignment in the tests.
 	 */
-	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment)) {
+	if ((ptr_to_u64(src_addr) & (c.src_alignment - 1)) ||
+			!(ptr_to_u64(src_addr) & c.src_alignment)) {
 		munmap(src_addr, c.region_size);
 		goto retry;
 	}
@@ -996,15 +997,15 @@ static long long remap_region(struct con
 	align_mask = ~(c.dest_alignment - 1);
 	/* Offset of destination address from the end of the source region */
 	offset = (c.overlapping) ? -c.dest_alignment : c.dest_alignment;
-	addr = (void *) (((unsigned long long) src_addr + c.region_size
+	addr = u64_to_ptr((ptr_to_u64(src_addr) + c.region_size
 			  + offset) & align_mask);
 
 	/* Remap after the destination block preamble. */
 	addr += c.dest_preamble_size;
 
 	/* See comment in get_source_mapping() */
-	if (!((unsigned long long) addr & c.dest_alignment))
-		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
+	if (!(ptr_to_u64(addr) & c.dest_alignment))
+		addr = u64_to_ptr(ptr_to_u64(addr) | c.dest_alignment);
 
 	/* Don't destroy existing mappings unless expected to overlap. */
 	while (!is_remap_region_valid(addr - c.dest_preamble_size,
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -488,7 +488,7 @@ void uffd_handle_page_fault(uffd_global_
 		 */
 
 		area = (uint8_t *)(gopts->area_dst +
-		       ((char *)msg->arg.pagefault.address -
+		       ((char *)u64_to_ptr(msg->arg.pagefault.address) -
 		       gopts->area_dst_alias));
 		for (b = 0; b < gopts->page_size; ++b)
 			area[b] = ~area[b];
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -341,17 +341,17 @@ static void uffd_wp_unpopulated_test(uff
 	pagemap_fd = pagemap_open();
 
 	/* Test applying pte marker to anon unpopulated */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, true);
 
 	/* Test unprotect on anon pte marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, false);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, false);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, false);
 
 	/* Test zap on anon marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	if (madvise(gopts->area_dst, gopts->page_size, MADV_DONTNEED))
 		err("madvise(MADV_DONTNEED) failed");
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
@@ -366,7 +366,7 @@ static void uffd_wp_unpopulated_test(uff
 		err("madvise(MADV_DONTNEED) failed");
 
 	/* Test read-zero-page upon pte marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	*(volatile char *)gopts->area_dst;
 	/* Drop it to make pte none again */
 	if (madvise(gopts->area_dst, gopts->page_size, MADV_DONTNEED))
@@ -389,7 +389,7 @@ static void uffd_wp_fork_test_common(uff
 
 	/* Touch the page */
 	*gopts->area_dst = 1;
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, true);
 	if (pagemap_test_fork(gopts, with_event, false)) {
@@ -430,7 +430,7 @@ static void uffd_wp_fork_test_common(uff
 	}
 
 	/* Unprotect; this tests swap pte modifications */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, false);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, false);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, false);
 
@@ -469,7 +469,7 @@ static void uffd_wp_fork_pin_test_common
 
 	/* Touch the page */
 	*gopts->area_dst = 1;
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 
 	/*
 	 * 1. First pin, then fork().  This tests fork() special path when
@@ -675,7 +675,7 @@ static void uffd_rwp_async_test(uffd_glo
 		err("register failure");
 
 	/* RW-protect all pages (sets protnone) */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Access all pages — should auto-resolve, no faults */
@@ -739,7 +739,7 @@ static void uffd_rwp_sync_test(uffd_glob
 		err("register failure");
 
 	/* RW-protect all pages */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Start fault handler thread */
@@ -816,7 +816,7 @@ static void uffd_rwp_pagemap_test(uffd_g
 			  nr_pages * page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Touch first half of pages to re-activate them (async auto-resolve) */
@@ -825,7 +825,7 @@ static void uffd_rwp_pagemap_test(uffd_g
 		(void)*page;
 	}
 
-	uint64_t start = (uint64_t)gopts->area_dst;
+	uint64_t start = ptr_to_u64(gopts->area_dst);
 	uint64_t boundary = start + (nr_pages / 2) * page_size;
 	uint64_t end = start + nr_pages * page_size;
 
@@ -844,7 +844,7 @@ static void uffd_rwp_pagemap_test(uffd_g
 	pm_arg.size = sizeof(pm_arg);
 	pm_arg.start = start;
 	pm_arg.end = end;
-	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec = ptr_to_u64(regions);
 	pm_arg.vec_len = ARRAY_SIZE(regions);
 	pm_arg.category_mask = PAGE_IS_ACCESSED;
 	pm_arg.return_mask = PAGE_IS_ACCESSED;
@@ -897,7 +897,7 @@ static void uffd_rwp_mprotect_test(uffd_
 	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
 			      nr_pages * page_size))
 		err("register failure");
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			nr_pages * page_size, true);
 
 	/* Round-trip mprotect(): PROT_NONE -> PROT_READ|PROT_WRITE */
@@ -937,9 +937,9 @@ static void uffd_rwp_mprotect_test(uffd_
 
 	memset(&pm_arg, 0, sizeof(pm_arg));
 	pm_arg.size = sizeof(pm_arg);
-	pm_arg.start = (uint64_t)gopts->area_dst;
-	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
-	pm_arg.vec = (uint64_t)regions;
+	pm_arg.start = ptr_to_u64(gopts->area_dst);
+	pm_arg.end = ptr_to_u64(gopts->area_dst) + nr_pages * page_size;
+	pm_arg.vec = ptr_to_u64(regions);
 	pm_arg.vec_len = ARRAY_SIZE(regions);
 	pm_arg.category_mask = PAGE_IS_ACCESSED;
 	pm_arg.category_inverted = PAGE_IS_ACCESSED;
@@ -982,7 +982,7 @@ static void uffd_rwp_gup_test(uffd_globa
 	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, gopts->page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			gopts->page_size, true);
 
 	if (pipe(pipefd))
@@ -1045,7 +1045,7 @@ static void uffd_rwp_async_toggle_test(u
 		err("register failure");
 
 	/* Phase 1: async detection — RW-protect, access first half */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	for (p = 0; p < nr_pages / 2; p++) {
@@ -1092,7 +1092,7 @@ static void uffd_rwp_async_toggle_test(u
 	set_async_mode(gopts->uffd, true);
 
 	/* RW-protect and access again — should auto-resolve */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	for (p = 0; p < nr_pages; p++) {
@@ -1127,7 +1127,7 @@ static void uffd_rwp_close_test(uffd_glo
 			  nr_pages * page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Close uffd — should restore protnone PTEs */
@@ -1169,7 +1169,7 @@ static void uffd_rwp_fork_test(uffd_glob
 
 	/* Populate + RWP-protect */
 	*gopts->area_dst = 1;
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			page_size, true);
 
 	/* Parent: verify uffd-wp bit is set before fork */
@@ -1223,7 +1223,7 @@ static void uffd_rwp_fork_pin_test(uffd_
 	}
 
 	/* RWP-protect: PTE is now PAGE_NONE + uffd bit. */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst), page_size, true);
 
 	pagemap_fd = pagemap_open();
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
@@ -1332,7 +1332,7 @@ static void uffd_rwp_swap_cow_test(uffd_
 	*gopts->area_dst = 0x11;
 
 	/* RWP-protect: PTE becomes PAGE_NONE + uffd bit (still exclusive). */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst), page_size, true);
 
 	/*
 	 * Swap the page out while it is still exclusive: a shared (forked)
@@ -1498,7 +1498,7 @@ static int faulting_process(uffd_global_
 						/* This is a WP request */
 						assert(steps == 2);
 						wp_range(gopts->uffd,
-							 (__u64)gopts->area_dst +
+							 ptr_to_u64(gopts->area_dst) +
 							 offset,
 							 gopts->page_size, false);
 					}
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -62,6 +62,16 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline uint64_t ptr_to_u64(const void *ptr)
+{
+	return (uintptr_t)ptr;
+}
+
+static inline void *u64_to_ptr(uint64_t val)
+{
+	return (void *)(uintptr_t)val;
+}
+
 static inline void force_read_pages(char *addr, unsigned int nr_pages,
 				    size_t pagesize)
 {
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch

