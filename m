Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815490;
	b=TTvKXALHvrmBI94+molY6M9ELcoFIKnxy5LVuD+eIagqZQ45CZvLXPrVKnqCjnwC9bhz
	 m/XVu1+EsaIsrRfNMdINr4B21kMZm9MzsdFLkSIgVYALGRZicKOP05z8DCPX1v6DLzi+Z
	 GaFXIAIDDhB7URequH7ztCvM9zgBBXoPI83vsosyNgztCSCxaHygtrc+J4w2OThKcKUpx
	 BZ+zC0+yWAAWxWv5Vbuvx5REUA2xnIZY1cBmHF5kknkWfSICjC1YjJKrqR1A6AsN1Y8ja
	 cppMyGaVttRLStv/AlQwvAfgtDECTJSUox4QM9NYr1sugN0iPI0dBP3mvuSJYBowTSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815490;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=x0RK0i2ecxvXCIRfCUEzAbc0noFOpj+t4EyOv49gueA=;
	b=AcUhHG2Sef4LrZGxuu8s8srOZSyr/zl31YpMO+weaCBApGvQWl45TIuFpfYZkkLLt/1k
	 e/tTc2wVAX+NmieABl3ybUyN9NgRqJoOb2RS4crNwJVX3R6rN5XXAOkp1R4HQ2011mT3B
	 oh1rVnBzzD14MBmQ+hKkD7MbXqTNaW4lCCIks+d68McJdl5ynf5JOsAlplI3buvO6I10P
	 YkOASAuiii3By31sxsOWPPk4WsxeinIH9HsSxxNgFQqXukM5MczsF9oCN1QAcUdiMGRsc
	 pReprQcavGg0jAUOF0VUXgpQAH7QW5rYX2YrB6Y3snGB0DaIXSGpNtqwOunKQqqoP+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NECdakEG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2E1606A69F
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NECdakEG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB041F000C1;
	Wed,  4 Nov 2026 18:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793815490;
	bh=x0RK0i2ecxvXCIRfCUEzAbc0noFOpj+t4EyOv49gueA=;
	h=Date:To:From:Subject;
	b=NECdakEGT0NufCcj3tr4vwO0O1lTUELhzXqgL1dXMNSZ0ulD2TwuVuTgWbq6G2D2I
	 /Vgx/L3qezweCEfolF6P4J0xg6DIHQZ7anef+4h5EFHzxBZJQTAakjI1m14+l1nI3w
	 q1oBcj2SfRH7P4U1vvn9Z2JwC4ZAnvg+Coxl+Jfo=
Date: Wed, 04 Nov 2026 10:04:49 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,
	muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	david@kernel.org,azpijr@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch added to mm-new branch
Message-Id: <20261104180450.0AB041F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch

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
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: selftests/mm: add a uffd test for re-registering during UFFDIO_COPY
Date: Tue, 03 Nov 2026 11:28:36 +0100

Re-register the destination without WP while a UFFDIO_COPY_MODE_WP copy
waits for its source page, then check that the copy fails with -EINVAL
and leaves no uffd-wp bit behind. This covers all memory types.

Link: https://lore.kernel.org/20261103102840.68903-3-azpijr@gmail.com
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |  105 +++++++++++++++++
 1 file changed, 105 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uff
 	uffd_test_pass();
 }
 
