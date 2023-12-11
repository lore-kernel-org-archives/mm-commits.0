Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7557493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J75jWoFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A8C433C7;
	Mon, 11 Dec 2023 01:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257808;
	bh=+DbQct3bUfHx1XrULe5iFGo06iB9HAGcWLl9DsPZDm8=;
	h=Date:To:From:Subject:From;
	b=J75jWoFI1K5yI0uinVqCHGynjzADz6E+zpb/DpFFWdU63J2YxwfdJBcqFe6AMEd0N
	 luOLfSxKPAueSna0ntOir43dYmrAPSuLBvCokS7VjwGsmaQWvF0VaixYkaQGwfP2bv
	 Z41Zk/7YWBvWLnXDMntqNR/ACLvSBxjOfb0OwmCM=
Date: Sun, 10 Dec 2023 17:23:28 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch removed from -mm tree
Message-Id: <20231211012328.757A8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: traps: add internal prototypes for functions only called from asm
has been removed from the -mm tree.  Its filename was
     hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: traps: add internal prototypes for functions only called from asm
Date: Thu, 30 Nov 2023 15:58:32 -0700

Clang warns:

  arch/hexagon/kernel/traps.c:284:6: warning: no previous prototype for function 'do_genex' [-Wmissing-prototypes]
    284 | void do_genex(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:284:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    284 | void do_genex(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:341:6: warning: no previous prototype for function 'do_trap0' [-Wmissing-prototypes]
    341 | void do_trap0(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:341:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    341 | void do_trap0(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:418:6: warning: no previous prototype for function 'do_machcheck' [-Wmissing-prototypes]
    418 | void do_machcheck(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:418:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    418 | void do_machcheck(struct pt_regs *regs)
        | ^
        | static
  arch/hexagon/kernel/traps.c:428:6: warning: no previous prototype for function 'do_debug_exception' [-Wmissing-prototypes]
    428 | void do_debug_exception(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/traps.c:428:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    428 | void do_debug_exception(struct pt_regs *regs)
        | ^
        | static

These functions are only called from assembly or this translation unit,
so just add prototypes right above the definitions to silence the
warnings.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-19-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/traps.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/hexagon/kernel/traps.c~hexagon-traps-add-internal-prototypes-for-functions-only-called-from-asm
+++ a/arch/hexagon/kernel/traps.c
@@ -281,6 +281,7 @@ static void cache_error(struct pt_regs *
 /*
  * General exception handler
  */
+void do_genex(struct pt_regs *regs);
 void do_genex(struct pt_regs *regs)
 {
 	/*
@@ -331,6 +332,7 @@ void do_genex(struct pt_regs *regs)
 	}
 }
 
+void do_trap0(struct pt_regs *regs);
 void do_trap0(struct pt_regs *regs)
 {
 	syscall_fn syscall;
@@ -408,6 +410,7 @@ void do_trap0(struct pt_regs *regs)
 /*
  * Machine check exception handler
  */
+void do_machcheck(struct pt_regs *regs);
 void do_machcheck(struct pt_regs *regs)
 {
 	/* Halt and catch fire */
@@ -418,6 +421,7 @@ void do_machcheck(struct pt_regs *regs)
  * Treat this like the old 0xdb trap.
  */
 
+void do_debug_exception(struct pt_regs *regs);
 void do_debug_exception(struct pt_regs *regs)
 {
 	regs->hvmer.vmest &= ~HVM_VMEST_CAUSE_MSK;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

