Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4977EEF5
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104010; cv=none; b=d1g+2bfZANbhKXXzWvEj97BuPVnOre2PN++W7/AtJCVU88hipHR8YsnWXFkZnHe7X64snXI4sQKvUNYBnX5C/8LzJbxdH3zA7wZjRhVYK6JAsSH5M634JvMqncQo/753jXlwPycvKVHsLhugQGQGMjaNDwSyxiLROHdgWKrR6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104010; c=relaxed/simple;
	bh=ZmD9YsXnEULpsZyEppGKmQ3ppu9otBhrhSBb0o11dJ4=;
	h=Date:To:From:Subject:Message-Id; b=CAUUuStm0S4Ou9AqpJWvNDXd6L355QDVJrzjv0rMgZVqg/7OX0tjdeqjqoZ/D/OGrTRhyBRHifkp/zcMCZS8rJhOqFVRe6xoF6oTduiinsCKZZ422g6jGSMyu6gqYl8IdPRJIYHeS3TDmbfrVT/KsOziNcmnBIWztEi8mrEr4TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2N0dLiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2N0dLiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0269DC113CD;
	Fri, 26 Apr 2024 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104010;
	bh=ZmD9YsXnEULpsZyEppGKmQ3ppu9otBhrhSBb0o11dJ4=;
	h=Date:To:From:Subject:From;
	b=N2N0dLizVWUJykWUWjUF6hsEt7PhgnJ9YjMTU/Mkp/91zqvZeXBj7pAo3POY8OhmY
	 7MPpJifeTudo0IYm4lArNKGFxD1pyq1TH0R7eAFKI5i/uPW0Hb4/FUhKjNUijrQVxZ
	 2usV9lFyBOnfrx6bRso4f1nMbQJ3NmOdeK7Jdk3s=
Date: Thu, 25 Apr 2024 21:00:09 -0700
To: mm-commits@vger.kernel.org,xrivendell7@gmail.com,samsun1006219@gmail.com,rppt@kernel.org,mszeredi@redhat.com,lstoakes@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd_secret-add-vmsplice-test.patch removed from -mm tree
Message-Id: <20240426040010.0269DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd_secret: add vmsplice() test
has been removed from the -mm tree.  Its filename was
     selftests-memfd_secret-add-vmsplice-test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: selftests/memfd_secret: add vmsplice() test
Date: Tue, 26 Mar 2024 15:32:09 +0100

Let's add a simple reproducer for a scenario where GUP-fast could succeed
on secretmem folios, making vmsplice() succeed instead of failing.  The
reproducer is based on a reproducer [1] by Miklos Szeredi.

We want to perform two tests: vmsplice() when a fresh page was just
faulted in, and vmsplice() on an existing page after munmap() that would
drain certain LRU caches/batches in the kernel.

In an ideal world, we could use fallocate(FALLOC_FL_PUNCH_HOLE) /
MADV_REMOVE to remove any existing page.  As that is currently not
possible, run the test before any other tests that would allocate memory
in the secretmem fd.

Perform the ftruncate() only once, and check the return value.

[1] https://lkml.kernel.org/r/CAJfpegt3UCsMmxd0taOY11Uaw5U=eS1fE5dn0wZX3HF0oy8-oQ@mail.gmail.com

Link: https://lkml.kernel.org/r/20240326143210.291116-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: xingwei lee <xrivendell7@gmail.com>
Cc: yue sun <samsun1006219@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memfd_secret.c |   51 +++++++++++++++++++-
 1 file changed, 49 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-memfd_secret-add-vmsplice-test
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -20,6 +20,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <stdio.h>
+#include <fcntl.h>
 
 #include "../kselftest.h"
 
@@ -83,6 +84,45 @@ static void test_mlock_limit(int fd)
 	pass("mlock limit is respected\n");
 }
 
+static void test_vmsplice(int fd, const char *desc)
+{
+	ssize_t transferred;
+	struct iovec iov;
+	int pipefd[2];
+	char *mem;
+
+	if (pipe(pipefd)) {
+		fail("pipe failed: %s\n", strerror(errno));
+		return;
+	}
+
+	mem = mmap(NULL, page_size, prot, mode, fd, 0);
+	if (mem == MAP_FAILED) {
+		fail("Unable to mmap secret memory\n");
+		goto close_pipe;
+	}
+
+	/*
+	 * vmsplice() may use GUP-fast, which must also fail. Prefault the
+	 * page table, so GUP-fast could find it.
+	 */
+	memset(mem, PATTERN, page_size);
+
+	iov.iov_base = mem;
+	iov.iov_len = page_size;
+	transferred = vmsplice(pipefd[1], &iov, 1, 0);
+
+	if (transferred < 0 && errno == EFAULT)
+		pass("vmsplice is blocked as expected with %s\n", desc);
+	else
+		fail("vmsplice: unexpected memory access with %s\n", desc);
+
+	munmap(mem, page_size);
+close_pipe:
+	close(pipefd[0]);
+	close(pipefd[1]);
+}
+
 static void try_process_vm_read(int fd, int pipefd[2])
 {
 	struct iovec liov, riov;
@@ -187,7 +227,6 @@ static void test_remote_access(int fd, c
 		return;
 	}
 
-	ftruncate(fd, page_size);
 	memset(mem, PATTERN, page_size);
 
 	if (write(pipefd[1], &mem, sizeof(mem)) < 0) {
@@ -258,7 +297,7 @@ static void prepare(void)
 				   strerror(errno));
 }
 
-#define NUM_TESTS 4
+#define NUM_TESTS 6
 
 int main(int argc, char *argv[])
 {
@@ -277,9 +316,17 @@ int main(int argc, char *argv[])
 			ksft_exit_fail_msg("memfd_secret failed: %s\n",
 					   strerror(errno));
 	}
+	if (ftruncate(fd, page_size))
+		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
 
 	test_mlock_limit(fd);
 	test_file_apis(fd);
+	/*
+	 * We have to run the first vmsplice test before any secretmem page was
+	 * allocated for this fd.
+	 */
+	test_vmsplice(fd, "fresh page");
+	test_vmsplice(fd, "existing page");
 	test_process_vm_read(fd);
 	test_ptrace(fd);
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
loongarch-tlb-fix-error-parameter-ptep-set-but-not-used-due-to-__tlb_remove_tlb_entry.patch

