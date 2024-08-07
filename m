Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88ADD74070
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057234; cv=none; b=Ui+wGa+JfDe7huCO6dGn3LfbUivULNM4EsPfSTtMEPMA1C0OiaJOOpLfqPbmiEfPU2dRhez/qjIXikAKvdWpOofy3hDhZZ+HqFiHDeJqRniBIhqVfGj1rgTSJUOLSC7jFVZuKWT79N2Wu3kimPO8orXdV6riscZKA8sMKNxBwBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057234; c=relaxed/simple;
	bh=L6G5ERg+25oLDmc/Y28fOG5YoQgyo78ck/CGCGzEmPs=;
	h=Date:To:From:Subject:Message-Id; b=SjuHlm8aoBiWBnq1CPpdEz9jS0coHpl/DI9WhBzlbJm2SU6duaxZknBADKvAZy6H8wVRdT8HgUAcMvbAlKuSwZvws8uwbTQ4yzxQiwQyiCR82fUoSrNZRj1skfqNqs/S39hJh6jGxvLAXlzMqiZAd0LIeeiMjk0EJOEJ7ukkJYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O/mJHY29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O/mJHY29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E4CC32781;
	Wed,  7 Aug 2024 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723057234;
	bh=L6G5ERg+25oLDmc/Y28fOG5YoQgyo78ck/CGCGzEmPs=;
	h=Date:To:From:Subject:From;
	b=O/mJHY29gmwtm/I6sCeTcfi//J/rlgUdkOsCxSJOBitW2KU/Lo09BA31RVi3rKMMG
	 u/jTr0/rFbyDbo4DcRneG1Ln7AmcAowl0SY566u2J2O1u/2zECmiOc6oStGkGMoVA2
	 hZKqq0ClazY6b9xbuOc/FZ7tG4p88xiTpv9g/pQw=
Date: Wed, 07 Aug 2024 12:00:33 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-mseal-test-for-no-discard-madvise.patch added to mm-unstable branch
Message-Id: <20240807190034.50E4CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add mseal test for no-discard madvise
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-add-mseal-test-for-no-discard-madvise.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-mseal-test-for-no-discard-madvise.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: selftests/mm: add mseal test for no-discard madvise
Date: Wed, 7 Aug 2024 18:33:36 +0100

Add an mseal test for madvise() operations that aren't considered
"discard" (e.g purely advisory ops such as MADV_RANDOM).

Link: https://lkml.kernel.org/r/20240807173336.2523757-3-pedro.falcato@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mseal_test.c |   34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/tools/testing/selftests/mm/mseal_test.c~selftests-mm-add-mseal-test-for-no-discard-madvise
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1731,6 +1731,38 @@ static void test_seal_discard_ro_anon(bo
 	REPORT_TEST_PASS();
 }
 
+static void test_seal_madvise_nodiscard(bool seal)
+{
+	void *ptr;
+	unsigned long page_size = getpagesize();
+	unsigned long size = 4 * page_size;
+	int ret;
+
+	setup_single_address(size, &ptr);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
+
+	if (seal) {
+		ret = seal_single_address(ptr, size);
+		FAIL_TEST_IF_FALSE(!ret);
+	}
+
+	/*
+	 * Test a random madvise flag like MADV_RANDOM that does not touch page
+	 * contents (and thus should work for msealed VMAs). RANDOM also happens to
+	 * share bits with other discard-ish flags like REMOVE.
+	 */
+	ret = sys_madvise(ptr, size, MADV_RANDOM);
+	FAIL_TEST_IF_FALSE(!ret);
+
+	ret = sys_munmap(ptr, size);
+	if (seal)
+		FAIL_TEST_IF_FALSE(ret < 0);
+	else
+		FAIL_TEST_IF_FALSE(!ret);
+
+	REPORT_TEST_PASS();
+}
+
 int main(int argc, char **argv)
 {
 	bool test_seal = seal_support();
@@ -1822,6 +1854,8 @@ int main(int argc, char **argv)
 	test_seal_mremap_move_fixed_zero(true);
 	test_seal_mremap_move_dontunmap_anyaddr(false);
 	test_seal_mremap_move_dontunmap_anyaddr(true);
+	test_seal_madvise_nodiscard(false);
+	test_seal_madvise_nodiscard(true);
 	test_seal_discard_ro_anon(false);
 	test_seal_discard_ro_anon(true);
 	test_seal_discard_ro_anon_on_rw(false);
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

mseal-fix-is_madv_discard.patch
selftests-mm-add-mseal-test-for-no-discard-madvise.patch

