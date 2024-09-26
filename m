Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811D617C9E7
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381492; cv=none; b=rBf7NApT/ELtZdaPBwUbAMOSQH5Gm8/qi4KJw+qphX1rJdEYJDJ5gGM0gtZAEJClvONX9l+lW5GNBkgtDqdjLCz3+f/Dy6fOLwp+qqja6KjQk/drtfHLKYT9JuhIqeW21xLPQqqfWxjQ4y8kFmn5JAAZEASzNkXc/Kp9xUOn3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381492; c=relaxed/simple;
	bh=dQPewiDXIXPcLKXqmXmpnkCN8CkS/X8bny40wW2oZ54=;
	h=Date:To:From:Subject:Message-Id; b=ODvE0OTEuxbik20336DW2LL52Wk7tlswWilP/1ge40g/4qbRLcMHiJnJ46Smhb5rztwDtShq5h1GSTntt0tKJWAesJMJDVodFSxCkGwDfyVkmSHBJ7bDZluJd3CLL0qAwPQ3wsjrn4whE52ZgmBHOqM892KeRKxxffO2oYTeFZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gI4lVFUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gI4lVFUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1694C4CEC5;
	Thu, 26 Sep 2024 20:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727381492;
	bh=dQPewiDXIXPcLKXqmXmpnkCN8CkS/X8bny40wW2oZ54=;
	h=Date:To:From:Subject:From;
	b=gI4lVFUbgBRqDkglnwwu7QSiLEWT/uGWMbmhOaJUGbFYVOd74asMqH8NPOUUe2iOp
	 U5HG2KPYy3icPwMRG2XakZWIF6mb1G+tTqfO0rZcscAEwklI0iyaxblQ1lBFLMVprR
	 w5x1TQMhFyjJldNhqwsSHdiAbr/GNvhFXv+LH1M0=
Date: Thu, 26 Sep 2024 13:11:30 -0700
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,shuah@kernel.org,mcasquer@redhat.com,leitao@debian.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch added to mm-unstable branch
Message-Id: <20240926201131.F1694C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: hugetlb_fault_after_madv: improve test output
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: hugetlb_fault_after_madv: improve test output
Date: Thu, 26 Sep 2024 17:20:44 +0200

Let's improve the test output.  For example, print the proper test result.
Install a SIGBUS handler to catch any SIGBUS instead of crashing the test
on failure.

With unsuitable hugetlb page count:
  $ ./hugetlb_fault_after_madv
  TAP version 13
  1..1
  # [INFO] detected default hugetlb page size: 2048 KiB
  ok 2 # SKIP This test needs one and only one page to execute. Got 0
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

On a failure:
  $ ./hugetlb_fault_after_madv
  TAP version 13
  1..1
  not ok 1 SIGBUS behavior
  Bail out! 1 out of 1 tests failed

On success:
  $ ./hugetlb_fault_after_madv
  TAP version 13
  1..1
  # [INFO] detected default hugetlb page size: 2048 KiB
  ok 1 SIGBUS behavior
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Link: https://lkml.kernel.org/r/20240926152044.2205129-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Mario Casquero <mcasquer@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_fault_after_madv.c |   34 +++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c~selftests-mm-hugetlb_fault_after_madv-improve-test-output
+++ a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -5,6 +5,8 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <unistd.h>
+#include <setjmp.h>
+#include <signal.h>
 
 #include "vm_util.h"
 #include "../kselftest.h"
@@ -14,11 +16,25 @@
 static char *huge_ptr;
 static size_t huge_page_size;
 
+static sigjmp_buf sigbuf;
+static bool sigbus_triggered;
+
+static void signal_handler(int signal)
+{
+	if (signal == SIGBUS) {
+		sigbus_triggered = true;
+		siglongjmp(sigbuf, 1);
+	}
+}
+
 /* Touch the memory while it is being madvised() */
 void *touch(void *unused)
 {
 	char *ptr = (char *)huge_ptr;
 
+	if (sigsetjmp(sigbuf, 1))
+		return NULL;
+
 	for (int i = 0; i < INLOOP_ITER; i++)
 		ptr[0] = '.';
 
@@ -44,13 +60,23 @@ int main(void)
 	 * interactions
 	 */
 	int max = 10000;
+	int err;
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	srand(getpid());
 
+	if (signal(SIGBUS, signal_handler) == SIG_ERR)
+		ksft_exit_skip("Could not register signal handler.");
+
 	huge_page_size = default_huge_page_size();
 	if (!huge_page_size)
 		ksft_exit_skip("Could not detect default hugetlb page size.");
 
+	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
+		       huge_page_size / 1024);
+
 	free_hugepages = get_free_hugepages();
 	if (free_hugepages != 1) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
@@ -73,5 +99,11 @@ int main(void)
 		munmap(huge_ptr, huge_page_size);
 	}
 
-	return KSFT_PASS;
+	ksft_test_result(!sigbus_triggered, "SIGBUS behavior\n");
+
+	err = ksft_get_fail_cnt();
+	if (err)
+		ksft_exit_fail_msg("%d out of %d tests failed\n",
+				   err, ksft_test_num());
+	ksft_exit_pass();
 }
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

