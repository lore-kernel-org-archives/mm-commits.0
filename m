Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB502AD0D
	for <mm-commits@vger.kernel.org>; Mon, 13 Oct 2025 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760397443; cv=none; b=pRyKxl/LhRXgB4198gSLAyc6mN7G5tJSRfSsSU8XjlmGX5/uelLcHi/oWgNF7gzz12AhP49nYQXBVZJo7IM8IJJDsERdonrczm2n6T0VlIrmjzAyIAJsyQ4hS2Jiz5vyCFaDexkqzOGKrbcjNN+LvpCQa6LEDAifgFjz1j/GomY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760397443; c=relaxed/simple;
	bh=XTbqAtYJlYSn+gPw9Y5KhQ8Cb8Ph/M1gux8ZJOIEaNg=;
	h=Date:To:From:Subject:Message-Id; b=XiCLAuMrvNAFw7nUtJ6bTGcef5TsxHe2CdNcgCSCs4I81Ia/LQ+bG3ewalAAyfOXLI0kaxoBBWwYASDR0kjKOhjUtltrudJ44EoCW0wBhNWErefwkPMVx7HBk/6ShKjdBfZMUu9bPLzgT/N54ZQJkB1vaO8/+FW+8hFdCeIQp/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xeqtGtYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xeqtGtYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB036C4CEE7;
	Mon, 13 Oct 2025 23:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760397442;
	bh=XTbqAtYJlYSn+gPw9Y5KhQ8Cb8Ph/M1gux8ZJOIEaNg=;
	h=Date:To:From:Subject:From;
	b=xeqtGtYSSvqUKZ9zn/qdNe9UP0C03x6KCVv6BMr3ikQ8ilMBguikD2zA9XbI6oBiA
	 u3zoYCrmRjpEveosUKvPXdoSX/cHf0bUy7KbYhVnaaEIBiDlIJkqELZARx80AN9PXn
	 TSxUprhwk6ZF/XNIaOVx4/kb+wojDsN6tOZxDBPk=
Date: Mon, 13 Oct 2025 16:17:22 -0700
To: mm-commits@vger.kernel.org,luc.vanoostenryck@gmail.com,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + compiler-remove-arch_sel.patch added to mm-nonmm-unstable branch
Message-Id: <20251013231722.AB036C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: compiler.h: remove ARCH_SEL()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     compiler-remove-arch_sel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/compiler-remove-arch_sel.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Subject: compiler.h: remove ARCH_SEL()
Date: Mon, 13 Oct 2025 11:12:02 +0200

Its last user was removed in commit 8ea815399c3f ("compiler: remove
__ADDRESSABLE_ASM{_STR,}() again").

Link: https://lkml.kernel.org/r/20251013-arch-sel-v1-1-7eef9b22ceb0@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/compiler.h~compiler-remove-arch_sel
+++ a/include/linux/compiler.h
@@ -269,12 +269,6 @@ static inline void *offset_to_ptr(const
 
 #endif /* __ASSEMBLY__ */
 
-#ifdef CONFIG_64BIT
-#define ARCH_SEL(a,b) a
-#else
-#define ARCH_SEL(a,b) b
-#endif
-
 /*
  * Force the compiler to emit 'sym' as a symbol, so that we can reference
  * it from inline assembler. Necessary in case 'sym' could be inlined
_

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

compiler-remove-arch_sel.patch

