Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372264;
	b=KAs5HOvdIpp28umyxY/38l9ukw7X/jyl007Z0dJw/+E5zJDpQjJu3DwfwEbXKnO5chOo
	 4kuYfguo6rhbEggAng1oTvFjyRqGGlOvy5ncakdx3nDBiif2auFhoTNTDnwymMsILKQ55
	 n6Hmj1gTvMBYaaMyAY6049fkieoKutjUgncXQG0OzIc+2hSW8q1rbDduDyU11M7bP6sCi
	 VC3rDyLM3O5biXStvsYqmMWtDxYkmZvo29gsP/ItbFssgA0NgHAcBvqX86gnrhugqLE2O
	 YPtW4HpmpEWa4QJQCMkl1XOdZvasmV+djXROcPNmw0UHitxZkgncHlgdDhE4AQmk5VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372264;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=z4bP0b3TpDtW1i+VB44tdlR6w3ZI69QmeoDiJliqOFE=;
	b=mTS/hjzks3N5YNKE7YlYi+jx72TZn/+HAfomk0pXE25tiF08UnIsjmM1Q5cbmjYh0aHH
	 +H4nKHWzEkUsnZQk91f9j8OQ9SnBGtvt/3zn8TO3B8YMkgXDJ/m5Jhd9B+nKZf1XC+CV/
	 QK7iPHNCW+sxMIQLgJP/+p0+O66TEgKF92P90Cm3MmSpZnnSHbSfYBqpfVK2XpAEXcteJ
	 qhVlLEQndQKqFYiLHcDHiStnYRvQn75fRwfny7cH8F5wCZLZ/mR2MLgCDa5WWex5PbGjp
	 4xiJWveKRYQPzWNhqRg3/NVUA3R0I9jTbMhi9l/9911oe7JwerrzKXwZCWbC/g9hvCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WzOcwAsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E4A606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WzOcwAsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70D31F000C1;
	Fri, 30 Oct 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793372264;
	bh=z4bP0b3TpDtW1i+VB44tdlR6w3ZI69QmeoDiJliqOFE=;
	h=Date:To:From:Subject;
	b=WzOcwAsMJEFHN5AaGiO6sXoHBfzpN40q9/E3uVbaNYpAMccaHG2vWM+rnK1mmwnO5
	 18kfx3f97tcNrt90qOhloxVwqRZLdvkt61if8jEYAiMt2TikMd4TSnJoAGnW2prJFi
	 i+7uwIrs3OIZSxm7voK5/5Ci7rHgy3xPIOZQDKeg=
Date: Fri, 30 Oct 2026 07:57:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch added to mm-new branch
Message-Id: <20261030145743.E70D31F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps.patch

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
Subject: selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
Date: Mon, 19 Oct 2026 13:12:04 -0400

Check that paging out a whole PMD-mapped THP swaps it without corrupting
it, and that pages outside the range stay mapped after paging out a base
page or half of a PMD- or PTE-mapped THP.

Also check that MADV_COLD on half of either THP preserves its contents.

Tests skip when PMD-sized THPs cannot be allocated, and the MADV_PAGEOUT
tests also when MADV_PAGEOUT cannot swap. With /proc/kpageflags the
PTE-mapped cases also confirm that PTE-mapping left the folio large.

Link: https://lore.kernel.org/20261019171206.3331374-6-gourry@gourry.net
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

 tools/testing/selftests/mm/madv_cold_pageout.c |  238 +++++++++++++++
 1 file changed, 238 insertions(+)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -8,6 +8,7 @@
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
+#include <string.h>
 #include <sys/ipc.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
@@ -17,10 +18,15 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 /* Reclaim can fail transiently, so retry for up to a second. */
 #define PAGEOUT_RETRIES 100
 
 static size_t page_size;
+static size_t pmd_size;
 /* Whether MADV_PAGEOUT can swap out anonymous memory, see main(). */
 static bool can_swap;
 
@@ -92,6 +98,111 @@ FIXTURE_TEARDOWN(madv_cold_pageout)
 	close(self->pagemap_fd);
 }
 
