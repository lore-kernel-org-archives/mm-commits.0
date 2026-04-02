Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8036F429
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 04:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775103830; cv=none; b=CwytcAbsZXKlYlFHvzUll1e6PjD5rIpDRogNWVU6uqbu0Ue87B96O7IvZiV0qpwGEfcxuR21PvyR1wCp1lalX5xVAICrUJto1vkGVsTl3BABDmv6Amp1LCMhJMmQBENZtqd3RSDTruRnyzNCKVFKizjhi3cvbhoBOPBwblshkqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775103830; c=relaxed/simple;
	bh=jcZBoXu5wW+eWV1a6co0oAjZ/uFj6g0H7bDXfe5U4aw=;
	h=Date:To:From:Subject:Message-Id; b=dD8QdM2yEnidkdwlRuSeaM24pm6etHVRzzzSMcboG3DUqd07ghOcFLt4hQLAYYjmOkRyi6PQQglcHtHO21Biux50Sx7S6rcetRsG7WPy7HmtdLDEuPSFFdQlpkP1Bjv4BD+ev0zXt06hBAlotqfWFedRJWMYKdNcFWskFPGORRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzkE8LUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzkE8LUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1518AC19423;
	Thu,  2 Apr 2026 04:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775103830;
	bh=jcZBoXu5wW+eWV1a6co0oAjZ/uFj6g0H7bDXfe5U4aw=;
	h=Date:To:From:Subject:From;
	b=QzkE8LUHwznIiCmPtMItXoYBuxOUFuQEeqMP/Oe+5ENrlSM1os35V15qZzHTZmBe8
	 9Nkmq7pAIPbAU0StBY8ZpjHFW8R7jdQqOSlZ8foMtUMEDxVLOqCuxuJlA2R+VsrBPr
	 uVggjnzLU+tITYM+Kykxuu44buRLGEOVx92lHDuk=
Date: Wed, 01 Apr 2026 21:23:49 -0700
To: mm-commits@vger.kernel.org,kalyazin@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kvm-selftests-test-userfaultfd-minor-for-guest_memfd.patch removed from -mm tree
Message-Id: <20260402042350.1518AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: selftests: test userfaultfd minor for guest_memfd
has been removed from the -mm tree.  Its filename was
     kvm-selftests-test-userfaultfd-minor-for-guest_memfd.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nikita Kalyazin <kalyazin@amazon.com>
Subject: KVM: selftests: test userfaultfd minor for guest_memfd
Date: Mon, 30 Mar 2026 13:11:15 +0300

The test demonstrates that a minor userfaultfd event in guest_memfd can be
resolved via a memcpy followed by a UFFDIO_CONTINUE ioctl.

Link: https://lkml.kernel.org/r/20260330101116.1117699-15-rppt@kernel.org
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kvm/guest_memfd_test.c |  113 +++++++++++++++
 1 file changed, 113 insertions(+)

--- a/tools/testing/selftests/kvm/guest_memfd_test.c~kvm-selftests-test-userfaultfd-minor-for-guest_memfd
+++ a/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,13 +10,17 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <pthread.h>
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
 #include <linux/sizes.h>
+#include <linux/userfaultfd.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/ioctl.h>
 
 #include "kvm_util.h"
 #include "numaif.h"
@@ -329,6 +333,112 @@ static void test_create_guest_memfd_mult
 	close(fd1);
 }
 
+struct fault_args {
+	char *addr;
+	char value;
+};
+
+static void *fault_thread_fn(void *arg)
+{
+	struct fault_args *args = arg;
+
+	/* Trigger page fault */
+	args->value = *args->addr;
+	return NULL;
+}
+
+static void test_uffd_minor(int fd, size_t total_size)
+{
+	struct uffdio_register uffd_reg;
+	struct uffdio_continue uffd_cont;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *mem_nofault, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+	const char test_val = 0xcd;
+
+	ret = posix_memalign(&buf, page_size, total_size);
+	TEST_ASSERT_EQ(ret, 0);
+	memset(buf, test_val, total_size);
+
+	uffd = syscall(__NR_userfaultfd, O_CLOEXEC);
+	TEST_ASSERT(uffd != -1, "userfaultfd creation should succeed");
+
+	struct uffdio_api uffdio_api = {
+		.api = UFFD_API,
+		.features = 0,
+	};
+	ret = ioctl(uffd, UFFDIO_API, &uffdio_api);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_API) should succeed");
+
+	/* Map the guest_memfd twice: once with UFFD registered, once without */
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	mem_nofault = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem_nofault != MAP_FAILED, "mmap should succeed");
+
+	/* Register UFFD_MINOR on the first mapping */
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MINOR;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
+	/*
+	 * Populate the page in the page cache first via mem_nofault.
+	 * This is required for UFFD_MINOR - the page must exist in the cache.
+	 * Write test data to the page.
+	 */
+	memcpy(mem_nofault + offset, buf + offset, page_size);
+
+	/*
+	 * Now access the same page via mem (which has UFFD_MINOR registered).
+	 * Since the page exists in the cache, this should trigger UFFD_MINOR.
+	 */
+	fault_addr = mem + offset;
+	args.addr = fault_addr;
+
+	ret = pthread_create(&fault_thread, NULL, fault_thread_fn, &args);
+	TEST_ASSERT(ret == 0, "pthread_create should succeed");
+
+	ret = read(uffd, &msg, sizeof(msg));
+	TEST_ASSERT(ret != -1, "read from userfaultfd should succeed");
+	TEST_ASSERT(msg.event == UFFD_EVENT_PAGEFAULT, "event type should be pagefault");
+	TEST_ASSERT((void *)(msg.arg.pagefault.address & ~(page_size - 1)) == fault_addr,
+		    "pagefault should occur at expected address");
+	TEST_ASSERT(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_MINOR,
+		    "pagefault should be minor fault");
+
+	/* Resolve the minor fault with UFFDIO_CONTINUE */
+	uffd_cont.range.start = (unsigned long)fault_addr;
+	uffd_cont.range.len = page_size;
+	uffd_cont.mode = 0;
+	ret = ioctl(uffd, UFFDIO_CONTINUE, &uffd_cont);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_CONTINUE) should succeed");
+
+	/* Wait for the faulting thread to complete */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	/* Verify the thread read the correct value */
+	TEST_ASSERT(args.value == test_val,
+		    "memory should contain the value that was written");
+	TEST_ASSERT(*(char *)(mem + offset) == test_val,
+		    "no further fault is expected");
+
+	ret = munmap(mem_nofault, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap should succeed");
+	free(buf);
+	close(uffd);
+}
+
 static void test_guest_memfd_flags(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
@@ -383,6 +493,9 @@ static void __test_guest_memfd(struct kv
 	gmem_test(file_size, vm, flags);
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
+
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+		gmem_test(uffd_minor, vm, flags);
 }
 
 static void test_guest_memfd(unsigned long vm_type)
_

Patches currently in -mm which might be from kalyazin@amazon.com are

kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

