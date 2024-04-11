Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299CF47F6F
	for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2024 23:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878463; cv=none; b=jjpUnqZ4pI8znI58DdmioB1+IayLec03GuiF0I5Zd03pxzsVNwwYKlrvPZ1yW3FLQ3RDun+Bw1iSfLbMgvQ5K5KOufbvnIgNqTcVycT4+20a9my7Qo69wdyn98WlYi6oXM96KQ6lQecwsu1IWekf/lOXMj8+BT4cBv4Uz1dPY+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878463; c=relaxed/simple;
	bh=ySCNG/ByHcOmo6oZCylARnEw5lOvwTRwzi2QZnbefok=;
	h=Date:To:From:Subject:Message-Id; b=G6mPcWTsuFc0KqdspfBNm4t97P+PxiEZ5b5wq5eAghLey0IQOA2LC/Z2MjyNqlCp+gkVy15CahYpP5bBfU58k6EK35hmOp/aV3tm0jlnSHiZvyOdJIytT8iz6ghaTFD1IU/7zafTcC3hYTECfkuZK6S+DQnhWLFodNAVhiechaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EbJsmrtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EbJsmrtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC95FC072AA;
	Thu, 11 Apr 2024 23:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712878462;
	bh=ySCNG/ByHcOmo6oZCylARnEw5lOvwTRwzi2QZnbefok=;
	h=Date:To:From:Subject:From;
	b=EbJsmrtx+ELi88v6bVoF1/9j1lQfWfC73oVaw+7beikDrWESzVdT+eTBveQKPqiPr
	 Zmbvt93wwyfYzQmgwXqJ29Kg2Jo+QoN0yJ2E8QreL3ipSSfzpBDULzLcGrkHidqDhT
	 fLGTKM0AQ4ICULANUp+y1z2EgAscRA2Kz4lNUPHw=
Date: Thu, 11 Apr 2024 16:34:22 -0700
To: mm-commits@vger.kernel.org,wad@chromium.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,luto@amacapital.net,keescook@chromium.org,justinstitt@google.com,david@redhat.com,axelrasmussen@google.com,edliaw@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-harness-remove-use-of-line_max.patch added to mm-hotfixes-unstable branch
Message-Id: <20240411233422.AC95FC072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/harness: remove use of LINE_MAX
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-harness-remove-use-of-line_max.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-harness-remove-use-of-line_max.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Edward Liaw <edliaw@google.com>
Subject: selftests/harness: remove use of LINE_MAX
Date: Thu, 11 Apr 2024 23:19:49 +0000

Android was seeing a compliation error because its C library does not
define LINE_MAX.  This replaces the use of LINE_MAX / snprintf with
asprintf, which will change the behavior to not truncate the test name if
it is over 2048 chars long.

See also:
https://github.com/llvm/llvm-project/issues/88119

Link: https://lkml.kernel.org/r/20240411231954.62156-1-edliaw@google.com
Fixes: 38c957f07038 ("selftests: kselftest_harness: generate test name once")
Signed-off-by: Edward Liaw <edliaw@google.com>
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

 tools/testing/selftests/kselftest_harness.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-remove-use-of-line_max
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -1156,7 +1156,7 @@ void __run_test(struct __fixture_metadat
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char test_name[LINE_MAX];
+	char *test_name;
 	const char *diagnostic;
 
 	/* reset test struct */
@@ -1164,8 +1164,8 @@ void __run_test(struct __fixture_metadat
 	t->trigger = 0;
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-	snprintf(test_name, sizeof(test_name), "%s%s%s.%s",
-		 f->name, variant->name[0] ? "." : "", variant->name, t->name);
+	asprintf(&test_name, "%s%s%s.%s", f->name,
+	         variant->name[0] ? "." : "", variant->name, t->name);
 
 	ksft_print_msg(" RUN           %s ...\n", test_name);
 
@@ -1203,6 +1203,7 @@ void __run_test(struct __fixture_metadat
 
 	ksft_test_result_code(t->exit_code, test_name,
 			      diagnostic ? "%s" : "", diagnostic);
+	free(test_name);
 }
 
 static int test_harness_run(int argc, char **argv)
_

Patches currently in -mm which might be from edliaw@google.com are

selftests-harness-remove-use-of-line_max.patch

