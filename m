Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9572D47F1
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 23:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778542127; cv=none; b=mkXIiFHQcI9JIW4yc6RVmXcGl5kv0EVU6BmrcxFv/E18XZfg/Ay/0/E9sYeM4wA2RCPXY19z3vIAF3avxeyPS6iKy0mjpC83w/J66sCPxnhAtGLTLx+IxBJEsuIWpsC2Hhd4NTHykZsycowqm2gp3xLT1CFqSYf7Ly+e6bjn1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778542127; c=relaxed/simple;
	bh=XBiW8hnVusyeFSsGSTk8AeowlQBWvnmAYZbeJv0etms=;
	h=Date:To:From:Subject:Message-Id; b=Ozp2B2lJHQCZlFgXzycN4F4CkKHSTTwIQDe9JO4FCK5vL9KA4bY3c/D1zjW0XA8eIT7AeydcLT5pGhf0AvaPyrkM4m3cxNpUhUe6yk4gXNtTVcgoqRZ1dexLTbuD3VTh04iLkbZQ8Ox/fPxE+BoUWyzCrOebN+bFCG6nGCphpm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IceO3pXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IceO3pXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDFDC2BCB0;
	Mon, 11 May 2026 23:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778542127;
	bh=XBiW8hnVusyeFSsGSTk8AeowlQBWvnmAYZbeJv0etms=;
	h=Date:To:From:Subject:From;
	b=IceO3pXH7FBpHhGKgAguUfOPvEQuelIs5mV3WzR3sk2YNzdn08di7LrnxIlwvZZ3l
	 l9C9AEii1UxhQDhBNWpL2EosgDj0Dc3lgzbFMtbGgUbIZL85sxIzQ+7AuAVCnCA8y3
	 sqyTa/ec/ADlCUuewefKgr3lPki9ghJSAyX8BYiM=
Date: Mon, 11 May 2026 16:28:46 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,ptikhomirov@virtuozzo.com,ojeda@kernel.org,oberpar@linux.ibm.com,nathan@kernel.org,masahiroy@kernel.org,linux@weissschuh.net,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch added to mm-nonmm-unstable branch
Message-Id: <20260511232847.4FDFDC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gcov: use atomic counter updates to fix concurrent access crashes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

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
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: gcov: use atomic counter updates to fix concurrent access crashes
Date: Mon, 11 May 2026 12:50:52 +0200

GCC's GCOV instrumentation can merge global branch counters with loop
induction variables as an optimization.  In inflate_fast(), the inner copy
loops get transformed so that the GCOV counter value is loaded multiple
times to compute the loop base address, start index, and end bound.  Since
GCOV counters are global (not per-CPU), concurrent execution on different
CPUs causes the counter to change between loads, producing inconsistent
values and out-of-bounds memory writes.

The crash manifests during IPComp (IP Payload Compression) processing when
inflate_fast() runs concurrently on multiple CPUs:

  BUG: unable to handle page fault for address: ffffd0a3c0902ffa
  RIP: inflate_fast+1431
  Call Trace:
   zlib_inflate
   __deflate_decompress
   crypto_comp_decompress
   ipcomp_decompress [xfrm_ipcomp]
   ipcomp_input [xfrm_ipcomp]
   xfrm_input

At the crash point, the compiler generated three loads from the same
global GCOV counter (__gcov0.inflate_fast+216) to compute base, start, and
end for an indexed loop.  Another CPU modified the counter between loads,
making the values inconsistent - the write went 3.4 MB past a 65 KB
buffer.

Add -fprofile-update=prefer-atomic to CFLAGS_GCOV at the global level in
the top-level Makefile, guarded by a try-run compile test.  The test
compiles a minimal program with and without -fprofile-update=prefer-atomic
using the full KBUILD_CFLAGS, then compares undefined symbols in the
resulting object files.  If prefer-atomic introduces new undefined
references (such as __atomic_fetch_add_8 on i386 or __aarch64_ldadd8_relax
on arm64 with outline-atomics), the flag is not added -- the kernel does
not link against libatomic.

On architectures where GCC inlines 64-bit atomic counter updates (x86_64,
s390, ...) the test passes and the flag is enabled, preventing the
compiler from merging counters with loop induction variables and fixing
the observed concurrent-access crash.

On architectures where the flag would introduce libatomic dependencies, it
is silently omitted and behaviour is no worse than before this patch.

Move the CFLAGS_GCOV block from its original position (before the arch
Makefile include) to after the core KBUILD_CFLAGS assignments but before
the scripts/Makefile.gcc-plugins include.  This placement ensures the
try-run test sees arch-specific flags (-m32, -march=,
-mno-outline-atomics) while avoiding GCC plugin flags (-fplugin=) that
would break the test on clean builds when plugin shared objects do not yet
exist.

Link: https://lore.kernel.org/20260511105052.417187-2-khorenko@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/Makefile~gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes
+++ a/Makefile
@@ -824,12 +824,6 @@ endif # KBUILD_EXTMOD
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
-CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
-ifdef CONFIG_CC_IS_GCC
-CFLAGS_GCOV	+= -fno-tree-loop-im
-endif
-export CFLAGS_GCOV
-
 # The arch Makefiles can override CC_FLAGS_FTRACE. We may also append it later.
 ifdef CONFIG_FUNCTION_TRACER
   CC_FLAGS_FTRACE := -pg
@@ -1147,6 +1141,27 @@ endif
 # Ensure compilers do not transform certain loops into calls to wcslen()
 KBUILD_CFLAGS += -fno-builtin-wcslen
 
+CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
+ifdef CONFIG_CC_IS_GCC
+CFLAGS_GCOV	+= -fno-tree-loop-im
+# Use atomic counter updates to avoid concurrent-access crashes in GCOV.
+# Only enable if -fprofile-update=prefer-atomic does not introduce new
+# undefined symbols (e.g. libatomic calls that the kernel cannot link).
+CFLAGS_GCOV	+= $(call try-run,\
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
+	-ftest-coverage -x c - -c -o "$$TMP.base" && \
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
+	-ftest-coverage -fprofile-update=prefer-atomic \
+	-x c - -c -o "$$TMP" && \
+	$(NM) "$$TMP.base" | grep ' U ' > "$$TMP.ubase" || true ; \
+	$(NM) "$$TMP" | grep ' U ' > "$$TMP.utest" || true ; \
+	cmp -s "$$TMP.ubase" "$$TMP.utest",\
+	-fprofile-update=prefer-atomic)
+endif
+export CFLAGS_GCOV
+
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += -fmacro-prefix-map=$(srcroot)/=
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

