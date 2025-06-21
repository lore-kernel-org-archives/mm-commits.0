Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B8215CD74
	for <mm-commits@vger.kernel.org>; Sat, 21 Jun 2025 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750532783; cv=none; b=U+5mz8a+QGREPUJAIcM3N5aJQS8TRlAHD2eOtR83SjU4Lp8ZZFd83EQEBBjtlP7l3Nn5BFsII0LXSKNjWCTqK+7UYrSbCzEVSbT+FA3+AVmYmOTkabagiGQedIx1UqOVf6sGa/mbAfgha0DMBThH13vjo8nXqKSzt7sG6JiXO00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750532783; c=relaxed/simple;
	bh=k3ilYMnKnCdSii3u8R32N3aGAgbQ+XD7T9HYGoM6Eb4=;
	h=Date:To:From:Subject:Message-Id; b=rFo7i1xRo+4uryEn1qsNFqOk3cOZSLuq0qrzUXtGnqClitlue+07k2faAdzSRAy4nX4M+Qa7PTh0VGMPgv8yyghWq4uf055U9JDdp8pzjur5BP51aXi8AtGxJiawiMS85RF7o8kUB96b3SC/a38lcawlrWNbtJIDLeAxeWjmJLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2WUGVmTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2WUGVmTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EFDC4CEE7;
	Sat, 21 Jun 2025 19:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750532783;
	bh=k3ilYMnKnCdSii3u8R32N3aGAgbQ+XD7T9HYGoM6Eb4=;
	h=Date:To:From:Subject:From;
	b=2WUGVmTX1b9gbf21D7muBIZ7G276XVR/kUCu3yibwJGV3patAxL3gtfqIAmkvaF/M
	 E8J4gbPEePbJCLqINSQrk12KlaW1+/nqcA3T9iNivGEqvRKaj9e6oLMm68ddbLloNB
	 wsAnV4b1aUPQzVPD3ts5YGNfo93dx+/Bi4xoogX0=
Date: Sat, 21 Jun 2025 12:06:22 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,jackmanb@google.com,david@redhat.com,axelrasmussen@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch added to mm-new branch
Message-Id: <20250621190622.E3EFDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: reduce uffd-unit-test poison test to minimum
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: reduce uffd-unit-test poison test to minimum
Date: Fri, 20 Jun 2025 11:00:58 -0400

The test will still generate quite some unwanted MCE error messages to
syslog.  There was old proposal ratelimiting the MCE messages from kernel,
but that has risk of hiding real useful information on production systems.

We can at least reduce the test to minimum to not over-pollute dmesg,
however trying to not lose its coverage too much.

Link: https://lkml.kernel.org/r/20250620150058.1729489-1-peterx@redhat.com
Cc: Axel Rasmussen <axelrasmussen@google.com>
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
+		uffd_test_skip("Too less pages for POISON test");
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

selftests-mm-reduce-uffd-unit-test-poison-test-to-minimum.patch

