Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88B116D4E6
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756866; cv=none; b=ZJS8fImG/Mh7oy1Rq/twFSxsdXqmfv5h0pGPqc+CFz3ATNcJzKmmyXgYjYQsY+5EvXnGrKb27L0l0Dyc6gfYM61c8Tb4Q397oAsITEhwCLH0fRzafF5Chjk7iye1oFPWQ8HeMEd+3QePAqHS0iSdXGfWmydraO7PQi7Qo9Eg3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756866; c=relaxed/simple;
	bh=zdqBx9XgyUtjT9VGQ8c6qJvrHBmDuv9I174nYdj9fKg=;
	h=Date:To:From:Subject:Message-Id; b=YkhzEYqgiCXQ15w73+rttI6eZyGi1hSUqYLWZTx+MUw8knGLH8/6lSvYzXaGG2oVuD1+C3HB2CU1aRLj5HNTdW2d8lD7za5oweT2LGkE1d9Q2k8Lq/VUwld5FNu22otuOnHLzxYhFDL+E3mN/zpoHqA/1E2HtoB5swwnmPxJCeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A3ut9TMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A3ut9TMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC48C4CEF0;
	Sun,  1 Jun 2025 05:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756866;
	bh=zdqBx9XgyUtjT9VGQ8c6qJvrHBmDuv9I174nYdj9fKg=;
	h=Date:To:From:Subject:From;
	b=A3ut9TMTet/MozqIPnqqxpu3C/kcNmDvWbN+7LmD8Px8do05j+zR4IcrkOtPxM7SV
	 3V6LU/ZcMJopeHW1LOlXJl9h/ZB9YWTvMiZE8FL82IpjUjJgwd6GFEDkK+0sULn2Pp
	 xVcQp3aVDT5+s9cOQ0KWKo0ktpPDSv0MlNlxCgnA=
Date: Sat, 31 May 2025 22:47:46 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-add-helper-for-logging-test-start-and-results.patch removed from -mm tree
Message-Id: <20250601054746.9CC48C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add helper for logging test start and results
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-helper-for-logging-test-start-and-results.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: add helper for logging test start and results
Date: Tue, 27 May 2025 17:04:46 +0100

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

Link: https://lkml.kernel.org/r/20250527-selftests-mm-cow-dedupe-v2-2-ff198df8e38e@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/vm_util.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/tools/testing/selftests/mm/vm_util.h~selftests-mm-add-helper-for-logging-test-start-and-results
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


