Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30021A0B;
	Sat, 10 Aug 2024 06:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723273071; cv=none; b=DQObwZuS0QJ2T3MTliAttea/+5dO7VWXLh5ZXS4EWAKgG3AWEfgB9cRl7bjsor1AAvJ1aeKqbEnJ5FKzNkQX82fHQO3vwP/+s2Xe0nFKDM3kGlq4A3QnF+eyTtKmslz7YFwacAFkw217YZ133s9dGkcuwKPiS4HP90PHalJIkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723273071; c=relaxed/simple;
	bh=8KWAiP9QqRxubX/w07CI25UoOR41M6XD3z/hOvatN/U=;
	h=Date:To:From:Subject:Message-Id; b=CcJZAJTm0kxPhglk2uAK3aAR3VHfOiaesRdDHnrF9+i8iAB85y9d9glN2An8NToDO5VezU0Tvt6MOQgMd8KuDej9VVhlIjP8bYhmDyHCcG8Mcyc+kbDbpG+vuYERI6C8lLyPlgbokcSnWAZvzkbcYEy8jBlI+1HfvC7Q4ntrx2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K+QvLXKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K+QvLXKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7B0C32781;
	Sat, 10 Aug 2024 06:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723273070;
	bh=8KWAiP9QqRxubX/w07CI25UoOR41M6XD3z/hOvatN/U=;
	h=Date:To:From:Subject:From;
	b=K+QvLXKGdJdR5yLGFqq43fs4LMQDc+5wnQadclLNK5d29E2eiOjBb2C6HmcoSWdV8
	 iMgAsdNmPpsnIcWSW4jooGgcUx5Fv+pdymvpPDCk9iswvz+79wVMChEu+kLmvE5iKD
	 mRewnJar553q7iNMyS0R3sNNJh71LhrN2GN1gg/Y=
Date: Fri, 09 Aug 2024 23:57:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,James.Bottomley@HansenPartnership.com,aou@eecs.berkeley.edu,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch added to mm-hotfixes-unstable branch
Message-Id: <20240810065750.BB7B0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: memfd_secret: don't build memfd_secret test on unsupported arches
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: memfd_secret: don't build memfd_secret test on unsupported arches
Date: Fri, 9 Aug 2024 12:56:42 +0500

[1] mentions that memfd_secret is only supported on arm64, riscv, x86 and
x86_64 for now.  It doesn't support other architectures.  I found the
build error on arm and decided to send the fix as it was creating noise on
KernelCI.  Hence I'm adding condition that memfd_secret should only be
compiled on supported architectures.

Also check in run_vmtests script if memfd_secret binary is present
before executing it.

Link: https://lore.kernel.org/all/20210518072034.31572-7-rppt@kernel.org/ [1]
Link: https://lkml.kernel.org/r/20240809075642.403247-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/Makefile       |    2 ++
 tools/testing/selftests/mm/run_vmtests.sh |    3 +++
 2 files changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/Makefile~selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches
+++ a/tools/testing/selftests/mm/Makefile
@@ -53,7 +53,9 @@ TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
+ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64))
 TEST_GEN_FILES += memfd_secret
+endif
 TEST_GEN_FILES += migration
 TEST_GEN_FILES += mkdirty
 TEST_GEN_FILES += mlock-random-test
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -374,8 +374,11 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+if [ -x ./memfd_secret ]
+then
 (echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
+fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -H -s 100
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

selftests-mm-fix-build-errors-on-armhf.patch
selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch

