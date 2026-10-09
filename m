Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287D41BA69
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525570; cv=none; b=kwNU+/3h/dTRdDNxEAxpGKU3REOiTeTFk2yMHlp8HEhVIt8yMpQ5kwp6FjbVO/z2R9r70by8LTaFWckxwo5aRwqEDD27nS8LIm+KzA+rwDz3inmf1UPDpPy6Y/A2+MWhbtnsm0KAFFZ8SGVCY/anJPnPusH4+TvbFuEUERQa5jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525570; c=relaxed/simple;
	bh=llcbHoMh2BUQ4hP27D5Nnng5J58R70ITETk0aDXfyV8=;
	h=Date:To:From:Subject:Message-Id; b=hsY39TX5OcuYvXlxVF3yW8Z2X1lMogZYQfaKtd8PeWUKPjXuQclK/cullrRYB4Q6EXLCuqsBHjNSk2vr9EslgmgoK8ldJf+7HTVBsS3YTNsLOltZmLbUrT6ejWTF4reWDjZzYs8k+lEI3nrd/e39ZV31xyDDt2sf5K9gqfh6zNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B9GdRf9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B9GdRf9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D2B1F00893;
	Fri,  9 Oct 2026 05:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525569;
	bh=AmB5IF52TvXEeefhofKuBih2Ef1Mi/A/eXSCcJ4zRNw=;
	h=Date:To:From:Subject;
	b=B9GdRf9jv1JN2pgN5Jz2Xvjyo8uU6TUdZRVptYBCJHmBKRulmsrxZV64r/xjYsVAF
	 4aVtXQ01ePitcozyCl97/9G5BuNMBk3hmk/DAV3qDKhnnr0hu+uKbn+D+HqXPpkHGt
	 /jbfEKgrqvjWikWdeGbv9e0O0lIuAIE4RCjX2DHU=
Date: Thu, 08 Oct 2026 22:59:29 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,yury.norov@gmail.com,willy@infradead.org,sparse@chrisli.org,ljs@kernel.org,liam@infradead.org,david@kernel.org,andrewjballance@gmail.com,aliceryhl@google.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch removed from -mm tree
Message-Id: <20261009055929.68D2B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kselftest: mm: remove exclusion of building soft-dirty test in arm64
has been removed from the -mm tree.  Its filename was
     kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: remove exclusion of building soft-dirty test in arm64
Date: Fri, 11 Sep 2026 22:06:11 +0100

Since commit 0389c305ef56 (“selftests/mm: skip soft-dirty tests when
CONFIG_MEM_SOFT_DIRTY is disabled”), the soft-dirty test is skipped when
soft-dirty is not supported.

There is therefore no reason to exclude the test from being built on
arm64.  Remove the arm64-specific exclusion.

Link: https://lore.kernel.org/20260911210611.4001419-1-yeoreum.yun@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---

 tools/testing/selftests/mm/Makefile       |    3 ---
 tools/testing/selftests/mm/run_vmtests.sh |    5 +----
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/Makefile~kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64
+++ a/tools/testing/selftests/mm/Makefile
@@ -104,10 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
-
-ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
-endif
 
 ifeq ($(ARCH),x86_64)
 CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_program.c -m32)
--- a/tools/testing/selftests/mm/run_vmtests.sh~kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -408,10 +408,7 @@ then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
 
-if [ -x ./soft-dirty ]
-then
-	CATEGORY="soft_dirty" run_test ./soft-dirty
-fi
+CATEGORY="soft_dirty" run_test ./soft-dirty
 
 CATEGORY="pagemap" run_test ./pagemap_ioctl
 
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch
kselftest-mm-fix-intermittent-failure-khugepaged-test.patch
kselftest-mm-prevent-random-failure-of-huge-page-split-for-khugepaged.patch
kselftest-mm-replace-usage-of-proc-self-smaps-for-__check_pmd_huge.patch
kselftest-mm-integrate-huge-page-checks.patch
kselftest-mm-remove-check_huge_shmem.patch

