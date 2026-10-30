Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372262;
	b=5KRuElLQo+RIHiv4hzLIHkxZTGybZy2yGVZmrAiMKOxwptgfCZM6UuFvesFZur26OlWS
	 rOWJPLCLgFMyZpfeUaehfjcNEuArqPET90z0uPtuTfczQMJZWlqMJyI8O2HVoRyZLhBD+
	 ReTHsrnPB6rGCgayygknKQSdrNNc3DEZTZUbDHv3A4GdP3vDZyGm/PmU6tV/G6pT8zQE4
	 ScAc4Fnn3sTh4XyFz0UhgdlS/e1647W+mf/x62XB6lFmnPZtD3vq1W8AzkncguMl24Jaj
	 SxdUFVnFuTUeaHliZBeYyDK2Y8Dj9d/gddLzSqj5Y7PPmoKqvlYI3CM3qr7MVdAiVBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372262;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=qa4fScqHiR9xb7pIeq0LTdvDrk765v2lbbrgQNlzDE8=;
	b=Da0b6XFOyAgsriljCMwAd9qjUN0czFComl8YziGfgoAigi+QldYCMuWQz+BinzqyXbjC
	 ABP5PWJLY1lApI7KIqL30s8UOXKIAf2cIJJNI60Sn+Jk+rFMJ86HhVOYQE+Z7T6gGujfb
	 JmfZ2C7RT6m4e8DMOitf59QFWsaehCa0KgybWun443SJuSYEm49LQJ3gP/Nc+97fuUdaO
	 xJ5eeiw3pnqGmt7B1ZVxohjYN7Vhq4s+n3wxEQa6778FsX3L3kp87gnf9ub0SOfMl1XdQ
	 v0l3JU/7XqoPCsbKrI3aIeTgzgQSl6aPjTMZM9PUp9aN4U62HVjmd/UL1mW/pGEfqng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QN5Wd5Kn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F9606A31E
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=QN5Wd5Kn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878001F000C1;
	Fri, 30 Oct 2026 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793372261;
	bh=qa4fScqHiR9xb7pIeq0LTdvDrk765v2lbbrgQNlzDE8=;
	h=Date:To:From:Subject;
	b=QN5Wd5KnTO58D1XxbSolwra7ZV5W5npl4whDfP9rgmyBigsRjm/xLo0lg+WRDCWRf
	 tlqqTLG2RVSFGHOU8mEmPaJY5LtaWq+OK+jWXYPJGaswS9Sjc2Scd7/5td4IKnW4fJ
	 FFQYP7kWcjTsCBC/gPEe/JCbOFj28CuTJa4WlMbc=
Date: Fri, 30 Oct 2026 07:57:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch added to mm-new branch
Message-Id: <20261030145741.878001F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared memory
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory.patch

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
Subject: selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared memory
Date: Mon, 19 Oct 2026 13:12:03 -0400

Both hints are non-destructive, but the tests so far only check that for
private anonymous memory. Shared memory reaches reclaim differently:

Test the following:
 - a dirty shared file page must be written back or left resident,
 - shared anonymous memory is paged out through shmem
 - a SHM_LOCK'd segment is unevictable without its VMA being VM_LOCKED.

MADV_PAGEOUT unmaps a shmem page before it tries to swap it out
so none of these needs swap.

The SHM_LOCK test confirms the page is unevictable and skips otherwise.

Link: https://lore.kernel.org/20261019171206.3331374-5-gourry@gourry.net
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

 tools/testing/selftests/mm/madv_cold_pageout.c |  177 +++++++++++++++
 tools/testing/selftests/mm/vm_util.h           |    1 
 2 files changed, 178 insertions(+)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -7,7 +7,11 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
+#include <stdint.h>
+#include <sys/ipc.h>
 #include <sys/mman.h>
+#include <sys/shm.h>
+#include <sys/stat.h>
 #include <unistd.h>
 
 #include "kselftest_harness.h"
@@ -44,19 +48,47 @@ static void pin_to_current_cpu(void)
 	CPU_FREE(mask);
 }
 
+/* Whether pagemap shows PFNs, which it only does with CAP_SYS_ADMIN. */
+static bool pagemap_shows_pfns(struct __test_metadata *_metadata,
+			       int pagemap_fd)
+{
+	unsigned long pfn;
+	char *page;
+
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(page, MAP_FAILED);
+	page[0] = 1;
+	pfn = pagemap_get_pfn(pagemap_fd, page);
+	ASSERT_EQ(munmap(page, page_size), 0);
+
+	return pfn && pfn != -1UL;
+}
+
 FIXTURE(madv_cold_pageout)
 {
 	int pagemap_fd;
+	/* Needs root, and is -1 unless pagemap also shows PFNs. */
+	int kpageflags_fd;
 };
 
 FIXTURE_SETUP(madv_cold_pageout)
 {
 	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	ASSERT_GE(self->pagemap_fd, 0);
+	self->kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	/* Page flags are no use without the PFNs to look them up by. */
+	if (self->kpageflags_fd >= 0 &&
+	    !pagemap_shows_pfns(_metadata, self->pagemap_fd)) {
+		close(self->kpageflags_fd);
+		self->kpageflags_fd = -1;
+	}
 }
 
 FIXTURE_TEARDOWN(madv_cold_pageout)
 {
+	if (self->kpageflags_fd >= 0)
+		close(self->kpageflags_fd);
 	close(self->pagemap_fd);
 }
 
@@ -76,6 +108,58 @@ static bool pageout_until_swapped(char *
 	return false;
 }
 
+/* Page out the range until its first page is unmapped, or madvise() fails. */
+static bool pageout_until_unmapped(char *mapping, size_t size, int pagemap_fd)
+{
+	int retry;
+
+	for (retry = 0; retry < PAGEOUT_RETRIES; retry++) {
+		if (madvise(mapping, size, MADV_PAGEOUT))
+			return false;
+		if (!pagemap_is_populated(pagemap_fd, mapping))
+			return true;
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/* Create an unlinked, zero-filled temporary file, or return -1. */
+static int create_temp_file(size_t size)
+{
+	char template[] = "/tmp/madv_cold_pageout-XXXXXX";
+	int fd;
+
+	fd = mkstemp(template);
+	if (fd < 0)
+		return -1;
+	unlink(template);
+	if (ftruncate(fd, size)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+/* Map an unlinked, zero-filled temporary file with the given permissions. */
+static char *map_temp_file(struct __test_metadata *_metadata, size_t size,
+			   int flags, mode_t mode)
+{
+	char *mapping;
+	int fd;
+
+	fd = create_temp_file(size);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchmod(fd, mode), 0);
+
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	close(fd);
+
+	return mapping;
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -275,6 +359,99 @@ TEST_F(madv_cold_pageout, pageout_skips_
 	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_PAGEOUT);
 }
 
+/* MADV_COLD must not discard a dirty page of a shared file mapping. */
+TEST_F(madv_cold_pageout, cold_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), 0);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT may write a dirty shared file page back or leave it resident,
+ * but must not discard it.
+ */
+TEST_F(madv_cold_pageout, pageout_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
+	mapping[0] = 1;
+
+	if (!pageout_until_unmapped(mapping, page_size, self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not unmap the page");
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* MADV_PAGEOUT must not lose the contents of shared anonymous memory. */
+TEST_F(madv_cold_pageout, pageout_preserves_shared_anon_page)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+
+	/* MADV_PAGEOUT unmaps a shmem page even when it cannot swap it out. */
+	ASSERT_TRUE(pageout_until_unmapped(mapping, page_size,
+					   self->pagemap_fd));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * SHM_LOCK makes shmem pages unevictable without setting VM_LOCKED on the
+ * VMA, so MADV_PAGEOUT accepts the range but must not reclaim the page.
+ */
+TEST_F(madv_cold_pageout, pageout_skips_unevictable_page)
+{
+	unsigned long pfn;
+	uint64_t flags;
+	char *mapping;
+	int shmid;
+
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "cannot read page flags");
+	shmid = shmget(IPC_PRIVATE, page_size, IPC_CREAT | 0600);
+	ASSERT_GE(shmid, 0);
+	if (shmctl(shmid, SHM_LOCK, NULL)) {
+		shmctl(shmid, IPC_RMID, NULL);
+		SKIP(return, "could not lock a shmem segment");
+	}
+	mapping = shmat(shmid, NULL, 0);
+	/* The segment is destroyed once it is detached. */
+	shmctl(shmid, IPC_RMID, NULL);
+	ASSERT_NE(mapping, (void *)-1);
+	mapping[0] = 1;
+
+	/*
+	 * MADV_COLD drains this CPU's LRU add batch, which makes the page
+	 * unevictable.
+	 */
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), 0);
+	pfn = pagemap_get_pfn(self->pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, self->kpageflags_fd, &flags), 0);
+	if (!(flags & KPF_UNEVICTABLE))
+		SKIP(return, "could not make the page unevictable");
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(shmdt(mapping), 0);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-check-that-madv_cold-and-madv_pageout-preserve-shared-memory
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -24,6 +24,7 @@
 
 #define KPF_COMPOUND_HEAD             BIT_ULL(15)
 #define KPF_COMPOUND_TAIL             BIT_ULL(16)
+#define KPF_UNEVICTABLE               BIT_ULL(18)
 #define KPF_HWPOISON                  BIT_ULL(19)
 #define KPF_THP                       BIT_ULL(22)
 /*
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

