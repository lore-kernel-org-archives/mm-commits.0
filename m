Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB02848BE
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 03:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889164; cv=none; b=eqOPPbe0HpZTjJD/cZhFaO7vxfUlAJzjuixJgiaeXabD/QwAT/pr9vYKOkVA+t4pymnLGd+EYNyXtRejR6rl2/MHgOTcFGBhWuGt6d88i6rsdcZclDzVlpik8AKOiAisttYf7M/6XMaAdiVUPgWLhoM7hfzCPAlscKqhRnIwmIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889164; c=relaxed/simple;
	bh=eaZmIY8Cqxib03ZMRnR/HQk66YMuAIeuKJvXGsBExTw=;
	h=Date:To:From:Subject:Message-Id; b=V7ZNjiMrmQ3gTVvLBPlXC0qQsrjKJnEZbE4DI1vAzb9gyfyHoKbMno7BUahFSjeWc8tCHXhXnVMHR5aRQVpm9yW8bII1KcKVECAea9tgJs06YyGTwJF5Nd2PJsoOdltdSOxzMw0lFY1nRwzkKmwnB9f1Xz7uQ68qMvfUgu2tllY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tj0UUsKg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tj0UUsKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF161F000E9;
	Fri, 28 Aug 2026 03:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787889162;
	bh=WdfHqYiG4F0BDswxSt5TifEsSDJZFznQFYWHtkLnAPo=;
	h=Date:To:From:Subject;
	b=Tj0UUsKg4W6byNmCI9J0LE5MYFVfr545FY3fv/1rsev3zMKq3Mo9hDcMdJ584Gkq+
	 OsHJVc96poX+EIuaA6xGN2drSXLrtDM9q6YCcA4k6ABjlz40uzja7pzMhXf+NLOKoI
	 8YP7+DeJ8MDOnb9YDMb/B95OddQ4dEuTAk71PU9w=
Date: Thu, 27 Aug 2026 20:52:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch added to mm-new branch
Message-Id: <20260828035242.5FF161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix incorrect skip output in pkey_sighandler_tests
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch

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
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: selftests/mm: fix incorrect skip output in pkey_sighandler_tests
Date: Tue, 25 Aug 2026 20:30:23 +0800

When pkeys is not supported, ksft_exit_skip() runs with ksft_plan already
set, which takes the "ok N # SKIP" branch intended for skipping a single
test case.  The result is a TAP plan of 5 but only one result line.

 $ ./pkey_sighandler_tests
 TAP version 13
 1..5
 ok 1 # SKIP pkeys not supported
 # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
 # Planned tests != run tests (5 != 1)
 # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

Move ksft_set_plan() after the skip check so ksft_exit_skip() takes the
"1..0 # SKIP" branch, the correct TAP representation for skipping an
entire test file.

 $ ./pkey_sighandler_tests
 TAP version 13
 1..0 # SKIP pkeys not supported

Link: https://lore.kernel.org/20260825123023.64418-1-zenghui.yu@linux.dev
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey_sighandler_tests.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c~selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests
+++ a/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -543,11 +543,12 @@ static void (*pkey_tests[])(void) = {
 int main(int argc, char *argv[])
 {
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(pkey_tests));
 
 	if (!is_pkeys_supported())
 		ksft_exit_skip("pkeys not supported\n");
 
+	ksft_set_plan(ARRAY_SIZE(pkey_tests));
+
 	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
 		tracing_on();
 		(*pkey_tests[test_nr])();
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch

