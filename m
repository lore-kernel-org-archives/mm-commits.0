Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2E44414
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708634426; cv=none; b=iKwOs61PMP3gv2738+uPKF8o9YCI8qo70r59RW26m6I4uCgAg6Qa0i6MBYpVAeloass1A7F3Cux10XW9cx9KMcS9u7SYm2UyLAr/lZFs3xfJ6DH0cQQF2QvlPAx/PmLHHzSQIAasP/iUBN7sXWqZmllMfR1h15zwuixwe3rU5aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708634426; c=relaxed/simple;
	bh=1cLDzlhhrURZDJ3q6dfdmG/hIoHOxZlxAA9lngyuFjs=;
	h=Date:To:From:Subject:Message-Id; b=Jj/ghVh6rkvZ7E9XVffgWF1vOor+3t97GhwKc+SmPdwSyImYZf5ata1Szsi6ZU11nv9Bp/MsJKxlNMGW/VUpDXdrJUvrOp8zo2Q+VB0XE2XtQGykqryzFjF+W4OIIxxA8iV4k4lbWLozaxPySJbi07XQ6MI/FGJA6u8Yi8bhCkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bgkOUrp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bgkOUrp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BEFC433F1;
	Thu, 22 Feb 2024 20:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708634426;
	bh=1cLDzlhhrURZDJ3q6dfdmG/hIoHOxZlxAA9lngyuFjs=;
	h=Date:To:From:Subject:From;
	b=bgkOUrp1UCUAkQhoUct9gcRRhoFFlGoUrtRv7pH50nf4fkuIK668k1en5COHGN7Vx
	 eme2L1IqS/3szi19+5RX+QcF1KZQ9oyikSp6nEXOM/c12fIvAqSOIsdfL8fzlyS5o0
	 xpZ46Y4oEfK87D+6MeakxfaU6hmyXOoGj7JVUZIw=
Date: Thu, 22 Feb 2024 12:40:25 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,mingo@redhat.com,luto@kernel.org,dave.hansen@intel.com,bp@alien8.de,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch added to mm-unstable branch
Message-Id: <20240222204026.54BEFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: further clarify switch_mm_irqs_off() documentation
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch

This patch will later appear in the mm-unstable branch at
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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: x86/mm: further clarify switch_mm_irqs_off() documentation
Date: Thu, 22 Feb 2024 19:09:10 +0000

Commit accf6b23d1e5a ("x86/mm: clarify "prev" usage in
switch_mm_irqs_off()") attempted to clarify x86's usage of the arguments
passed by generic code, specifically the "prev" argument the is unused by
x86.  However, it could have done a better job with the comment above
switch_mm_irqs_off().  Rewrite this comment according to Dave Hansen's
suggestion.

Link: https://lkml.kernel.org/r/20240222190911.1903054-1-yosryahmed@google.com
Fixes: accf6b23d1e5 ("x86/mm: clarify "prev" usage in switch_mm_irqs_off()")
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/tlb.c~x86-mm-further-clarify-switch_mm_irqs_off-documentation
+++ a/arch/x86/mm/tlb.c
@@ -493,10 +493,10 @@ static inline void cr4_update_pce_mm(str
 #endif
 
 /*
- * The "prev" argument passed by the caller does not always match CR3. For
- * example, the scheduler passes in active_mm when switching from lazy TLB mode
- * to normal mode, but switch_mm_irqs_off() can be called from x86 code without
- * updating active_mm. Use cpu_tlbstate.loaded_mm instead.
+ * This optimizes when not actually switching mm's.  Some architectures use the
+ * 'unused' argument for this optimization, but x86 must use
+ * 'cpu_tlbstate.loaded_mm' instead because it does not always keep
+ * 'current->active_mm' up to date.
  */
 void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 			struct task_struct *tsk)
_

Patches currently in -mm which might be from yosryahmed@google.com are

x86-mm-further-clarify-switch_mm_irqs_off-documentation.patch
x86-mm-always-pass-null-as-the-first-argument-of-switch_mm_irqs_off.patch

