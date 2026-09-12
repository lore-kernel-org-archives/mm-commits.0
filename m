Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626617E0FF
	for <mm-commits@vger.kernel.org>; Sat, 12 Sep 2026 06:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789193744; cv=none; b=Ne3KOKtQlMjIkVtzys/Szrqy5KMup4HH8ZE2+Fv17IcKcEHPvPtwgcLbQ1o8+uq1fsXNqotPiszdMwXxdWc+SHu1SrEJJA/z+TTZJs9L0f6YAa8MG4EX0X0rPzxYmnz3BlqqzjKU6mAIJrEf9NpWBQF4oj7VigwgAz4r1HL8RWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789193744; c=relaxed/simple;
	bh=eulFgWSGZ6p/gSUq43AeVgn+hBZXHjb79owpSX4ChrI=;
	h=Date:To:From:Subject:Message-Id; b=qZ1PCqSkv6EVFoQh+0wVCw+3yzgyIUffQmjVTJWYuNkipyGvyEZEwJ7mNdktKCvjybJbUa/e69vJcBOkwAws06lRvwr3ohzWyGljhyrQmkGc5plGXHco310SrO39FmFjz8n4AYVPNMT7jos1zpU5EONgDQrgJn2y/x5w3uZnpcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPZ71E0N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPZ71E0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72201F000FF;
	Sat, 12 Sep 2026 06:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789193742;
	bh=H2SXQlR7Sepuw/4cDmMTG2WawT2FDHjeuadV8JWewfY=;
	h=Date:To:From:Subject;
	b=NPZ71E0Ni+6MX5I6h+F5BNuaG3bdazSNJd41diHPQbfGP9P7y1pBwJLtxjKTPQZ32
	 nzmAmEsQiHRJrvNTbdDjhaw6rXxNLin7uQmSum1Mod10QlfxsxsRFphrb4eMRkxYr+
	 2brIrgRV0AgyLSB5dBb8QzWxS/vSxhWeuslB0PHY=
Date: Fri, 11 Sep 2026 23:15:42 -0700
To: mm-commits@vger.kernel.org,yury.norov@gmail.com,willy@infradead.org,sparse@chrisli.org,ljs@kernel.org,liam@infradead.org,david@kernel.org,andrewjballance@gmail.com,aliceryhl@google.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch added to mm-new branch
Message-Id: <20260912061542.C72201F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kselftest: mm: remove exclusion of building soft-dirty test in arm64
has been added to the -mm mm-new branch.  Its filename is
     kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch

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

kselftest-mm-fix-potential-failure-for-merged-vma-in-guard-regions.patch
kselftest-mm-remove-exclusion-of-building-soft-dirty-test-in-arm64.patch

