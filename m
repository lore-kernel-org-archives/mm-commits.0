Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EB6383A5;
	Fri, 16 Aug 2024 05:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723785425; cv=none; b=AWzK38d+zn+OhuQGg1PihSj5ei5SxEJBNoZ52FePxBDHn1WFoO/ANgxmPWNYCPrCmJIQKOckCeC4Js6bRks9n74/6a7O/QK/5+MjaTT59GlywspmbFoULLxV3N0LfowTCYRDUKN1wcH7gBD59gqbY1kCXkrxxlPDud769vPC/Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723785425; c=relaxed/simple;
	bh=ymQN2rXxI6SIahUW2kurIUD0LP0afmSitIQEFwKRpnc=;
	h=Date:To:From:Subject:Message-Id; b=dJhFvsWJqZUtDzB0v1BTbuN1UL4bvx6hqKSRqW1FC/E9C89sauoSZhbx7qv7YHKX+9yXoJ+LiRXxbxKmTrXg2ny7pHd8ghZSDH+7IsdQolPf6AyZxYUAWNkVSA+t8pfrdItnBBn+Y1D4BKx0TJPWi9mbBiaYw+pM59go3puyDKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XqtLxrhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XqtLxrhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DDDC32782;
	Fri, 16 Aug 2024 05:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723785425;
	bh=ymQN2rXxI6SIahUW2kurIUD0LP0afmSitIQEFwKRpnc=;
	h=Date:To:From:Subject:From;
	b=XqtLxrhwFpXqviMvfG2S6ZziIqxpQFQdw87I+x7CDb37ORwlHGhYO7Xm8j94rRjfW
	 UyGUyNbshbkI8mfgTNr+gjS0ndEZAGMyRF5/pl7qyLCCtTBQO9Xtb7I5xqYQHnzADl
	 v0Qyt2tHhLdoDWl/1aPJD7XXMXQRpBJMMO9ysLDA=
Date: Thu, 15 Aug 2024 22:17:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,skhan@linuxfoundation.org,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,James.Bottomley@HansenPartnership.com,aou@eecs.berkeley.edu,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch removed from -mm tree
Message-Id: <20240816051704.E6DDDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: memfd_secret: don't build memfd_secret test on unsupported arches
has been removed from the -mm tree.  Its filename was
     selftests-memfd_secret-dont-build-memfd_secret-test-on-unsupported-arches.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: memfd_secret: don't build memfd_secret test on unsupported arches
Date: Fri, 9 Aug 2024 12:56:42 +0500

[1] mentions that memfd_secret is only supported on arm64, riscv, x86 and
x86_64 for now.  It doesn't support other architectures.  I found the
build error on arm and decided to send the fix as it was creating noise on
KernelCI:

memfd_secret.c: In function 'memfd_secret':
memfd_secret.c:42:24: error: '__NR_memfd_secret' undeclared (first use in this function);
did you mean 'memfd_secret'?
   42 |         return syscall(__NR_memfd_secret, flags);
      |                        ^~~~~~~~~~~~~~~~~
      |                        memfd_secret

Hence I'm adding condition that memfd_secret should only be compiled on
supported architectures.

Also check in run_vmtests script if memfd_secret binary is present before
executing it.

Link: https://lkml.kernel.org/r/20240812061522.1933054-1-usama.anjum@collabora.com
Link: https://lore.kernel.org/all/20210518072034.31572-7-rppt@kernel.org/ [1]
Link: https://lkml.kernel.org/r/20240809075642.403247-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
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

