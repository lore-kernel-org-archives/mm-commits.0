Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372266;
	b=ywXQu8wNYPnFvU7craChSB7jhUbJX4WBwtlukhkbTJVD0oeYltCfo37FoVCeJ1gIFa4Q
	 L3IU6YbfqcKsZ0bdxFMH5Qx8Hzao529IOA06HezkuO4ML7JCQU3Kks52QdCJGENYgadkf
	 8RkP+8AzidWOPJPTrAUFQDRhKuHQ4PzEx1z+bdOWGY/Fe8BSKSjrfEi1t8jFBrZ7oIYI8
	 SyITcbHX64UeWuKkMACAMfUUT7NY4Y2w1J7CAPfId/HawiiredeRzPcJU/F53Pvlpj7t/
	 QimIixb1yALiz8NoRLYnRhGgCCz8Vaqu8mtRIQTR6OZ12ltJu2AxyXxzEvfNUtsZDXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372266;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=eLCuR2UwrSBw+I/uXOy8FPKyA5MCBs9hvc4QQyFLWfk=;
	b=yOtveY/2k9DjasUWbQS1KkcXS8mTNtISfO39MMm4/snAOS/BVT3iegANB4GbukX1229x
	 celzmKx95GPpllF7zKYTyNOEj0lS7tDcSV1m1ZKWolgWNjhdoTfweQrA7yEa3zspXBbMS
	 W8T79GloB7P8rmh6mCS2kvHSev0P3XagtW9zbkHC6D7abwOebUG6itqQN2QcGC6BsQWA5
	 8/LLlfDJJxV1Mdr8NUFL+LfDWjI1ozdqRt0+K9bZOK+4TIWV7I3ZZkt9CX1fX9UZmR42X
	 /76lBCkX4IUWr40kQni5AvebU4uHyJ4JZPJdGAsUcIO7Xoppl4cHE/k9El9poGSplSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vV6DWekQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B98606A31A
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vV6DWekQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF8A1F000C1;
	Fri, 30 Oct 2026 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793372266;
	bh=eLCuR2UwrSBw+I/uXOy8FPKyA5MCBs9hvc4QQyFLWfk=;
	h=Date:To:From:Subject;
	b=vV6DWekQeGMxcKOpTJs99jPtZMZFjH2hGiku6dadDz6+5KeyJIKEsBVwIZ6wmh6DD
	 BSgkFxY6thv4K/ljmsI37vvYuREba6UZCaul6A9uG3HQ1TdevYWy9FEtgBc6r63iT1
	 fex0wDbuGJ5Al7RZtExgk6ErUPDXy+bLarvMl7X8=
Date: Fri, 30 Oct 2026 07:57:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,sarthak.sharma@arm.com,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,gourry@gourry.net,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-check-madv_pageout-file-permissions.patch added to mm-new branch
Message-Id: <20261030145745.EEF8A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: check MADV_PAGEOUT file permissions
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-check-madv_pageout-file-permissions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-check-madv_pageout-file-permissions.patch

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
Subject: selftests/mm: check MADV_PAGEOUT file permissions
Date: Mon, 19 Oct 2026 13:12:05 -0400

MADV_PAGEOUT only pages out file pages for a caller that owns the file or
could open it for writing, per can_do_file_pageout(). Any other caller
gets nothing from a shared file mapping, and only the anonymous COW pages
from a private one.

main() now also checks once whether MADV_PAGEOUT can unmap a clean page
of a file in /tmp, where the tests make their files. The tests below skip
if it cannot, since none of them would show anything.

Check that the owner of a read-only file can page out a clean page of
it. When started as root, the test hands the file to nobody and drops
privileges, so that capabilities cannot stand in for ownership and
nobody need not be able to write to /tmp.

Also check that an unauthorized caller leaves a shared file page mapped,
and that it pages out the COW page of a private mapping but not the file
page next to it. These need root to change credentials, and skip if that
fails. The private mapping check also skips if MADV_PAGEOUT cannot swap.

Link: https://lore.kernel.org/20261019171206.3331374-7-gourry@gourry.net
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

 tools/testing/selftests/mm/madv_cold_pageout.c |  127 +++++++++++++++
 1 file changed, 127 insertions(+)

