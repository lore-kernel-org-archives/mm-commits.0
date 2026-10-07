Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5192C17A3
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334146; cv=none; b=ZVCu+QNqxG0RB8GzTU6xhcy1uXo7++/tllrPvzyzIPUKwlrL+9PeNj48FDM9u4wl+jV132Ll4Svi/OLpz6lrGoR8G8aEfkDuKBuQ/Dg2gaI5TgYv49xTKjYNDT5MBayu1FW+7A/rrQWBBIUQf1EkBhnte/DJGdmBoRxMyJ/iGY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334146; c=relaxed/simple;
	bh=3FZV/rCUaOCTNPxr12csH7P4WA30nj6yrz7aJtc03kw=;
	h=Date:To:From:Subject:Message-Id; b=QaQ9p0itq8ssDZm0HwMODaZO5o7moB5lndzsnol4ECb15ciJZICu2i6P5/GzUcY5y0vXKl7STck65KMeir37gxBH22OfoJ1o6s/EFLzAE4ZBTX0kNfJpw9GgvOzwmhj4c4lMN3UqCKN1vA2lcDWBR+lqIG12s11858nGChpIMg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xPqFyu+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xPqFyu+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401451F0089B;
	Wed,  7 Oct 2026 00:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334145;
	bh=Gm/WctVCKuuxATSO8uDdggGSgpaIQc3nFEuetU3rh6E=;
	h=Date:To:From:Subject;
	b=xPqFyu+3oZUc9BRR8xoeGa6Gh12d6Gazf4Ulb5GgSE81uDIOOkFqYcMy5Nr/w5AEE
	 uwi8JCCaOWgpMGrSNVnWECzpgNEfCS+vxnVbxTbdYBz5rFsMsWdWEEXwQ/lbyFxGCK
	 QI+Ebt6n4FCDC0tpSJl/ZqTBGCMrUIbcip7kcYkg=
Date: Tue, 06 Oct 2026 17:49:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch removed from -mm tree
Message-Id: <20261007004905.401451F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix incorrect skip output in pkey_sighandler_tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-incorrect-skip-output-in-pkey_sighandler_tests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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

selftests-mm-remove-unreachable-returns-after-ksft-exit-helpers.patch
docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch
selftests-mm-fix-size-truncation-in-pagemap_ioctl-test.patch
selftests-mm-mark-file-local-symbols-of-pagemap_ioctlc-static.patch
selftests-mm-init-page-sizes-early-in-pagemap_ioctl-test.patch
selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

