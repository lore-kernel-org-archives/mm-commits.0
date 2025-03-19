Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929FB13DDB9
	for <mm-commits@vger.kernel.org>; Wed, 19 Mar 2025 02:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742350688; cv=none; b=bQGAEKAJCgc8j7eIua8gYL4hnkXQ94JKTCRAxNhqWVVS9FCKDnr+4No8WUH56ceionyk4zzUYL1pAW4jLatAgbmbOwmqJtqbsz7vLJzjx86d2GmDiSX/dddaPyHwmsVK9oQdm3mlYeTX3TYtnVM6Hto3Zhx1Zh7Xvr8XpVEnZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742350688; c=relaxed/simple;
	bh=Jsc6HIkyHaE+r+shw/4Gg3S0uSmNLA0ub1/f8D5Hm/Y=;
	h=Date:To:From:Subject:Message-Id; b=NBYAIs+JuyGfcF61siH5m3ruzqePszTXGrQSO2ftZUc9QrLUrjaz1KnEOsb+WlErqSAITSGTtkHo8RfE6N2W8aCxo77Fyq/AjM6GuluFcsrY2wcubzK58lg//wRS14j3c5ZM3kdeZmuxi28msPjpKP9BcNULQPvGOLHhPfVUINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A4RHtPzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A4RHtPzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8685C4CEDD;
	Wed, 19 Mar 2025 02:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742350688;
	bh=Jsc6HIkyHaE+r+shw/4Gg3S0uSmNLA0ub1/f8D5Hm/Y=;
	h=Date:To:From:Subject:From;
	b=A4RHtPzEOmF6vB82YMe3q7+nVpfP33kanIc7HKTCCGEbSza6zxUCfiVaysBPR+oWh
	 bfoji5187yaAzdgHz6dKsUEWhyI/3mqByoGsqNppkOdLROek/dDgh7qK3g8Y8iQFoo
	 /CwRNqMCEu1KmTEYsPh7E8enmubI13kLu/B0npgw=
Date: Tue, 18 Mar 2025 19:18:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,raquini@redhat.com,peterx@redhat.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch added to mm-unstable branch
Message-Id: <20250319021807.E8685C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: uffd-unit-tests support for hugepages > 2M
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: selftests/mm: uffd-unit-tests support for hugepages > 2M
Date: Tue, 18 Mar 2025 17:43:40 +0000

uffd-unit-tests uses a memory area with a fixed 32M size.  Then it
calculates the number of pages by dividing by page_size, which itself is
either the base page size or the PMD huge page size depending on the test
config.  For the latter, we end up with nr_pages=1 for arm64 16K base
pages, and nr_pages=0 for 64K base pages.  This doesn't end well.

So let's make the 32M size a floor and also ensure that we have at least 2
pages given the PMD size.  With this change, the tests pass on arm64 64K
base page size configuration.

Link: https://lkml.kernel.org/r/20250318174343.243631-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-tests-support-for-hugepages-2m
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -26,6 +26,8 @@
 #define ALIGN_UP(x, align_to) \
 	((__typeof__(x))((((unsigned long)(x)) + ((align_to)-1)) & ~((align_to)-1)))
 
+#define MAX(a, b) (((a) > (b)) ? (a) : (b))
+
 struct mem_type {
 	const char *name;
 	unsigned int mem_flag;
@@ -196,7 +198,8 @@ uffd_setup_environment(uffd_test_args_t
 	else
 		page_size = psize();
 
-	nr_pages = UFFD_TEST_MEM_SIZE / page_size;
+	/* Ensure we have at least 2 pages */
+	nr_pages = MAX(UFFD_TEST_MEM_SIZE, page_size * 2) / page_size;
 	/* TODO: remove this global var.. it's so ugly */
 	nr_parallel = 1;
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-uffd-unit-tests-support-for-hugepages-2m.patch
selftests-mm-speed-up-split_huge_page_test.patch

