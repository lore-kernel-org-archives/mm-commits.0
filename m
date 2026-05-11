Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFAC33F5BA;
	Mon, 11 May 2026 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778542065; cv=none; b=cLUv2De/fdEzBvpx5/u0aFijsRnPcYmfCYoZn3G4UjiFny5n2uRyAisW0rAT+tBva6upUMVf8oH6PaZ/pZf9BsuN3Ppc4csqBqfw2rp+VpayGbVigQHxCS28AJXf8aCgedc0a4rSMEn8iB8vg3aNL7d/lO6pG1YfJtoFh52lgQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778542065; c=relaxed/simple;
	bh=ieBgu9am0VQHY0paHtbko4O+0J7K7RPqj8F9Z25VaKo=;
	h=Date:To:From:Subject:Message-Id; b=Sx0XuimVqPnXhWSh6Dt6qTBnb28lr12MQ6M22fWKahcbZ2CiAJESGfVFwLFzLRbSg7tBxNfauZG89pI5c8YMvfpfIcqXn1WQusPfDsuEw9UiOTerlmUmOO7T5F6VWR25wKv8DPLQKBCwLgg85kZx++alocsndXspqILBl3CDJ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F2fpMxcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F2fpMxcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08D3C2BCB0;
	Mon, 11 May 2026 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778542064;
	bh=ieBgu9am0VQHY0paHtbko4O+0J7K7RPqj8F9Z25VaKo=;
	h=Date:To:From:Subject:From;
	b=F2fpMxcyhI4j4/I0cFX86rTuNLRK+d3f86R/YV5E11XCwJpiQsGbj4pzU2dUm/XXr
	 HTp0EyRpkmG6cyXgpfvNUyPw5+R55xBqwzUS54IaEnPfAKqfYvZnE/rR1Rd0LrpIiU
	 vBuqABRIXRFD9eG00rhhpfjlVObmBwEJ5ZGJd2bQ=
Date: Mon, 11 May 2026 16:27:44 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,stable@vger.kernel.org,ptikhomirov@virtuozzo.com,ojeda@kernel.org,oberpar@linux.ibm.com,nathan@kernel.org,masahiroy@kernel.org,linux@weissschuh.net,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch removed from -mm tree
Message-Id: <20260511232744.A08D3C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: gcov: use atomic counter updates to fix concurrent access crashes
has been removed from the -mm tree.  Its filename was
     gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: gcov: use atomic counter updates to fix concurrent access crashes
Date: Wed, 22 Apr 2026 15:51:12 +0300

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
the top-level Makefile.  On architectures where the target supports atomic
profile updates (x86_64, arm64, ...) GCC emits atomic instructions (e.g. 
lock addq) for GCOV counter updates instead of plain load/store, which
prevents the compiler from merging counters with loop induction variables
and fixes the observed concurrent-access crash.

On architectures that do not support atomic profile updates (m68k and
other small/UP targets) GCC silently falls back to the non-atomic 'single'
mode, so behaviour there is no worse than before this patch.

Applying this globally rather than per-subsystem not only addresses the
observed crash in zlib but makes GCOV coverage data more consistent
overall, preventing similar issues in any kernel code path that may
execute concurrently.

Link: https://lore.kernel.org/20260422125112.3583649-2-khorenko@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile~gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes
+++ a/Makefile
@@ -826,7 +826,7 @@ all: vmlinux
 
 CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
 ifdef CONFIG_CC_IS_GCC
-CFLAGS_GCOV	+= -fno-tree-loop-im
+CFLAGS_GCOV	+= -fno-tree-loop-im -fprofile-update=prefer-atomic
 endif
 export CFLAGS_GCOV
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are


