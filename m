Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457CE3264E6
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777053540; cv=none; b=KJ+M8L0/Rhq5dJUAFpT9aTdMFUrYVHilL6XfaijQMbJBVThZ2vtXjuZwU3vDFcgJl1przCQU8ntBbGCk9+UEV9JxGeUxJLTJerppygYGj9cZsZ3CgwenZZYjGhi+Kv0TY4QBXZXXJGew5gNzHPWsDhQiRYP925122yUwWLBQoHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777053540; c=relaxed/simple;
	bh=ijBIFJn8Xb3DhKn8e4Ny35h57RtezYm099iTSXRXGMo=;
	h=Date:To:From:Subject:Message-Id; b=bSM1HI97H71OufsXGAqURz9YijDmNeX2H4IMzk2nxNkW2S/sPAm7J/ItiiPSR71RpIg7tmmOL8q4PgjN+s6U6ezWHrFiALTI8WXUzz4Z6IOfs/jY2naxGzIsqh/vSqKyYSveiEWCFWtpaQEJM5K8/XokFUl8skSYg7R6BKJ+zAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pQQY+x/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pQQY+x/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB37C19425;
	Fri, 24 Apr 2026 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777053540;
	bh=ijBIFJn8Xb3DhKn8e4Ny35h57RtezYm099iTSXRXGMo=;
	h=Date:To:From:Subject:From;
	b=pQQY+x/iGdWfHyzJTdsFZe9r3XZFX/9lgV4Tx6OzwofR7kyDMx9KtzxPa3JuLkn3v
	 HZzNeAEYKYm0Ku4AFRJXzKrp8KotgvnvV85YJUC/RUYC5Y1EufZBQdGX/QOu500nDL
	 46114pqD+zcGOt5UtWFIM9UeaT6ujcN3jP3tKl+I=
Date: Fri, 24 Apr 2026 10:58:59 -0700
To: mm-commits@vger.kernel.org,zaslonko@linux.ibm.com,ptikhomirov@virtuozzo.com,ojeda@kernel.org,oberpar@linux.ibm.com,nathan@kernel.org,masahiroy@kernel.org,linux@weissschuh.net,arnd@arndb.de,khorenko@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch added to mm-nonmm-unstable branch
Message-Id: <20260424175859.EBB37C19425@smtp.kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile~gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes
+++ a/Makefile
@@ -824,7 +824,7 @@ all: vmlinux
 
 CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
 ifdef CONFIG_CC_IS_GCC
-CFLAGS_GCOV	+= -fno-tree-loop-im
+CFLAGS_GCOV	+= -fno-tree-loop-im -fprofile-update=prefer-atomic
 endif
 export CFLAGS_GCOV
 
_

Patches currently in -mm which might be from khorenko@virtuozzo.com are

gcov-use-atomic-counter-updates-to-fix-concurrent-access-crashes.patch

