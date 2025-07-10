Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66A7285CB3
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126363; cv=none; b=LWMUVdffiH18pYq6fQg27UH1ALQ6F75z2CpZWdkTV8u3VHvJxdnnmdI8S8jLXyOYwytJVr/5QpR/blpwS5PCLOEzRNcCGaj0VokHu3oUtrZI8Tek6ytP6NBwei2JCLhAUSmqGXJPyYk+00Kfs0F94dAHTtaSgrsOlctfyIqJdCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126363; c=relaxed/simple;
	bh=fR92lec+25WbOdwvK20fMAzrZapC3l8e5gRWtsvcs7k=;
	h=Date:To:From:Subject:Message-Id; b=NPjdOFB5KCYA18v0RM0jhVwX/O98xkw5d0/GLJ8rnlagpI7/7SkGvglcJoabUMdnwlkemzIuAt8d/X+p2FWZXOGnqm0M0hCn01P4PmvzqofodaY7vFDSLmsrWtrkBjENu/rMckMLDo4q7Vbo1pIRRZjH4Y/JhP6SGojLdxiGfNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v5aDOumW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v5aDOumW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA470C4CEE3;
	Thu, 10 Jul 2025 05:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126362;
	bh=fR92lec+25WbOdwvK20fMAzrZapC3l8e5gRWtsvcs7k=;
	h=Date:To:From:Subject:From;
	b=v5aDOumWtj4keovF0pnHXjkdFQ7mFJ4tH0cPcQMcLErNaCst2p8O5MdbMWQ9NcGiY
	 JDVEKa9jjq4BGLn8H1RtM4grEIpAmyP9Ctem38Z+JwvPaPpzLq+AM/fA+i4zSFOFKV
	 6nHKLN1wdzlDjkEB5SnIkwb6cDoDV8LhbNIkSFqU=
Date: Wed, 09 Jul 2025 22:46:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jackmanb@google.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch removed from -mm tree
Message-Id: <20250710054602.BA470C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: reduce uffd-unit-test poison test to minimum
has been removed from the -mm tree.  Its filename was
     selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: reduce uffd-unit-test poison test to minimum
Date: Fri, 20 Jun 2025 11:00:58 -0400

The test will still generate quite some unwanted MCE error messages to
syslog.  There was old proposal ratelimiting the MCE messages from kernel,
but that has risk of hiding real useful information on production systems.

We can at least reduce the test to minimum to not over-pollute dmesg,
however trying to not lose its coverage too much.

[peterx@redhat.com: reduce uffd-unit-test poison test to minimum]
  Link: https://lkml.kernel.org/r/aF2RSsjuEOtzXcUa@x1.local
Link: https://lkml.kernel.org/r/20250620150058.1729489-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   20 +++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1027,6 +1027,9 @@ static void uffd_poison_handle_fault(
 		do_uffdio_poison(uffd, offset);
 }
 
+/* Make sure to cover odd/even, and minimum duplications */
+#define  UFFD_POISON_TEST_NPAGES  4
+
 static void uffd_poison_test(uffd_test_args_t *targs)
 {
 	pthread_t uffd_mon;
@@ -1034,12 +1037,17 @@ static void uffd_poison_test(uffd_test_a
 	struct uffd_args args = { 0 };
 	struct sigaction act = { 0 };
 	unsigned long nr_sigbus = 0;
-	unsigned long nr;
+	unsigned long nr, poison_pages = UFFD_POISON_TEST_NPAGES;
+
+	if (nr_pages < poison_pages) {
+		uffd_test_skip("Too few pages for POISON test");
+		return;
+	}
 
 	fcntl(uffd, F_SETFL, uffd_flags | O_NONBLOCK);
 
-	uffd_register_poison(uffd, area_dst, nr_pages * page_size);
-	memset(area_src, 0, nr_pages * page_size);
+	uffd_register_poison(uffd, area_dst, poison_pages * page_size);
+	memset(area_src, 0, poison_pages * page_size);
 
 	args.handle_fault = uffd_poison_handle_fault;
 	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
@@ -1051,7 +1059,7 @@ static void uffd_poison_test(uffd_test_a
 	if (sigaction(SIGBUS, &act, 0))
 		err("sigaction");
 
-	for (nr = 0; nr < nr_pages; ++nr) {
+	for (nr = 0; nr < poison_pages; ++nr) {
 		unsigned long offset = nr * page_size;
 		const char *bytes = (const char *) area_dst + offset;
 		const char *i;
@@ -1078,9 +1086,9 @@ static void uffd_poison_test(uffd_test_a
 	if (pthread_join(uffd_mon, NULL))
 		err("pthread_join()");
 
-	if (nr_sigbus != nr_pages / 2)
+	if (nr_sigbus != poison_pages / 2)
 		err("expected to receive %lu SIGBUS, actually received %lu",
-		    nr_pages / 2, nr_sigbus);
+		    poison_pages / 2, nr_sigbus);
 
 	uffd_test_pass();
 }
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-remove-prepare_hugepage_range.patch
mm-deduplicate-mm_get_unmapped_area.patch

