Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73F923B629
	for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2025 20:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753821853; cv=none; b=MFwdFHOtvVX1/Fc6K9pqv+r/6hfLJUICOSNjh9wSRBed2fCPL0jkht9969V0GzCMEH0F2RMxwAhy1gSbmlTMY/TuJjBV5IeQeEKJPGHSa6IsaXHrVG1UoFJUcBbfbeGTZcwuZ37fkixu81B0Ut2/xFJKG7bbr01XZia0cYW7T6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753821853; c=relaxed/simple;
	bh=VsFLSVtimg21MW2HKYtQ1Zjrdb+sm2XldtgS4nFuWoM=;
	h=Date:To:From:Subject:Message-Id; b=OdVYO7ajRkpOlEBmiXVCyITkaG6aZI916SoGD0oIUqIzEOlIKGSCoFicqDc9X5r0iy70HKxVYYYUT81RGt9+acbUQfUvQx3KbKu32lKrUWjZr+hmtZ2ToYkhWkoNI2LuX8MLRdG7Vo5tHJuUdbnzylvSoyyJ+WksuZ+aejZdkLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3VoYPwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3VoYPwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA4EC4CEEF;
	Tue, 29 Jul 2025 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753821853;
	bh=VsFLSVtimg21MW2HKYtQ1Zjrdb+sm2XldtgS4nFuWoM=;
	h=Date:To:From:Subject:From;
	b=K3VoYPwKM8xpa3vIMj1Sb5BWonq6n8NJhsuZJe7B/g4fU8/b7GfH/YWe+a9SssSHL
	 s+VIo4LQoxsnMW+cmV2zOHFJbsRzwhSkaSjefx7Uk1O4g+CZ7guYMTRlCULcKwsqdk
	 kh46uc5UYl0jtsgh8Rpgf/SCDWxTCanNn3DyGerI=
Date: Tue, 29 Jul 2025 13:44:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,donettom@linux.ibm.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch added to mm-new branch
Message-Id: <20250729204413.2FA4EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: skip thuge-gen test if system is not setup properly
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch

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
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: selftests/mm: skip thuge-gen test if system is not setup properly
Date: Tue, 29 Jul 2025 11:04:02 +0530

Make thuge-gen skip instead of fail when it can't run due to system
settings.  If shmmax is too small or no 1G huge pages are available, the
test now prints a warning and is marked as skipped.

-------------------
Before Patch:
-------------------
~ running ./thuge-gen
~ Bail out! Please do echo 262144 > /proc/sys/kernel/shmmax
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
~ [FAIL]
not ok 28 thuge-gen ~ exit=1

-------------------
After Patch:
-------------------
~ running ./thuge-gen
~ ~ WARNING: shmmax is too small to run this test.
~ ~ Please run the following command to increase shmmax:
~ ~ echo 262144 > /proc/sys/kernel/shmmax
~ 1..0 ~ SKIP Test skipped due to insufficient shmmax value.
~ [SKIP]
ok 29 thuge-gen ~ SKIP

Link: https://lkml.kernel.org/r/20250729053403.1071807-7-aboorvad@linux.ibm.com
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/thuge-gen.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/thuge-gen.c~selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly
+++ a/tools/testing/selftests/mm/thuge-gen.c
@@ -177,13 +177,16 @@ void find_pagesizes(void)
 	globfree(&g);
 
 	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
-	if (shmmax_val < NUM_PAGES * largest)
-		ksft_exit_fail_msg("Please do echo %lu > /proc/sys/kernel/shmmax",
-				   largest * NUM_PAGES);
+	if (shmmax_val < NUM_PAGES * largest) {
+		ksft_print_msg("WARNING: shmmax is too small to run this test.\n");
+		ksft_print_msg("Please run the following command to increase shmmax:\n");
+		ksft_print_msg("echo %lu > /proc/sys/kernel/shmmax\n", largest * NUM_PAGES);
+		ksft_exit_skip("Test skipped due to insufficient shmmax value.\n");
+	}
 
 #if defined(__x86_64__)
 	if (largest != 1U<<30) {
-		ksft_exit_fail_msg("No GB pages available on x86-64\n"
+		ksft_exit_skip("No GB pages available on x86-64\n"
 				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
 	}
 #endif
_

Patches currently in -mm which might be from aboorvad@linux.ibm.com are

selftests-mm-fix-child-process-exit-codes-in-ksm_functional_tests.patch
selftests-mm-skip-thuge-gen-test-if-system-is-not-setup-properly.patch
selftests-mm-skip-hugepage-mremap-test-if-userfaultfd-unavailable.patch