+/*
+ * Reserve a PMD-aligned range, so that memory mapped over it with MAP_FIXED
+ * can be backed by PMD-mapped THPs.
+ */
+static char *reserve_aligned(struct __test_metadata *_metadata, size_t size)
+{
+	char *reservation, *aligned;
+
+	reservation = mmap(NULL, size + pmd_size, PROT_NONE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(reservation, MAP_FAILED);
+
+	aligned = (char *)(((uintptr_t)reservation + pmd_size - 1) &
+			   ~(pmd_size - 1));
+	if (aligned != reservation)
+		ASSERT_EQ(munmap(reservation, aligned - reservation), 0);
+	ASSERT_EQ(munmap(aligned + size, reservation + pmd_size - aligned), 0);
+
+	return aligned;
+}
+
+/* Map PMD-aligned anonymous memory filled with 1s. */
+static char *map_aligned_pages(struct __test_metadata *_metadata, size_t size)
+{
+	char *mapping = reserve_aligned(_metadata, size);
+
+	ASSERT_EQ(mmap(mapping, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0),
+		  mapping);
+	memset(mapping, 1, size);
+
+	return mapping;
+}
+
+/*
+ * Collapse a PMD-aligned range into PMD-mapped THPs, and confirm the result
+ * with check_huge(). MADV_COLLAPSE may fail transiently with EAGAIN.
+ */
+static bool collapse(char *mapping, size_t size,
+		     bool (*check_huge)(void *, size_t, int, uint64_t))
+{
+	int nr_hpages = size / pmd_size;
+	int retry;
+
+	for (retry = 0; retry < 10; retry++) {
+		if (madvise(mapping, size, MADV_COLLAPSE)) {
+			if (errno != EAGAIN)
+				return false;
+		} else if (check_huge(mapping, size, nr_hpages, pmd_size)) {
+			return true;
+		}
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/* Map a PMD-mapped anonymous THP filled with 1s, or return NULL. */
+static char *map_thp(struct __test_metadata *_metadata)
+{
+	char *mapping;
+
+	if (!pmd_size)
+		return NULL;
+	mapping = map_aligned_pages(_metadata, pmd_size);
+	if (collapse(mapping, pmd_size, check_huge_anon))
+		return mapping;
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+	return NULL;
+}
+
+/*
+ * Changing the protection of one page PTE-maps a THP. When /proc/kpageflags
+ * is readable, also check that the folio is still large.
+ */
+static void pte_map_thp(struct __test_metadata *_metadata, char *mapping,
+			int pagemap_fd, int kpageflags_fd)
+{
+	unsigned long pfn;
+	uint64_t flags;
+
+	ASSERT_EQ(mprotect(mapping + page_size, page_size, PROT_READ), 0);
+	ASSERT_EQ(mprotect(mapping + page_size, page_size,
+			   PROT_READ | PROT_WRITE), 0);
+	ASSERT_TRUE(check_huge_anon(mapping, pmd_size, 0, pmd_size));
+	if (kpageflags_fd < 0)
+		return;
+
+	pfn = pagemap_get_pfn(pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, kpageflags_fd, &flags), 0);
+	ASSERT_TRUE(flags & KPF_COMPOUND_HEAD);
+}
+
+static void assert_filled(struct __test_metadata *_metadata,
+			  const char *mapping, size_t size)
+{
+	size_t offset;
+
+	for (offset = 0; offset < size; offset += page_size) {
+		ASSERT_EQ(mapping[offset], 1)
+			TH_LOG("memory changed at offset %zu", offset);
+	}
+}
+
 /* Page out the range until its first page is swapped, or madvise() fails. */
 static bool pageout_until_swapped(char *mapping, size_t size, int pagemap_fd)
 {
@@ -124,6 +235,11 @@ static bool pageout_until_unmapped(char
 	return false;
 }
 
+static bool page_is_present(int pagemap_fd, char *addr)
+{
+	return pagemap_get_entry(pagemap_fd, addr) & PM_PRESENT;
+}
+
 /* Create an unlinked, zero-filled temporary file, or return -1. */
 static int create_temp_file(size_t size)
 {
@@ -452,6 +568,127 @@ TEST_F(madv_cold_pageout, pageout_skips_
 	ASSERT_EQ(shmdt(mapping), 0);
 }
 
+/* MADV_PAGEOUT of a whole THP must swap it without corrupting it. */
+TEST_F(madv_cold_pageout, pageout_swaps_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, pmd_size, self->pagemap_fd));
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT must not reclaim pages outside the advised range. kswapd or
+ * page migration could also unmap them, but neither should happen when the
+ * selftests run by themselves.
+ */
+TEST_F(madv_cold_pageout, pageout_stays_within_range)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	memset(mapping, 1, 3 * page_size);
+	ASSERT_TRUE(pageout_until_swapped(mapping + page_size, page_size,
+					  self->pagemap_fd));
+
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping));
+	ASSERT_TRUE(page_is_present(self->pagemap_fd, mapping + 2 * page_size));
+	assert_filled(_metadata, mapping, 3 * page_size);
+
+	ASSERT_EQ(munmap(mapping, 3 * page_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT of half of a THP must split it, and reclaim only the advised
+ * half. See pageout_stays_within_range about other unmapping.
+ */
+static void pageout_half_thp(struct __test_metadata *_metadata, char *mapping,
+			     int pagemap_fd)
+{
+	size_t offset;
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, pmd_size / 2, pagemap_fd));
+
+	for (offset = pmd_size / 2; offset < pmd_size; offset += page_size) {
+		ASSERT_TRUE(page_is_present(pagemap_fd, mapping + offset))
+			TH_LOG("page at offset %zu was unmapped", offset);
+	}
+	assert_filled(_metadata, mapping, pmd_size);
+}
+
+TEST_F(madv_cold_pageout, pageout_stays_within_pmd_mapped_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madv_cold_pageout, pageout_stays_within_pte_mapped_thp)
+{
+	char *mapping;
+
+	if (!can_swap)
+		SKIP(return, "MADV_PAGEOUT cannot swap");
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	pageout_half_thp(_metadata, mapping, self->pagemap_fd);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+/* MADV_COLD on part of a THP may split it, but must not change it. */
+TEST_F(madv_cold_pageout, cold_preserves_half_of_pmd_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
+TEST_F(madv_cold_pageout, cold_preserves_half_of_pte_mapped_thp)
+{
+	char *mapping;
+
+	mapping = map_thp(_metadata);
+	if (!mapping)
+		SKIP(return, "could not allocate a PMD-sized THP");
+	pte_map_thp(_metadata, mapping, self->pagemap_fd, self->kpageflags_fd);
+
+	ASSERT_EQ(madvise(mapping, pmd_size / 2, MADV_COLD), 0);
+	assert_filled(_metadata, mapping, pmd_size);
+
+	ASSERT_EQ(munmap(mapping, pmd_size), 0);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
@@ -474,6 +711,7 @@ int main(int argc, char **argv)
 	int pagemap_fd;
 
 	page_size = getpagesize();
+	pmd_size = read_pmd_pagesize();
 	/* The harness forks each test, which inherits this. */
 	pin_to_current_cpu();
 	/* Only root can reserve the page that hugetlb_vma_is_rejected maps. */
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

