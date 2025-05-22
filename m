Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01353188713
	for <mm-commits@vger.kernel.org>; Thu, 22 May 2025 20:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946609; cv=none; b=dh5RJnpCn6JdX/tsaZBLGCknbozv1YfwWzlnNYVtvS2dafRdtUPgzF8Y3iprti91eqXwVmyRxOj3eJIotnl37v/Xp+XR7znBJjzDuMgjAtQfy63Y/CtLX7A6/CDnhnm7NK/PdFZUqJpJIfHh6I4ZmTIU6KZMLCgj4yyGQZowfz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946609; c=relaxed/simple;
	bh=3xjvJk28uQO2o56DkvYtMfYONnkmRy8j+goeAFLuhA4=;
	h=Date:To:From:Subject:Message-Id; b=Six8g7/3mc4WSIg1zpsoz6HWyWjOS1xydTIKE+NvvBtEJMWGt3SDzU78bvQXoPTZSU9Mou8A7huGG8lnsrPuCMFUbDMMHoA4F0v0x8am6x9D7EXLSt2vXPfHnAbxfxXCveFygdee2JqK++8TUJYdRgy1pTS1GjShgf1JmZnjiK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HoV1P4hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HoV1P4hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E42C4CEE4;
	Thu, 22 May 2025 20:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747946608;
	bh=3xjvJk28uQO2o56DkvYtMfYONnkmRy8j+goeAFLuhA4=;
	h=Date:To:From:Subject:From;
	b=HoV1P4hDKDvgSckfts85KYcrAlTRTQ59Rv09gacYUooaFt6C5r3zv8AzsMb0CIGyv
	 i6FdIEnmeBN5Gifz813hcH9eBdnwUNZwdjZBXCg3Ll56WsdIwiv3b9ZAwWvws2XupN
	 +33lbi1VFmK3al7lQyQn7wGdGtLr8s/mcCCZkDS8=
Date: Thu, 22 May 2025 13:43:27 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-mm-add-helper-for-logging-test-start-and-results.patch added to mm-new branch
Message-Id: <20250522204328.25E42C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/mm: add helper for logging test start and results
has been added to the -mm mm-new branch.  Its filename is
     selftest-mm-add-helper-for-logging-test-start-and-results.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-mm-add-helper-for-logging-test-start-and-results.patch

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
From: Mark Brown <broonie@kernel.org>
Subject: selftest/mm: add helper for logging test start and results
Date: Thu, 22 May 2025 18:38:51 +0100

Several of the MM tests have a pattern of printing a description of the
test to be run then reporting the actual TAP result using a generic string
not connected to the specific test, often in a shared function used by
many tests.  The name reported typically varies depending on the specific
result rather than the test too.  This causes problems for tooling that
works with test results, the names reported with the results are used to
deduplicate tests and track them between runs so both duplicated names and
changing names cause trouble for things like UIs and automated bisection.

As a first step towards matching these tests better with the expectations
of kselftest provide helpers which record the test name as part of the
initial print and then use that as part of reporting a result.

This is not added as a generic kselftest helper partly because the use of
a variable to store the test name doesn't fit well with the header only
implementation of kselftest.h and partly because it's not really an
intended pattern.  Ideally at some point the mm tests that use it will be
updated to not need it.

Link: https://lkml.kernel.org/r/20250522-selftests-mm-cow-dedupe-v1-2-713cee2fdd6d@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.h~selftest-mm-add-helper-for-logging-test-start-and-results
+++ a/tools/testing/selftests/mm/vm_util.h
@@ -3,6 +3,7 @@
 #include <stdbool.h>
 #include <sys/mman.h>
 #include <err.h>
+#include <stdarg.h>
 #include <strings.h> /* ffsl() */
 #include <unistd.h> /* _SC_PAGESIZE */
 #include "../kselftest.h"
@@ -95,6 +96,25 @@ static inline int open_self_procmap(stru
 	return open_procmap(pid, procmap_out);
 }
 
+/* These helpers need to be inline to match the kselftest.h idiom. */
+static char test_name[1024];
+
+static inline void log_test_start(const char *name, ...)
+{
+	va_list args;
+	va_start(args, name);
+
+	vsnprintf(test_name, sizeof(test_name), name, args);
+	ksft_print_msg("[RUN] %s\n", test_name);
+
+	va_end(args);
+}
+
+static inline void log_test_result(int result)
+{
+	ksft_test_result_report(result, "%s\n", test_name);
+}
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-mm-deduplicate-test-logging-in-test_mlock_lock.patch
selftests-mm-deduplicate-default-page-size-test-results-in-thuge-gen.patch
selftests-mm-use-standard-ksft_finished-in-cow-and-gup_longterm.patch
selftest-mm-add-helper-for-logging-test-start-and-results.patch
selftests-mm-report-unique-test-names-for-each-cow-test.patch
selftests-mm-fix-test-result-reporting-in-gup_longterm.patch