+struct wp_copy_args {
+	uffd_global_test_opts_t *gopts;
+	char *src;
+	__s64 result;
+};
+
+static void *wp_copy_thread(void *data)
+{
+	struct wp_copy_args *args = data;
+	struct uffdio_copy copy = {
+		.dst = (unsigned long)args->gopts->area_dst,
+		.src = (unsigned long)args->src,
+		.len = args->gopts->page_size,
+		.mode = UFFDIO_COPY_MODE_WP,
+	};
+
+	ioctl(args->gopts->uffd, UFFDIO_COPY, &copy);
+	args->result = copy.copy;
+
+	return NULL;
+}
+
+/*
+ * UFFDIO_COPY drops its locks to fault in the source page.  Re-register the
+ * destination without WP while it waits there: the MODE_WP copy must then
+ * fail instead of leaving a uffd-wp bit in a VMA that no longer has WP.
+ */
+static void uffd_wp_copy_reregister_test(uffd_global_test_opts_t *gopts,
+					 uffd_test_args_t *args)
+{
+	struct uffdio_api api = { .api = UFFD_API };
+	struct wp_copy_args copy_args = { .gopts = gopts };
+	unsigned long len = gopts->page_size;
+	struct uffdio_zeropage zeropage;
+	struct uffd_msg msg;
+	struct pollfd pfd;
+	pthread_t thread;
+	uint64_t value;
+	int pagemap_fd;
+	int src_uffd;
+
+	/* The source fault comes from the kernel, so no UFFD_USER_MODE_ONLY */
+	src_uffd = uffd_open(UFFD_FLAGS & ~UFFD_USER_MODE_ONLY);
+	if (src_uffd < 0) {
+		uffd_test_skip("cannot open a kernel-mode userfaultfd");
+		return;
+	}
+	if (ioctl(src_uffd, UFFDIO_API, &api))
+		err("UFFDIO_API failed");
+
+	copy_args.src = mmap(NULL, len, PROT_READ | PROT_WRITE,
+			     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (copy_args.src == MAP_FAILED)
+		err("mmap() failed");
+
+	if (uffd_register(src_uffd, copy_args.src, len, true, false, false))
+		err("register src failed");
+	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, true, false))
+		err("register dst failed");
+
+	if (pthread_create(&thread, NULL, wp_copy_thread, &copy_args))
+		err("pthread_create() failed");
+
+	/* Wait until UFFDIO_COPY blocks on the source page */
+	pfd = (struct pollfd){ .fd = src_uffd, .events = POLLIN };
+	if (poll(&pfd, 1, 10000) != 1 || !(pfd.revents & POLLIN))
+		err("no fault on the source page");
+	if (read(src_uffd, &msg, sizeof(msg)) != sizeof(msg))
+		err("read() failed");
+
+	if (uffd_unregister(gopts->uffd, gopts->area_dst, len))
+		err("unregister dst failed");
+	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, false, false))
+		err("re-register dst failed");
+
+	zeropage.range.start = (unsigned long)copy_args.src;
+	zeropage.range.len = len;
+	zeropage.mode = 0;
+	if (ioctl(src_uffd, UFFDIO_ZEROPAGE, &zeropage))
+		err("UFFDIO_ZEROPAGE failed");
+
+	if (pthread_join(thread, NULL))
+		err("pthread_join() failed");
+
+	if (copy_args.result != -EINVAL)
+		err("UFFDIO_COPY returned %lld, expected %d",
+		    (long long)copy_args.result, -EINVAL);
+
+	pagemap_fd = pagemap_open();
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	pagemap_check_wp(value, false);
+	close(pagemap_fd);
+
+	munmap(copy_args.src, len);
+	close(src_uffd);
+	uffd_test_pass();
+}
+
 static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_args_t *args,
 				     bool with_event)
 {
@@ -2404,6 +2502,13 @@ uffd_test_case_t uffd_tests[] = {
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
 	},
 	{
+		.name = "wp-copy-reregister",
+		.uffd_fn = uffd_wp_copy_reregister_test,
+		.mem_targets = MEM_ALL,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM,
+	},
+	{
 		.name = "minor",
 		.uffd_fn = uffd_minor_test,
 		.mem_targets = MEM_SHMEM | MEM_HUGETLB,
_

Patches currently in -mm which might be from azpijr@gmail.com are

mm-userfaultfd-recheck-wp-registration-in-the-hugetlb-uffdio_copy-retry.patch
selftests-mm-add-a-uffd-test-for-re-registering-during-uffdio_copy.patch

