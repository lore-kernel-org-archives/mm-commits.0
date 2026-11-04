Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793836798;
	b=hv7stdAzQYctGJB68xfwEpCo6k1vOxWrPz4bGvWUm+XdRtdBz/EPEe/6mKiWzl9cT3M5
	 Vm+kv7AnnMI3V3HKyb18mre2w4+yLZT1SRwxbMah0MhYPSngandDYE4eQLxuwF8z2HRWA
	 7Nmha8OkxFVPJp9d5C39L/GAYaDfd161c4zrdacGm0wJDfOYZWvEOa5u/nUNlsrqJ8hzI
	 MbSvUI8Lcsf9lG8w6P9uS+J6UuOJK8r7UUqE/ElDGk4EOGtEsDTQDrkQgjb1jBil0oYdc
	 TkzxixWUBwg9Fc7UVACDTLlvuNS3IgmOJ16O19q/LIMP84wZQ4IQ5E0kCaHCGo9luDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793836798;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PMR6db9NH2TQuoo1DGJ75xBjO+8fBDprfppk6KfNb9M=;
	b=CLCRLI9Lo9AnAWvoFDqNnCQieAWTlXM+us5aHm8X8OJEOarGqss29oWubtXnkv9s+lgQ
	 ZtqHQKMO6kK5MdpPX/RvuyPdiFw+6Dsna3hJ1nDECKbOeG5NEu1gZq8goCgi92mVbqmUZ
	 o1oJ1j5moAkPk++qsX6moXPNEtS5TmUhTK53ZewZD0jmZMZyPXPubndX2ijTCTQUdglUy
	 UDbcezcK7TtadlLQDgpfzcUVgkCQn7rxia2+AzU0KjpkNdW5HtazRV0nRzMUxzlY0WcrD
	 +9kEotuW5rIBQPYhFApLV68lgpbHxz1Fn5ZKlo5efWJ5nLdFuLexMPxISMzDPJPKxXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ScYmRwWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ECC606A326
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ScYmRwWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71CC1F000C1;
	Wed,  4 Nov 2026 23:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793836797;
	bh=PMR6db9NH2TQuoo1DGJ75xBjO+8fBDprfppk6KfNb9M=;
	h=Date:To:From:Subject;
	b=ScYmRwWTcdLV9rxTnn17eLpBNwiPvkmMHySwiV+J0xLkdW0IBjLvGusV5KBn8XqqU
	 jH8Uyb0wJK89sxIb3C2CwiK70W8LMcWs67VEtJd9B1e5Myj7SNv0SwjjHNTFuLiux6
	 /iFT1rN3Pj3ptPSYnoJZBxz4bPzMo/FzLU7XmpQI=
Date: Wed, 04 Nov 2026 15:59:57 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,aleksey.oladko@virtuozzo.com,
	sashal@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-prctl-select-the-tests-by-arch-alone.patch added to mm-nonmm-unstable branch
Message-Id: <20261104235957.B71CC1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/prctl: select the tests by ARCH alone
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-prctl-select-the-tests-by-arch-alone.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-prctl-select-the-tests-by-arch-alone.patch

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
Subject: selftests/prctl: select the tests by ARCH alone
Date: Wed,  4 Nov 2026 14:36:39 -0500

The prctl tests are only built for x86, and only when CROSS_COMPILE is not
set.  In every other case the Makefile defines no rules, so building or
installing the suite fails:

  make[1]: *** No targets.  Stop.

TuxMake sets CROSS_COMPILE for every build, native x86_64 ones included,
so CI systems that use it, such as KernelCI, see prctl fail on every
architecture and never build its tests.

Like breakpoints, ipc and x86, decide by ARCH alone whether the tests are
built, and give the Makefile empty targets on other architectures, as
sparc64 and drivers/s390x/uvdevice do, so that the suite builds and
installs nothing there.

Link: https://lore.kernel.org/20261104193639.333186-1-sashal@kernel.org
Fixes: 92dd8dd4d07f ("selftests: move prctl tests from Documentation/prctl")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
---

 tools/testing/selftests/prctl/Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/prctl/Makefile~selftests-prctl-select-the-tests-by-arch-alone
+++ a/tools/testing/selftests/prctl/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-ifndef CROSS_COMPILE
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
 override ARCH := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
@@ -10,5 +9,8 @@ all: $(TEST_PROGS)
 
 include ../lib.mk
 
-endif
+else
+nothing:
+.PHONY: all clean run_tests install
+.SILENT:
 endif
_

Patches currently in -mm which might be from sashal@kernel.org are

selftests-proc-cast-the-procmap_query-address-through-uintptr_t.patch
selftests-mm-fix-pointer-width-warnings-on-32-bit-architectures.patch
selftests-mm-uffd-wp-mremap-keep-the-thp-sizes-in-unsigned-long.patch
selftests-proc-search-the-kernel-headers-before-the-tools-copies.patch
selftests-prctl-select-the-tests-by-arch-alone.patch

