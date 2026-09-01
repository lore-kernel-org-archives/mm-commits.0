Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D9305687
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221990; cv=none; b=LG/pz1FoEu6Dzk/9XyYgeIkPULIT4FjtgjGyDa8OP6thoapmyjEu59g+9M/nXs3Y7NHaZq0CdVORuAbydAr/1/awoxgBtDfqNziJwhtU+dOVdkJUOl+Nn6vSnbKhNQi9es9bAtvoIRO07FR4ThfVMfDZrdw9kYAi7XT7G+MvF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221990; c=relaxed/simple;
	bh=4cgTl5OYCFxfTIFzXVTrStW2WaXXoxT0FdEAzy8R+Eg=;
	h=Date:To:From:Subject:Message-Id; b=YsLSKjQgP9GgVbbXSUqcZbxKJu81GhipsSvEh3Nsm6NxW/jnA0yozRVPOVIBy3AvaCj0cLYJi06Ft18BidWLsRXOef8Fe5A0ZtpfFEorW6nPrfDsiqo8ielcl7H60SMzj4mFHN/TVKc9Z5fceP/gZbHIvHBGrEgMXqL54dEzU4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O+MN4Dso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O+MN4Dso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925DA1F000E9;
	Tue,  1 Sep 2026 00:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788221988;
	bh=nuBoXlsKy2WTtfZtUy8REN/wWjT+qgVfpe9THXswUlI=;
	h=Date:To:From:Subject;
	b=O+MN4DsotllebzT0YTZyWJS9s2n8HUZ/c49jxHLhC2ndTz4P8GUiEv7IAB3Dap6sW
	 bGXZfgvp1VeUJ0SDaCQYolXHpaCZ2XsRmIgpmlJuct//3gpLyK24fdGKaAxFExYTyj
	 wzQQ0xoZGSqlf7QtjXg0RhGYiDiGPmiBuprz7n8M=
Date: Mon, 31 Aug 2026 17:19:48 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,pmladek@suse.com,include@grrlz.net,hca@linux.ibm.com,gor@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,meted@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-implement-arch_do_panic.patch added to mm-nonmm-unstable branch
Message-Id: <20260901001948.925DA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: implement arch_do_panic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-implement-arch_do_panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-implement-arch_do_panic.patch

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
From: Mete Durlu <meted@linux.ibm.com>
Subject: s390: implement arch_do_panic
Date: Mon, 31 Aug 2026 11:57:16 +0200

Implement s390 specific arch_do_panic() instead of using s390 specific
ifdef sections in vpanic() code.  disabled_wait() is now called after "end
Kernel panic" marker.  No functional changes.

Link: https://lore.kernel.org/20260831-arch_do_panic-v6-2-a1e170a9e7fd@linux.ibm.com
Signed-off-by: Mete Durlu <meted@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/traps.c |    7 +++++++
 kernel/panic.c           |    3 ---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/traps.c~s390-implement-arch_do_panic
+++ a/arch/s390/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <linux/entry-common.h>
 #include <linux/kmsan.h>
 #include <linux/bug.h>
+#include <linux/panic.h>
 #include <asm/entry-percpu.h>
 #include <asm/asm-extable.h>
 #include <asm/irqflags.h>
@@ -33,6 +34,7 @@
 #include <asm/vtime.h>
 #include <asm/fpu.h>
 #include <asm/fault.h>
+#include <asm/processor.h>
 #include "entry.h"
 
 struct pgm_stat {
@@ -283,6 +285,11 @@ static void monitor_event_exception(stru
 	}
 }
 
+void arch_do_panic(void)
+{
+	disabled_wait();
+}
+
 void kernel_stack_invalid(struct pt_regs *regs)
 {
 	/*
--- a/kernel/panic.c~s390-implement-arch_do_panic
+++ a/kernel/panic.c
@@ -753,9 +753,6 @@ void vpanic(const char *fmt, va_list arg
 			 "twice on console to return to the boot prom\n");
 	}
 #endif
-#if defined(CONFIG_S390)
-	disabled_wait();
-#endif
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
 	arch_do_panic();
_

Patches currently in -mm which might be from meted@linux.ibm.com are

panic-introduce-arch_do_panic.patch
s390-implement-arch_do_panic.patch
sparc-implement-arch_do_panic.patch

