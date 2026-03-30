Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FA539B95F
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899860; cv=none; b=He7mDgsWVsDIKPz1rsMTMJqXrSlgBwUKbqYuJkP+x/iQ1vhFf6WllNEPBzxkQreFugjQJUpMOMArg6dkGzIdwMG427r+PzBat82QoQWAZNPXV+UMRGveJXECddlQD1UZdpVPlnhIetSIEgHW+ogYIWRqjB29rhVBUN/jqa8egCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899860; c=relaxed/simple;
	bh=EfgNHCsBZl6m8k4LSercTpiLJzno60inODZ/1uVqGcg=;
	h=Date:To:From:Subject:Message-Id; b=hhyIEQFGytSod3S22tULW13LVG815fyrLvjxg40YhQirheXj1+FrqCqjcbMePWbJeHX+EN5XWACZ+ZyaZBbbDKu0LypZSSY+3EOzpH/W+LRYapo3rBwGuGwziCnljpbZf65Qu+zHPkHK+P73lQgtnRnOACDehGx9IM3irPNptwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wcu41r/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wcu41r/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE46DC4CEF7;
	Mon, 30 Mar 2026 19:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899859;
	bh=EfgNHCsBZl6m8k4LSercTpiLJzno60inODZ/1uVqGcg=;
	h=Date:To:From:Subject:From;
	b=Wcu41r/aBoin7kggnoQUbvt9FifMQ6BB8ICuwqlO58qNuf0H0D0dLrE5tk4N3YSxM
	 k3Zg0QuV0SESaO7QPwSMdPrUh/oH41p+WvPpPBhDJCrsFnQK9WLp+Op5btBMq7hFjr
	 bbU1+5jyN//T+o97/1wkTas4tjj7vaEDSp6ZxGls=
Date: Mon, 30 Mar 2026 12:44:19 -0700
To: mm-commits@vger.kernel.org,kalyazin@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch added to mm-unstable branch
Message-Id: <20260330194419.CE46DC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: selftests: test userfaultfd missing for guest_memfd
has been added to the -mm mm-unstable branch.  Its filename is
     kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nikita Kalyazin <kalyazin@amazon.com>
Subject: KVM: selftests: test userfaultfd missing for guest_memfd
Date: Mon, 30 Mar 2026 13:11:16 +0300

The test demonstrates that a missing userfaultfd event in guest_memfd can
be resolved via a UFFDIO_COPY ioctl.

Link: https://lkml.kernel.org/r/20260330101116.1117699-16-rppt@kernel.org
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

 tools/testing/selftests/kvm/guest_memfd_test.c |   80 ++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/kvm/guest_memfd_test.c~kvm-selftests-test-userfaultfd-missing-for-guest_memfd
+++ a/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -439,6 +439,82 @@ static void test_uffd_minor(int fd, size
 	close(uffd);
 }
 
+static void test_uffd_missing(int fd, size_t total_size)
+{
+	struct uffdio_register uffd_reg;
+	struct uffdio_copy uffd_copy;
+	struct uffd_msg msg;
+	struct fault_args args;
+	pthread_t fault_thread;
+	void *mem, *buf = NULL;
+	int uffd, ret;
+	off_t offset = page_size;
+	void *fault_addr;
+	const char test_val = 0xab;
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
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap should succeed");
+
+	uffd_reg.range.start = (unsigned long)mem;
+	uffd_reg.range.len = total_size;
+	uffd_reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+	ret = ioctl(uffd, UFFDIO_REGISTER, &uffd_reg);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_REGISTER) should succeed");
+
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
+	TEST_ASSERT(!(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP),
+		    "pagefault should not be write-protect");
+
+	uffd_copy.dst = (unsigned long)fault_addr;
+	uffd_copy.src = (unsigned long)(buf + offset);
+	uffd_copy.len = page_size;
+	uffd_copy.mode = 0;
+	ret = ioctl(uffd, UFFDIO_COPY, &uffd_copy);
+	TEST_ASSERT(ret != -1, "ioctl(UFFDIO_COPY) should succeed");
+
+	/* Wait for the faulting thread to complete - this provides the memory barrier */
+	ret = pthread_join(fault_thread, NULL);
+	TEST_ASSERT(ret == 0, "pthread_join should succeed");
+
+	/*
+	 * Now it's safe to check args.value - the thread has completed
+	 * and memory is synchronized
+	 */
+	TEST_ASSERT(args.value == test_val,
+		    "memory should contain the value that was copied");
+	TEST_ASSERT(*(char *)(mem + offset) == test_val,
+		    "no further fault is expected");
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
@@ -494,8 +570,10 @@ static void __test_guest_memfd(struct kv
 	gmem_test(fallocate, vm, flags);
 	gmem_test(invalid_punch_hole, vm, flags);
 
-	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		gmem_test(uffd_minor, vm, flags);
+		gmem_test(uffd_missing, vm, flags);
+	}
 }
 
 static void test_guest_memfd(unsigned long vm_type)
_

Patches currently in -mm which might be from kalyazin@amazon.com are

kvm-guest_memfd-implement-userfaultfd-operations.patch
kvm-selftests-test-userfaultfd-minor-for-guest_memfd.patch
kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

