Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E430DEDC
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 00:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221987; cv=none; b=svdPEUG3Uk+y63ZEl7EE+vK/0LP8+dpqKV8BNRazLevZokWhnQaq1MhCRliHRrZVvCk1Ks/Eq3qF92HjOvWjjqwzjbLZDsXessCJGtFXYSazDVfwoyF8TzJDd6IQ/v2QvThjRZcsvvWGZ62Bbs9zbgagR1i863a8uLkTSsNNOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221987; c=relaxed/simple;
	bh=65RtXc5dnjZ83nkqB1LgjqhVEN0ZPxk8sotPAjtMMXg=;
	h=Date:To:From:Subject:Message-Id; b=rYX5+EQaHd8SATcVoLKbCIFdr0r3GIlZEdXJZ7fOlu7xCCz7Vm4g5/DoD1b6ShOMLIR63ALq+KSYdizBmaGyHGRhZeC6QfkIbFMIuCdX6Ha9M5oPvIm9+ycNf4SSZIN4LM9Q/uHqTxK8wZ+jDdd6yS2lx7Las5pEMl9lJb4NEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J7svU1R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J7svU1R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF351F000E9;
	Tue,  1 Sep 2026 00:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788221986;
	bh=t09JBOVLpSsJoUmc971mHdOgFbzSivIpICiTcBv5qG8=;
	h=Date:To:From:Subject;
	b=J7svU1R+IRKRN9c+NZP6zyVeynn8wTumc+cl/f9u7QstARb9NJac4UEKhWF0DhWv5
	 W/Z2lclf20La+6ROuJoNpyywvetb11xvz43uIIE7epvUIWwOVZiwtux0iRc+SHpr6n
	 pIP9RLVhWcmBnL2qAhspXxn/mGjy94s5cuTcHwLc=
Date: Mon, 31 Aug 2026 17:19:45 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,pmladek@suse.com,include@grrlz.net,hca@linux.ibm.com,gor@linux.ibm.com,davem@davemloft.net,borntraeger@linux.ibm.com,andreas@gaisler.com,akpm@linux-foundation.org,agordeev@linux.ibm.com,meted@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + panic-introduce-arch_do_panic.patch added to mm-nonmm-unstable branch
Message-Id: <20260901001946.1BF351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: panic: introduce arch_do_panic
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     panic-introduce-arch_do_panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/panic-introduce-arch_do_panic.patch

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
Subject: panic: introduce arch_do_panic
Date: Mon, 31 Aug 2026 11:57:15 +0200

Patch series "Introduce arch_do_panic", v6.

Replace architecture-specific ifdef sections in vpanic() with a clean
arch_do_panic() hook.  Currently s390 and sparc embed their panic handlers
directly in vpanic() using preprocessor conditionals, making the common
code path harder to maintain.

Introduce arch_do_panic() as an architecture extension point called at the
end of vpanic().  Architectures can use this hook to implement their
specific panic handling without polluting the generic panic code.

Remove s390s ifdef block in vpanic() and move the corresponding code block
to s390s own arch_do_panic() implementation in architecture specific code.

Move sparc panic handling from ifdef blocks to arch_do_panic().  Remove
the preprocessor conditionals from vpanic() and place the Stop-A
enablement code in architecture-specific files where it belongs.  Stop-A
enablement markers are now printed after "end Kernel panic" line.  To me,
there are no better alternatives other than setup.c to put sparc's
arch_do_panic() implementation.  The other files under arch/sparc/kernel
are either divided to *_32.c and *_64.c variants, which mean code
duplication, or unrelated.

The cleanup reduces vpanic() complexity and establishes a pattern for
other architectures needing custom panic behavior.  No functional changes,
only minor print order changes.


This patch (of 3):

Introduce a hook for architectures to put their specific panic handlers. 
s390 and sparc already have ifdef preprocessor checks to execute
architecture specific code.  Pave the way for vpanic() cleanup.

Link: https://lore.kernel.org/20260831-arch_do_panic-v6-1-a1e170a9e7fd@linux.ibm.com
Link: https://lore.kernel.org/all/20260730-arch_do_panic-v3-0-d5401e683cdb@linux.ibm.com/ [1]
Signed-off-by: Mete Durlu <meted@linux.ibm.com>
Reviewed-by: Bradley Morgan <include@grrlz.net>
Suggested-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/panic.h |    2 ++
 kernel/panic.c        |    3 +++
 2 files changed, 5 insertions(+)

--- a/include/linux/panic.h~panic-introduce-arch_do_panic
+++ a/include/linux/panic.h
@@ -110,4 +110,6 @@ extern void add_taint(unsigned flag, enu
 extern int test_taint(unsigned flag);
 extern unsigned long get_taint(void);
 
+void arch_do_panic(void);
+
 #endif	/* _LINUX_PANIC_H */
--- a/kernel/panic.c~panic-introduce-arch_do_panic
+++ a/kernel/panic.c
@@ -567,6 +567,8 @@ static void panic_other_cpus_shutdown(bo
 		crash_smp_send_stop();
 }
 
+void __weak arch_do_panic(void) {}
+
 /**
  * vpanic - halt the system
  * @fmt: The text string to print
@@ -756,6 +758,7 @@ void vpanic(const char *fmt, va_list arg
 #endif
 	pr_emerg("---[ end Kernel panic - not syncing: %s ]---\n", buf);
 
+	arch_do_panic();
 	/* Do not scroll important messages printed above */
 	suppress_printk = 1;
 
_

Patches currently in -mm which might be from meted@linux.ibm.com are

panic-introduce-arch_do_panic.patch
s390-implement-arch_do_panic.patch
sparc-implement-arch_do_panic.patch

