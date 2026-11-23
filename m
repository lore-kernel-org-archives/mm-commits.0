Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795401413;
	b=3ce6BqZWxz+NFED2cDTXurfmvU256SgU6guyIxjJ0iVqpWU8z23ea/9nH6Dwx5sDZfq9
	 2PpCkDyuFwpbItdGGuLifdnfPQllu8sJeWAOKM9g9yAmcvgYZmWVLZP7C5nCSZqBQSWFL
	 tuqjqWBnRD9o3l6DGIzP8eM+OfMGJ3TQZwJ/gMBm2NYh9L/1tjtiECcxFQodxqav9uNLh
	 eZRe2vQMgL1I8H/Bjs0FP6pLXJsyu8BamfxWa4mD+YepW2gaGakPBAy6MtQZBz+AIpJGP
	 JLisJ9O/ab8IX4eSb1Fj/hqHeSP9e45PJ3k/O2wRkeL+K21YvOu35iVz22M4JFHaG7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795401413;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=m3tVFQuLppVZV05J4oyIwC/NFE5AtA79rBzSoGgmsW4=;
	b=IYZtXkvOmlqU3tAA3Jmnt5PlOLHoxvjupB8CXBpfnvrJSEA7hjJ7j0rQZ9kGhcALediS
	 GDcT00cPdYQcJIsRXQTx1MXw/BPj9tFbVlOHfsiSR+05mT2yGtDa4Cawn4H6EHH19ehma
	 DQJL1SNfpfFYShUeMDB3IrS9qiloxYLRwCFUncPHddIw5yODX61OHXqLcXP+Ge/sJE4at
	 MlT3Wazn1ab3a/mSZ2oud2wBGIWy1KzqBN7JFF0dZYrT1viD2NK3AYs5fklUX0C/qxtZy
	 1VA3b0egLlt5EsfX8LrKBO7FV4RwA5pF60NcaH2PHiHbKMMYu9V+0i0jHiscx0PfFIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2a5quLif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD38E606A33C
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 02:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2a5quLif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D72C1F000D4;
	Mon, 23 Nov 2026 02:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795401413;
	bh=m3tVFQuLppVZV05J4oyIwC/NFE5AtA79rBzSoGgmsW4=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=2a5quLifBKtfWWu59PLmhiG859SaX4P5HLVBusHq2SItrvqT5PNYUyNt0Ub7teXtF
	 wRDFLpcUlLQtd3eVBZZgYi72btnC0nKNV+Fp4/+mqiXRanRG9csH1QzvaE6lEnrMwV
	 Pyg3dATC9i8h9bFwuIQ7eVmr8geE/GohkB5negDE=
Date: Sun, 22 Nov 2026 18:36:52 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,rnsastry@linux.ibm.com,
	linux@weissschuh.net,dwmw@amazon.co.uk,sashal@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261105125701.1605281-3-sashal@kernel.org>
References: <20261105125701.1605281-3-sashal@kernel.org>
Subject: + selftests-kexec-select-tests-using-the-target-compiler.patch added to mm-nonmm-unstable branch
Message-Id: <20261123023653.5D72C1F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/kexec: select tests using the target compiler
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-kexec-select-tests-using-the-target-compiler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-kexec-select-tests-using-the-target-compiler.patch

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
Subject: selftests/kexec: select tests using the target compiler
Date: Thu, 05 Nov 2026 07:57:00 -0500

The kexec Makefile recognizes PowerPC only through the ppc64le spelling of
ARCH, so the canonical ARCH=powerpc used for cross builds omits the tests.
The x86 jump test is selected with IS_64_BIT from scripts/Makefile.arch,
which describes the build host rather than the compiler being used.  On
other architectures the Makefile includes no lib.mk rules at all, so
installation and runlist generation fail with missing targets.

Select x86 and PowerPC from the target ARCH when it is given and from the
host's SUBARCH otherwise, without assigning ARCH, so that lib.mk keeps
choosing the compiler's native clang target.  Ask the selected compiler,
including USERCFLAGS, whether it targets a 64-bit x86 ABI and whether it
targets little-endian 64-bit PowerPC.  lib.mk expands the generated
program list before it appends USERCFLAGS to CFLAGS, so the flags are
passed explicitly to keep both probes consistent.  If the compiler cannot
be run, select the jump test so that the build fails instead of silently
dropping it.  Include lib.mk unconditionally so that unsupported targets
build, install and emit an empty runlist.

Link: https://patch.msgid.link/20261105125701.1605281-3-sashal@kernel.org
Fixes: 65e38e32a959 ("selftests/kexec: Enable secureboot tests for PowerPC")
Fixes: 7615b94b6371 ("selftests/kexec: Add x86_64 selftest for kexec-jump and exception handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: R Nageswara Sastry <rnsastry@linux.ibm.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>

 tools/testing/selftests/kexec/Makefile |   30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/kexec/Makefile~selftests-kexec-select-tests-using-the-target-compiler
+++ a/tools/testing/selftests/kexec/Makefile
@@ -1,20 +1,22 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Makefile for kexec tests
 
-ARCH ?= $(shell uname -m 2>/dev/null || echo not)
-ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
-
-ifeq ($(ARCH_PROCESSED),$(filter $(ARCH_PROCESSED),x86 ppc64le))
-TEST_PROGS := test_kexec_load.sh test_kexec_file_load.sh
-TEST_FILES := kexec_common_lib.sh
-
-include ../../../scripts/Makefile.arch
-
-ifeq ($(IS_64_BIT)$(ARCH_PROCESSED),1x86)
-TEST_PROGS += test_kexec_jump.sh
-TEST_GEN_PROGS := test_kexec_jump
+top_srcdir = ../../../..
+include $(top_srcdir)/scripts/subarch.include
+ARCH_PROCESSED := $(shell echo $(or $(ARCH),$(SUBARCH)) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+
+PROBE_CC = $(filter-out -fuse-ld=%,$(CC)) $(CFLAGS) $(USERCFLAGS) -E -P -x c -
+CC_IS_64BIT = $(shell echo __SIZEOF_LONG__ | $(PROBE_CC) || echo 8)
+PPC64LE = $(shell printf '\043if defined(__powerpc64__) && __BYTE_ORDER__ == \
+	__ORDER_LITTLE_ENDIAN__\n1\n\043endif\n' | $(PROBE_CC))
+
+ifeq ($(ARCH_PROCESSED),x86)
+TEST_PROGS = test_kexec_load.sh test_kexec_file_load.sh \
+	$(if $(filter 8,$(CC_IS_64BIT)),test_kexec_jump.sh)
+TEST_GEN_PROGS = $(if $(filter 8,$(CC_IS_64BIT)),test_kexec_jump)
+else ifneq (,$(filter powerpc ppc64le,$(ARCH_PROCESSED)))
+TEST_PROGS = $(if $(filter 1,$(PPC64LE)),test_kexec_load.sh test_kexec_file_load.sh)
 endif
+TEST_FILES = $(if $(TEST_PROGS),kexec_common_lib.sh)
 
 include ../lib.mk
-
-endif
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