--- a/tools/testing/selftests/mm/madv_cold_pageout.c~selftests-mm-check-madv_pageout-file-permissions
+++ a/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <grp.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
@@ -29,6 +30,8 @@ static size_t page_size;
 static size_t pmd_size;
 /* Whether MADV_PAGEOUT can swap out anonymous memory, see main(). */
 static bool can_swap;
+/* Whether MADV_PAGEOUT can unmap clean file pages in /tmp, see main(). */
+static bool can_unmap_file;
 
 /*
  * Keep this task on one CPU, so that draining that CPU's LRU batches drains
@@ -276,6 +279,15 @@ static char *map_temp_file(struct __test
 	return mapping;
 }
 
+/* The uid and gid of nobody. */
+#define NOBODY 65534
+
+/* Become nobody, an unprivileged user without capabilities. */
+static bool drop_privileges(void)
+{
+	return !setgroups(0, NULL) && !setgid(NOBODY) && !setuid(NOBODY);
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -689,6 +701,97 @@ TEST_F(madv_cold_pageout, cold_preserves
 	ASSERT_EQ(munmap(mapping, pmd_size), 0);
 }
 
+/*
+ * The owner of a file may page out its clean page-cache pages. Run as an
+ * unprivileged owner, so that capabilities cannot stand in for ownership.
+ */
+TEST_F(madv_cold_pageout, pageout_unmaps_owned_file_page)
+{
+	char *mapping;
+	int fd;
+
+	if (!can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot unmap file pages");
+	fd = create_temp_file(page_size);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchmod(fd, 0400), 0);
+	/* Hand the file over first, as nobody may not be able to write /tmp. */
+	if (!geteuid()) {
+		ASSERT_EQ(fchown(fd, NOBODY, NOBODY), 0);
+		if (!drop_privileges())
+			SKIP(return, "could not drop privileges");
+	}
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_PRIVATE,
+		       fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	close(fd);
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pageout_until_unmapped(mapping, page_size,
+					   self->pagemap_fd));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file must not page out its
+ * shared mappings. MADV_PAGEOUT succeeds but leaves the page mapped.
+ */
+TEST_F(madv_cold_pageout, pageout_skips_unauthorized_shared_file)
+{
+	char *mapping;
+
+	/* Otherwise the page would stay mapped regardless. */
+	if (!can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot unmap file pages");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file may page out the anonymous
+ * COW pages of a private mapping of it, but must leave the file pages
+ * mapped.
+ */
+TEST_F(madv_cold_pageout, pageout_private_file_reclaims_only_cow)
+{
+	char *mapping;
+
+	if (!can_swap || !can_unmap_file)
+		SKIP(return, "MADV_PAGEOUT cannot swap or unmap file pages");
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, 2 * page_size, MAP_PRIVATE,
+				0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_EQ(mapping[page_size], 0);
+	mapping[0] = 1;
+
+	ASSERT_TRUE(pageout_until_swapped(mapping, 2 * page_size,
+					  self->pagemap_fd));
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
+					 mapping + page_size));
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[page_size], 0);
+
+	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
+}
+
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
@@ -706,6 +809,27 @@ static bool probe_swap(int pagemap_fd)
 	return swapped;
 }
 
+/* Unmap a clean page of a file in /tmp, where the tests make their files. */
+static bool probe_file_unmap(int pagemap_fd)
+{
+	bool unmapped;
+	char *page;
+	int fd;
+
+	fd = create_temp_file(page_size);
+	if (fd < 0)
+		ksft_exit_fail_perror("create_temp_file");
+	page = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE, fd, 0);
+	if (page == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	close(fd);
+	FORCE_READ(page[0]);
+	unmapped = pageout_until_unmapped(page, page_size, pagemap_fd);
+	munmap(page, page_size);
+
+	return unmapped;
+}
+
 int main(int argc, char **argv)
 {
 	int pagemap_fd;
@@ -724,6 +848,9 @@ int main(int argc, char **argv)
 	can_swap = probe_swap(pagemap_fd);
 	if (!can_swap)
 		ksft_print_msg("MADV_PAGEOUT cannot swap\n");
+	can_unmap_file = probe_file_unmap(pagemap_fd);
+	if (!can_unmap_file)
+		ksft_print_msg("MADV_PAGEOUT cannot unmap file pages\n");
 	close(pagemap_fd);
 
 	return test_harness_run(argc, argv);
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

