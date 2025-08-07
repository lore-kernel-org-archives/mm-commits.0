Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD90186A
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 03:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754538290; cv=none; b=ZbrTQEXdacDWGcIfudIcQ8LXUbW+PZb2QsIVQ5dYJj+Zbh7Bem8KVjNT2EuqVHqfNvQLT0+aiZfAxXsBIiO0fsOMOiJndDhOj+da9fY6xKQjTCySG8kv4FmskceplyAGa5bl4FCkV4OoZAFX/9HpZ85ApbCg2igdvOVZIfDkInM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754538290; c=relaxed/simple;
	bh=HAFfodt6X7R7KCHdQZLgeVEcXvaf5pRY8Y0FeqIJ/Fo=;
	h=Date:To:From:Subject:Message-Id; b=NcjK1ISpMTMrG2tpX1YaOE+3lCH+yLN08bpj8kRBSnHzBovy0idNRXYE3uIoR/l7pOE8gWN3y8z1xpkCh2Z1qOE/Mmrs237H70UpgV8mOAUThUrEX9etD51aVSAkwNNTYWYoummvkHHdoS7GLA9+HEE7+jH2FG24ovD/ZTxO/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EszoyNTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EszoyNTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9B0C4CEEB;
	Thu,  7 Aug 2025 03:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754538289;
	bh=HAFfodt6X7R7KCHdQZLgeVEcXvaf5pRY8Y0FeqIJ/Fo=;
	h=Date:To:From:Subject:From;
	b=EszoyNTqy6D1wofZmGsF15pyPsWfsldmq8gOampUAaaqeOSQt7b9Vct5YqmuWuw/m
	 3BjxAEIcRLTlfQz9iedbJDhVo8Qw7EhH0awCOYUNiJmcJPry8vxYy4Qqssje/hyTP2
	 2kdbbvBYASzWHgQnCUUh1ezWljAim8QZoxSKp1qU=
Date: Wed, 06 Aug 2025 20:44:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sidhartha.kumar@oracle.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leon@kernel.org,jhubbard@nvidia.com,jgg@ziepe.ca,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aou@eecs.berkeley.edu,alex@ghiti.fr,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mark-unused-arguments-with-__unused.patch added to mm-new branch
Message-Id: <20250807034449.8D9B0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: mark unused arguments with __unused
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mark-unused-arguments-with-__unused.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mark-unused-arguments-with-__unused.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: mark unused arguments with __unused
Date: Thu, 31 Jul 2025 21:01:30 +0500

Mark the arguments which cannot be removed with __unused attribute.

Link: https://lkml.kernel.org/r/20250731160132.1795351-7-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c             |   20 +++++------
 tools/testing/selftests/mm/memfd_secret.c    |    4 +-
 tools/testing/selftests/mm/pfnmap.c          |    2 -
 tools/testing/selftests/mm/uffd-common.c     |   11 +++---
 tools/testing/selftests/mm/uffd-unit-tests.c |   30 ++++++++---------
 5 files changed, 34 insertions(+), 33 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-mark-unused-arguments-with-__unused
+++ a/tools/testing/selftests/mm/cow.c
@@ -253,12 +253,12 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_cow_in_parent(char *mem, size_t size, bool is_hugetlb)
+static void test_cow_in_parent(char *mem, size_t size, bool __unused is_hugetlb)
 {
 	do_test_cow_in_parent(mem, size, false, child_memcmp_fn, false);
 }
 
-static void test_cow_in_parent_mprotect(char *mem, size_t size, bool is_hugetlb)
+static void test_cow_in_parent_mprotect(char *mem, size_t size, bool __unused is_hugetlb)
 {
 	do_test_cow_in_parent(mem, size, true, child_memcmp_fn, false);
 }
@@ -734,36 +734,36 @@ free_tmp:
 	free(tmp);
 }
 
-static void test_ro_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
+static void test_ro_pin_on_shared(char *mem, size_t size, bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
+static void test_ro_fast_pin_on_shared(char *mem, size_t size, bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, true);
 }
 
 static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size,
-		bool is_hugetlb)
+		bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, false);
 }
 
 static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size,
-		bool is_hugetlb)
+		bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, true);
 }
 
 static void test_ro_pin_on_ro_exclusive(char *mem, size_t size,
-		bool is_hugetlb)
+		bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, false);
 }
 
 static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size,
