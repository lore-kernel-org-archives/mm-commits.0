Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5351B2594B3;
	Wed,  8 Jan 2025 04:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311205; cv=none; b=jd353NrrUT+MGMCufY1PkgKJVNJkOnaoGXQJ/b+k2cahHUuD6+2LqnO5+dfmhOPie/PWIIc81pbB/XR6cWtji1t3Tc8oEx0c+hnhR5nDtnOBi2MFOzt/5kpANqAugwYPSkOYMxjngpMSLB4wp5vvtD79DwDSYRkwNctbCQCuoto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311205; c=relaxed/simple;
	bh=rg9JlUrQUO2GplQ+GW8Skzf7FogoOD9XxoahdS1GuhI=;
	h=Date:To:From:Subject:Message-Id; b=fkhCqi4+/np0hESMirumo51Yz2c08wZDB3F4snFU6JpTzLIWxSd7t99IpGTccS0GABaMz9Ev1ANqvrHFuuC60TxFPe4u0yxULMXRWveoklIe3CZ2MT6g8BcJarfFmzpl+BiySbtD4EJd5o+JUi+NvHMit1EXfkqPF8NH6IgXaYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpqWUZ6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpqWUZ6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EC1C4CED0;
	Wed,  8 Jan 2025 04:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736311204;
	bh=rg9JlUrQUO2GplQ+GW8Skzf7FogoOD9XxoahdS1GuhI=;
	h=Date:To:From:Subject:From;
	b=OpqWUZ6U+SBTgGVAlWoU9tjeyd56OvwieiQzlXJygqFK1gn/R+aTpzubrovyH8cpo
	 ZKUHxzrcv9kONpaeHUuggu9qbIje7UbEHLqXKUWkJu6dy1ZW7z0GaO5ytO2Yr1oVhy
	 BkQotivxcUgK8sJTRJnr9Z6s0dxDTZO/fwVCOFJE=
Date: Tue, 07 Jan 2025 20:40:04 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,shuah@kernel.org,oliver.sang@intel.com,dev.jain@arm.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch added to mm-hotfixes-unstable branch
Message-Id: <20250108044004.B0EC1C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: fix error when CommitLimit < 1GiB
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch

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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: selftests/mm: virtual_address_range: fix error when CommitLimit < 1GiB
Date: Tue, 07 Jan 2025 16:14:45 +0100

If not enough physical memory is available the kernel may fail mmap(); see
__vm_enough_memory() and vm_commit_limit().  In that case the logic in
validate_complete_va_space() does not make sense and will even incorrectly
fail.  Instead skip the test if no mmap() succeeded.

Link: https://lkml.kernel.org/r/20250107-virtual_address_range-tests-v1-1-3834a2fb47fe@linutronix.de
Fixes: 010409649885 ("selftests/mm: confirm VA exhaustion without reliance on correctness of mmap()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: <stable@vger.kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -178,6 +178,12 @@ int main(int argc, char *argv[])
 		validate_addr(ptr[i], 0);
 	}
 	lchunks = i;
+
+	if (!lchunks) {
+		ksft_test_result_skip("Not enough memory for a single chunk\n");
+		ksft_finished();
+	}
+
 	hptr = (char **) calloc(NR_CHUNKS_HIGH, sizeof(char *));
 	if (hptr == NULL) {
 		ksft_test_result_skip("Memory constraint not fulfilled\n");
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

selftests-mm-virtual_address_range-fix-error-when-commitlimit-1gib.patch
selftests-mm-virtual_address_range-avoid-reading-vvar-mappings.patch

