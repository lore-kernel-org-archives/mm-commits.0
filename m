Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30004B672
	for <mm-commits@vger.kernel.org>; Sat, 23 May 2026 04:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779510284; cv=none; b=GnmaRKl6eQgBzrU8Q/dNxVo9h7BIcmFvl2r6KZ4Vndgyv5pQHvfedgqDONZazzWblhQXRgZCic8YtiNvacQbP4a5j+ePHEJRskgHxCp636D3UdILA/ZdUfrImHo4hpjoEoPXCWwM3DAHA1JLjezE5bb9BWipkfox93agWWnO7Bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779510284; c=relaxed/simple;
	bh=B+93fO6neyGzHR+kxlPITiANG2yL0vDE/6IMcsOwRCk=;
	h=Date:To:From:Subject:Message-Id; b=ON7crhMBLk1VB/nvc4jDhE3WCXlUWY2x+iZvNdI4RU0FoUEBu72aCftcElTgockZrdDCXLhOaJsGw0RKq1TEHdtQ9QnnJc5q6Px1/mbQEFC5hLLFvP7WqLx8k8t1irJUOVSSAixWKRABfR1G+sOztla7uz+N0eSDgI6VwPgajI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DXzhhWOI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DXzhhWOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D961F000E9;
	Sat, 23 May 2026 04:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779510282;
	bh=2lvH+sdL90s9xDjF2i4fvUzqCWrRH/AbYMAmUrsbxYk=;
	h=Date:To:From:Subject;
	b=DXzhhWOI+qOSUF5D4E2NjdojeJ9bXqoemM89AuvK6MJ2vNlXzPlcacnF2fvTR6AYD
	 KBSLpj1ja+kTw4sxy+Cu4ANmeYYHaK+I/GXoSIKGW9/8FSfIsAiq7CiDBPolHXtIsL
	 KxRLp7JJpXX0jnLkGcX28du4oQ4qcM6WNIXbQQ7M=
Date: Fri, 22 May 2026 21:24:42 -0700
To: mm-commits@vger.kernel.org,davem@davemloft.net,andreas@gaisler.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-add-_mcount-prototype.patch added to mm-nonmm-unstable branch
Message-Id: <20260523042442.95D961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc: add _mcount() prototype
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     sparc-add-_mcount-prototype.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-add-_mcount-prototype.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sparc: add _mcount() prototype
Date: Fri May 22 09:20:26 PM PDT 2026

sparc64 defconfig told me

WARNING: modpost: EXPORT symbol "_mcount" [vmlinux] version generation failed, symbol will not be versioned.
Is "_mcount" prototyped in <asm/asm-prototypes.h>?

so I added it.

BTW, altering arch/sparc/include/asm/asm-prototypes.h then running `make'
doesn't compile anything, so there's a missing dependency somewhere?

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/asm-prototypes.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/include/asm/asm-prototypes.h~sparc-add-_mcount-prototype
+++ a/arch/sparc/include/asm/asm-prototypes.h
@@ -25,6 +25,7 @@ void *memcpy(void *dest, const void *src
 void *memset(void *s, int c, size_t n);
 typedef int TItype __attribute__((mode(TI)));
 TItype __multi3(TItype a, TItype b);
+void _mcount(void);
 
 s64 __ashldi3(s64, int);
 s64 __lshrdi3(s64, int);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-hugetlb_lock-aa-deadlock-in-get_huge_page_for_hwpoison-fix.patch
selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix.patch
mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix.patch
mm-swap-merge-zeromap-into-swap-table-fix-2.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes.patch
proc-rewrite-next_tgid-fix.patch
lib-nmi_backtrace-print-out-the-cpus-which-fail-to-respond-to-nmi-fix-fix.patch
sparc-add-_mcount-prototype.patch

