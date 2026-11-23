Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795401410;
	b=0qgz3Ef0dsPPsIq8vUX4+G2dfjPiwL0JkZ6aCwQp2rVALC6lPzk720ELHDJhBdGT2awz
	 DrEBOGmMxYfaI4vcXgmv5Hqsa0ZO5M2Ie0YfFnyqgnQkIiFwSFrUbVnq31KQ9Zvz3Tgg+
	 lR95Zwlqn/UOVuVGMF5LfgDiB9gdn2OOdACYtK6w9AESqmtCswOtzlNfeawZLodXL7UJI
	 /aYMpArM5NsG1sgkHMeaOSxZ0YwGv2AKHXmxpW6sqhL7gQyAHojqa6sextVC8yELFUfY1
	 MCg50dpFbzd3/AKyj9B4dwizWHsU7Rt1H0R98pI4i/MAxmudCHuJU9yzQ4nvkOW5gFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795401410;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Ce+qzpekLAoNSmIZqZ9iH6uKDDTjJO6CFn4Vrsm2cCM=;
	b=Qafmw9i4B9e1HFebE6tYInyH/d1Oy3jZ2dm0r4AyfU+Fu5uNsay3pJYoIBf6qQqIlxlM
	 9me3hGjZZPLZEMBTuzWr2vv3QfSjmj+rWR1vZAsvi+q7YSnXv6ZQuDsFBliadtxTt6MUG
	 H/16Q54zGUOXqZeHHdRuQZxw/KbSVtRq2AkDC+Bu/wyIn1h/2p69x3n/wHlXpff7j19pU
	 LfKPysJhM7A0sEl6DYvjXnTGfeezeMo3OcPQbhDtrWr8mcRWtD97GPAv8qh89jQOs3+wl
	 8qGL3FDT/UM2HHwev7Aotyx65jIA/leEcvbtIU+SDBdDpguAJHNPF4UnTtGjzOxl/GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PSqF+Y1B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E85606A327
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 02:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PSqF+Y1B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A8E1F01569;
	Mon, 23 Nov 2026 02:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795401410;
	bh=Ce+qzpekLAoNSmIZqZ9iH6uKDDTjJO6CFn4Vrsm2cCM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=PSqF+Y1BKo/pGv8dCJRhrwyH9Odj1FigOKrO/vmNEaONEWd6pF4SILAk/6heO/xt7
	 3649eoZ7TubMjKHmR3GaP8LbUmvXFUcC7oybDKeZ6+m4qYjHD3A0CBSFcByvRCDJQ/
	 6iF1cOC0LLfkzrN9JGoedqSPJVuO/ca8USfUkiCA=
Date: Sun, 22 Nov 2026 18:36:49 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,linux@weissschuh.net,
	ivan.orlov0322@gmail.com,sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261105125701.1605281-2-sashal@kernel.org>
References: <20261105125701.1605281-2-sashal@kernel.org>
Subject: + selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported.patch added to mm-nonmm-unstable branch
Message-Id: <20261123023650.73A8E1F01569@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/prctl: skip the anonymous VMA naming test when unsupported
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Sasha Levin <sashal@kernel.org>
Subject: selftests/prctl: skip the anonymous VMA naming test when unsupported
Date: Thu, 05 Nov 2026 07:56:59 -0500

Patch series "selftests: target selection fixes for cross and LLVM builds".

A few suites select their tests from the build host instead of the
target, or depend on the host C library in ways that break cross
builds:

 - set-anon-vma-name-test fails instead of skipping on kernels built
   without CONFIG_ANON_VMA_NAME.

 - kexec only recognizes the ppc64le spelling of PowerPC and decides
   about the x86-64 jump test from the build host.

 - size links a custom _start against the static C library, which
   fails on ARM with clang and on LoongArch; it now uses nolibc.

The patches are independent of each other and apply on
mm-nonmm-unstable.


This patch (of 3):

PR_SET_VMA_ANON_NAME is only implemented when CONFIG_ANON_VMA_NAME is
enabled. Without it, set_anon_vma_name() returns -EINVAL for every
request, so set-anon-vma-name-test reports a failure on kernels that
simply do not provide the feature:

  # renaming: Expected rename_vma(...) (-22) >= 0
  not ok 1 vma.renaming

Probe the interface in the fixture setup by clearing the name of the
anonymous mapping, which succeeds whenever the feature is available,
and skip the test when the kernel rejects the request with EINVAL.

Link: https://lore.kernel.org/20261105125701.1605281-1-sashal@kernel.org
Link: https://patch.msgid.link/20261105125701.1605281-2-sashal@kernel.org
Fixes: 5290586186d2 ("selftests: prctl: Add new prctl test for PR_SET_VMA action")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>

 tools/testing/selftests/prctl/set-anon-vma-name-test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/prctl/set-anon-vma-name-test.c~selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported
+++ a/tools/testing/selftests/prctl/set-anon-vma-name-test.c
@@ -93,6 +93,9 @@ FIXTURE_SETUP(vma) {
 					MAP_PRIVATE, self->fd_not_anon, 0);
 	ASSERT_NE(self->ptr_not_anon, MAP_FAILED);
 	close(self->fd_not_anon);
+
+	if (rename_vma((unsigned long)self->ptr_anon, AREA_SIZE, NULL) == -EINVAL)
+		SKIP(return, "PR_SET_VMA_ANON_NAME is not supported");
 }
 
 FIXTURE_TEARDOWN(vma) {
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
kselftest-alloc_tag-use-the-ll64-types-on-powerpc64.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch
selftests-prctl-skip-the-anonymous-vma-naming-test-when-unsupported.patch
selftests-kexec-select-tests-using-the-target-compiler.patch
selftests-size-use-nolibc-startup-and-syscall-wrappers.patch

