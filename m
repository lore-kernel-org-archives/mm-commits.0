Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA06917BD3
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 02:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714012514; cv=none; b=nF2FvpoTeWfS/rizS/SXlLST5wv5BDjMcM2Gay8ROpVJbNqOTFyho/COdDY5IH3MeKXoXJGc2sHLMrfdqz7jTeHNojw9g7jRSFkMzGI6g2yW38DaVEjuOM4HmGUD1y+gcCeDEeesCIBHAwGDA9Cf60UHzEKEd4xhd4n7pbFlZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714012514; c=relaxed/simple;
	bh=asHESZVzKhGqrhYWZhCILEriz0s/c6OIfzGG3/xH2eg=;
	h=Date:To:From:Subject:Message-Id; b=I+vedmY2ifnk5G6r94BiYSy7zaGDUEgZ0M33qviHYal/QeuJ5TxesBVvwJsZ9NfcwhiH73QxtK0/1n1EwxIetEqUWNH3gm7UGZNDJFnkLCPkpzv01X258cTSqIPBT0mYivvG39ZyEtXzj6uUksZjhqLT2WekSC4nmAPCNvEGXCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+Z0WRQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+Z0WRQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DEDC113CD;
	Thu, 25 Apr 2024 02:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714012514;
	bh=asHESZVzKhGqrhYWZhCILEriz0s/c6OIfzGG3/xH2eg=;
	h=Date:To:From:Subject:From;
	b=j+Z0WRQj7txg48XEdTRYwcPyqiEnCWAe799qEaY+U0YJK3TkWfbHek5tRwtfvC3Le
	 zUG/rholnmiJiIZbuyO4qVlJayIB4QM0f8cM11eAVGGFz8WaWLIICHqVrXXgM7IefM
	 ZVTuZqdTBbjrvUJ3Y5A4dErKikY/E++vNRA5NDlw=
Date: Wed, 24 Apr 2024 19:35:13 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,usama.anjum@collabora.com,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,david@redhat.com,axelrasmussen@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-harness-remove-use-of-line_max.patch removed from -mm tree
Message-Id: <20240425023514.11DEDC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/harness: remove use of LINE_MAX
has been removed from the -mm tree.  Its filename was
     selftests-harness-remove-use-of-line_max.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Edward Liaw <edliaw@google.com>
Subject: selftests/harness: remove use of LINE_MAX
Date: Thu, 11 Apr 2024 23:19:49 +0000

Android was seeing a compliation error because its C library does not
define LINE_MAX.  This replaces the use of LINE_MAX / snprintf with
asprintf, which will change the behavior to not truncate the test name if
it is over 2048 chars long.

See also:
https://github.com/llvm/llvm-project/issues/88119

[akpm@linux-foundation.org: remove limits.h include, per Edward]
[akpm@linux-foundation.org: check asprintf() return]
[usama.anjum@collabora.com: fix undeclared function error]
  Link: https://lkml.kernel.org/r/20240417075530.3807625-1-usama.anjum@collabora.com
Link: https://lkml.kernel.org/r/20240411231954.62156-1-edliaw@google.com
Fixes: 38c957f07038 ("selftests: kselftest_harness: generate test name once")
Signed-off-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Edward Liaw <edliaw@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |   12 ++++++++----
 tools/testing/selftests/mm/mdwe_test.c      |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-remove-use-of-line_max
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -56,7 +56,6 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -1156,7 +1155,7 @@ void __run_test(struct __fixture_metadat
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char test_name[LINE_MAX];
+	char *test_name;
 	const char *diagnostic;
 
 	/* reset test struct */
@@ -1164,8 +1163,12 @@ void __run_test(struct __fixture_metadat
 	t->trigger = 0;
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-	snprintf(test_name, sizeof(test_name), "%s%s%s.%s",
-		 f->name, variant->name[0] ? "." : "", variant->name, t->name);
+	if (asprintf(&test_name, "%s%s%s.%s", f->name,
+		variant->name[0] ? "." : "", variant->name, t->name) == -1) {
+		ksft_print_msg("ERROR ALLOCATING MEMORY\n");
+		t->exit_code = KSFT_FAIL;
+		_exit(t->exit_code);
+	}
 
 	ksft_print_msg(" RUN           %s ...\n", test_name);
 
@@ -1203,6 +1206,7 @@ void __run_test(struct __fixture_metadat
 
 	ksft_test_result_code(t->exit_code, test_name,
 			      diagnostic ? "%s" : "", diagnostic);
+	free(test_name);
 }
 
 static int test_harness_run(int argc, char **argv)
--- a/tools/testing/selftests/mm/mdwe_test.c~selftests-harness-remove-use-of-line_max
+++ a/tools/testing/selftests/mm/mdwe_test.c
@@ -7,6 +7,7 @@
 #include <linux/mman.h>
 #include <linux/prctl.h>
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/auxv.h>
_

Patches currently in -mm which might be from edliaw@google.com are


