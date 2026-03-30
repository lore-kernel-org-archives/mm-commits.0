Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73F239769F
	for <mm-commits@vger.kernel.org>; Mon, 30 Mar 2026 19:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899256; cv=none; b=ImG8A7y12MENUYVFqOvm1XwLc2OudcrzA/zlZXRGlSEXEH8RB5I0gaxMMyrMV3BIJraC/fcafwod4QwDHAehsnK15nYLP3Gn9rGgpkerjDo+XX0Bra3dygYWlkYY0M3Ikx/ubr9a54eJ+4ziBk08MfKsBQs9MpGgov9JN73gve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899256; c=relaxed/simple;
	bh=30y8VeajH5oxqO0OW/6WjXCjpQpbPEFx2WcHqYv4GJI=;
	h=Date:To:From:Subject:Message-Id; b=ltShoh7e8i5qv4OgM6iEXGBrjf4KUmFOjHiLJHrhCd5lHuZwQP8q7ZOCyOQEEGQvkhh48p58tUZ6QxxCdD6zIaajzyvP4fywe8DduGX/UyY4WQLjssNJ5wUAcu5KhxzqnzOmW8AuYO90bjHhlLU0hJhvtQ0JOag6SmyRCdE28ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pIylqTF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pIylqTF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C8C4CEF7;
	Mon, 30 Mar 2026 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774899255;
	bh=30y8VeajH5oxqO0OW/6WjXCjpQpbPEFx2WcHqYv4GJI=;
	h=Date:To:From:Subject:From;
	b=pIylqTF4gMwLc2l9jaa2hq4KfA8M81lPOVu5KPKmU5b4skISbBSpfmV8ktAPHxgkw
	 O+nb2+Bn5LKx4NXJLf+zqgO/Tn45+Fb0WYUWHU7VeJ9U9dlL7RwjNtSwon6HP0twTp
	 DIPnqVtIg9gVA5G8vLfw7UWW1TeIWPiPpvNpavrs=
Date: Mon, 30 Mar 2026 12:34:15 -0700
To: mm-commits@vger.kernel.org,kalyazin@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch removed from -mm tree
Message-Id: <20260330193415.969C8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: selftests: test userfaultfd missing for guest_memfd
has been removed from the -mm tree.  Its filename was
     kvm-selftests-test-userfaultfd-missing-for-guest_memfd.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nikita Kalyazin <kalyazin@amazon.com>
Subject: KVM: selftests: test userfaultfd missing for guest_memfd
Date: Fri, 6 Mar 2026 19:18:15 +0200

The test demonstrates that a missing userfaultfd event in guest_memfd can
be resolved via a UFFDIO_COPY ioctl.

Link: https://lkml.kernel.org/r/20260306171815.3160826-16-rppt@kernel.org
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@kernel.org>
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