-		bool is_hugetlb)
+		bool __unused is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, true);
 }
@@ -1522,12 +1522,12 @@ static void test_cow(char *mem, const ch
 	free(old);
 }
 
-static void test_ro_pin(char *mem, const char *smem, size_t size)
+static void test_ro_pin(char *mem, const char __unused *smem, size_t size)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST, false);
 }
 
-static void test_ro_fast_pin(char *mem, const char *smem, size_t size)
+static void test_ro_fast_pin(char *mem, const char __unused *smem, size_t size)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST, true);
 }
--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-mark-unused-arguments-with-__unused
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -123,7 +123,7 @@ close_pipe:
 	close(pipefd[1]);
 }
 
-static void try_process_vm_read(int fd, int pipefd[2])
+static void try_process_vm_read(int __unused fd, int pipefd[2])
 {
 	struct iovec liov, riov;
 	char buf[64];
@@ -147,7 +147,7 @@ static void try_process_vm_read(int fd,
 	exit(KSFT_FAIL);
 }
 
-static void try_ptrace(int fd, int pipefd[2])
+static void try_ptrace(int __unused fd, int pipefd[2])
 {
 	pid_t ppid = getppid();
 	int status;
--- a/tools/testing/selftests/mm/pfnmap.c~selftests-mm-mark-unused-arguments-with-__unused
+++ a/tools/testing/selftests/mm/pfnmap.c
@@ -28,7 +28,7 @@
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
 
-static void signal_handler(int sig)
+static void signal_handler(int __unused sig)
 {
 	siglongjmp(sigjmp_buf_env, -EFAULT);
 }
--- a/tools/testing/selftests/mm/uffd-common.c~selftests-mm-mark-unused-arguments-with-__unused
+++ a/tools/testing/selftests/mm/uffd-common.c
@@ -46,7 +46,7 @@ static void anon_release_pages(char *rel
 		err("madvise(MADV_DONTNEED) failed");
 }
 
-static int anon_allocate_area(void **alloc_area, bool is_src)
+static int anon_allocate_area(void **alloc_area, bool __unused is_src)
 {
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
@@ -57,7 +57,8 @@ static int anon_allocate_area(void **all
 	return 0;
 }
 
-static void noop_alias_mapping(__u64 *start, size_t len, unsigned long offset)
+static void noop_alias_mapping(__u64 __unused *start, size_t __unused len,
+			       unsigned long __unused offset)
 {
 }
 
@@ -108,7 +109,7 @@ static int hugetlb_allocate_area(void **
 	return 0;
 }
 
-static void hugetlb_alias_mapping(__u64 *start, size_t len, unsigned long offset)
+static void hugetlb_alias_mapping(__u64 *start, size_t __unused len, unsigned long offset)
 {
 	if (!map_shared)
 		return;
@@ -167,12 +168,12 @@ static int shmem_allocate_area(void **al
 	return 0;
 }
 
-static void shmem_alias_mapping(__u64 *start, size_t len, unsigned long offset)
+static void shmem_alias_mapping(__u64 *start, size_t __unused len, unsigned long offset)
 {
 	*start = (unsigned long)area_dst_alias + offset;
 }
 
-static void shmem_check_pmd_mapping(void *p, int expect_nr_hpages)
+static void shmem_check_pmd_mapping(void __unused *p, int expect_nr_hpages)
 {
 	if (!check_huge_shmem(area_dst_alias, expect_nr_hpages,
 			      read_pmd_pagesize()))
--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-mark-unused-arguments-with-__unused
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -361,7 +361,7 @@ static int pagemap_test_fork(int uffd, b
 	return result;
 }
 
-static void uffd_wp_unpopulated_test(uffd_test_args_t *args)
+static void uffd_wp_unpopulated_test(uffd_test_args_t __unused *args)
 {
 	uint64_t value;
 	int pagemap_fd;
@@ -487,7 +487,7 @@ static void uffd_wp_fork_with_event_test
 	uffd_wp_fork_test_common(args, true);
 }
 
-static void uffd_wp_fork_pin_test_common(uffd_test_args_t *args,
+static void uffd_wp_fork_pin_test_common(uffd_test_args_t __unused *args,
 					 bool with_event)
 {
 	int pagemap_fd;
@@ -631,24 +631,24 @@ static void uffd_minor_test_common(bool
 		uffd_test_pass();
 }
 
-void uffd_minor_test(uffd_test_args_t *args)
+void uffd_minor_test(uffd_test_args_t __unused *args)
 {
 	uffd_minor_test_common(false, false);
 }
 
-void uffd_minor_wp_test(uffd_test_args_t *args)
+void uffd_minor_wp_test(uffd_test_args_t __unused *args)
 {
 	uffd_minor_test_common(false, true);
 }
 
-void uffd_minor_collapse_test(uffd_test_args_t *args)
+void uffd_minor_collapse_test(uffd_test_args_t __unused *args)
 {
 	uffd_minor_test_common(true, false);
 }
 
 static sigjmp_buf jbuf, *sigbuf;
 
-static void sighndl(int sig, siginfo_t *siginfo, void *ptr)
+static void sighndl(int sig, siginfo_t __unused *siginfo, void __unused *ptr)
 {
 	if (sig == SIGBUS) {
 		if (sigbuf)
@@ -824,12 +824,12 @@ static void uffd_sigbus_test_common(bool
 		uffd_test_pass();
 }
 
-static void uffd_sigbus_test(uffd_test_args_t *args)
+static void uffd_sigbus_test(uffd_test_args_t __unused *args)
 {
 	uffd_sigbus_test_common(false);
 }
 
-static void uffd_sigbus_wp_test(uffd_test_args_t *args)
+static void uffd_sigbus_wp_test(uffd_test_args_t __unused *args)
 {
 	uffd_sigbus_test_common(true);
 }
@@ -877,12 +877,12 @@ static void uffd_events_test_common(bool
 		uffd_test_pass();
 }
 
-static void uffd_events_test(uffd_test_args_t *args)
+static void uffd_events_test(uffd_test_args_t __unused *args)
 {
 	uffd_events_test_common(false);
 }
 
-static void uffd_events_wp_test(uffd_test_args_t *args)
+static void uffd_events_wp_test(uffd_test_args_t __unused *args)
 {
 	uffd_events_test_common(true);
 }
@@ -950,7 +950,7 @@ uffd_register_detect_zeropage(int uffd,
 }
 
 /* exercise UFFDIO_ZEROPAGE */
-static void uffd_zeropage_test(uffd_test_args_t *args)
+static void uffd_zeropage_test(uffd_test_args_t __unused *args)
 {
 	bool has_zeropage;
 	int i;
@@ -1006,7 +1006,7 @@ static void do_uffdio_poison(int uffd, u
 }
 
 static void uffd_poison_handle_fault(
-	struct uffd_msg *msg, struct uffd_args *args)
+	struct uffd_msg *msg, struct uffd_args __unused *args)
 {
 	unsigned long offset;
 
@@ -1030,7 +1030,7 @@ static void uffd_poison_handle_fault(
 /* Make sure to cover odd/even, and minimum duplications */
 #define  UFFD_POISON_TEST_NPAGES  4
 
-static void uffd_poison_test(uffd_test_args_t *targs)
+static void uffd_poison_test(uffd_test_args_t __unused *targs)
 {
 	pthread_t uffd_mon;
 	char c;
@@ -1126,7 +1126,7 @@ static void uffd_move_pmd_handle_fault(s
 }
 
 static void
-uffd_move_test_common(uffd_test_args_t *targs, unsigned long chunk_size,
+uffd_move_test_common(uffd_test_args_t __unused *targs, unsigned long chunk_size,
 		      void (*handle_fault)(struct uffd_msg *msg, struct uffd_args *args))
 {
 	unsigned long nr;
@@ -1359,7 +1359,7 @@ static void uffd_consume_message(void)
 	while (uffd_read_msg(&msg));
 }
 
-static void uffd_mmap_changing_test(uffd_test_args_t *targs)
+static void uffd_mmap_changing_test(uffd_test_args_t __unused *targs)
 {
 	/*
 	 * This stores the real PID (which can be different from how tid is
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-add-wunreachable-code-and-fix-warnings.patch
selftests-mm-protection_keys-fix-dead-code.patch
selftests-kselftesth-add-__unused-macro.patch
selftests-mm-add-wunused-family-of-flags.patch
selftests-mm-remove-unused-parameters.patch
selftests-mm-mark-unused-arguments-with-__unused.patch
selftests-mm-mark-unused-arguments-with-__unused-2.patch
selftests-mm-fix-unused-parameter-warnings-for-different-architectures.patch

