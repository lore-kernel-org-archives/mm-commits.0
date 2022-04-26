Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A456C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 20:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355149AbiDZUzS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 16:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355145AbiDZUzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 16:55:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD03F48887
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 13:52:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96641B822AF
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 20:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484AEC385A0;
        Tue, 26 Apr 2022 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651006325;
        bh=I9zAGlyNBtvWqgAFddRvfdeDaAIm0Nz4PvfHhvmrqTc=;
        h=Date:To:From:Subject:From;
        b=BXY/WC/aKR501yUmYrCwe+PYOcUqlVxuAREFbMCeug4Msr0KNLMB5luevvY4BoytG
         wYLVH/QxzMH8IZQJLEtVyXqQCQsNvpHYX5I5IQwYNk91N2X67WHhW/7EBwMBlsfZOT
         RPuVYij+/lJDYtUvy+IOY5uAXeuHxcFYmqcbl0LU=
Date:   Tue, 26 Apr 2022 13:52:04 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, luto@kernel.org,
        keescook@chromium.org, catalin.marinas@arm.com,
        alex.popov@linux.com, mark.rutland@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-stackleak-fix-current_top_of_stack.patch added to -mm tree
Message-Id: <20220426205205.484AEC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: stackleak: fix current_top_of_stack()
has been added to the -mm tree.  Its filename is
     arm64-stackleak-fix-current_top_of_stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-stackleak-fix-current_top_of_stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-stackleak-fix-current_top_of_stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: arm64: stackleak: fix current_top_of_stack()

Patch series "stackleak: fixes and rework".

This series reworks the stackleak code.  The first patch fixes some latent
issues on arm64, and the subsequent patches improve the code to improve
clarity and permit better code generation.

I started working on this as a tangent from rework to arm64's stacktrace
code.  Looking at users of the `on_*_stack()` helpers I noticed that the
assembly generated for stackleak was particularly awful as it performed a
lot of redundant work and also called instrumentable code, which isn't
sound.

The first patch fixes the major issues on arm64, and is Cc'd to stable for
backporting.

The second patch is a trivial optimization for when stackleak is
dynamically disabled.

The subsequent patches rework the way stackleak manipulates the stack
boundary values.  This is partically for clarity (e.g.  with separate
'low' and 'high' boundary variables), and also permits the compiler to
generate more optimal assembly by generating the high and low bounds from
the same base.

Patch 5 changes the way that `current->lowest_stack` is reset prior to
return to userspace.  The existing code uses an undocumented offset
relative to the top of the stack which doesn't make much sense (as thie
sometimes falls within the task's pt_regs, or sometimes adds 600+ bytes to
erase upon the next exit to userspace).  For now I've removed the offset
entirely.

Patch 7 adds stackleak_erase_on_task_stack() and
stackleak_erase_off_task_stack() that can be used when a caller knows
they're always on or off the task stack respectively, avoiding redundant
logic to check this and generate the high boundary value.  On arm64 we
always call stackleak_erase() while on the task stack, so this is used in
patch 8.

Testing the series on arm64 with a QEMU HVF VM on an M1 Macbook Pro with a
few microbenchmarks shows a small but measureable improvement when
stackleak is enabled (relative to v5.18-rc1):

* Calling getpid 1^22 times in a loop (avg 50 runs)
  
  Before: 0.652099387 seconds ( +-  0.13% )
  After:  0.641005661 seconds ( +-  0.13% )

  ~1.7% time decrease

* perf bench sched pipe (single run)

  Before: 2.138 seconds total
  After:  2.118 seconds total

  ~0.93% time decrease

I also tested "perf bench sched messaging" but the noise outweighed the
difference.

While the improvement is small, I think the improvement to clarity and
code generation is a win regardless.


This patch (of 8):

Due to some historical confusion, arm64's current_top_of_stack() isn't
what the stackleak code expects.  This could in theory result in a number
of problems, and practically results in an unnecessary performance hit. 
We can avoid this by aligning the arm64 implementation with the x86
implementation.

The arm64 implementation of current_top_of_stack() was added specifically
for stackleak in commit:

  0b3e336601b82c6a ("arm64: Add support for STACKLEAK gcc plugin")

This was intended to be equivalent to the x86 implementation, but the
implementation, semantics, and performance characteristics differ wildly:

* On x86, current_top_of_stack() returns the top of the current task's
  task stack, regardless of which stack is in active use.

  The implementation accesses a percpu variable which the x86 entry code
  maintains, and returns the location immediately above the pt_regs on
  the task stack (above which x86 has some padding).

* On arm64 current_top_of_stack() returns the top of the stack in active
  use (i.e. the one which is currently being used).

  The implementation checks the SP against a number of
  potentially-accessible stacks, and will BUG() if no stack is found.

The core stackleak_erase() code determines the upper bound of stack to
erase with:

| if (on_thread_stack())
|         boundary = current_stack_pointer;
| else
|         boundary = current_top_of_stack();

On arm64 stackleak_erase() is always called on a task stack, and
on_thread_stack() should always be true.  On x86, stackleak_erase() is
mostly called on a trampoline stack, and is sometimes called on a task
stack.

Currently, this results in a lot of unnecessary code being generated for
arm64 for the impossible !on_thread_stack() case.  Some of this is
inlined, bloating stackleak_erase(), while portions of this are left
out-of-line and permitted to be instrumented (which would be a functional
problem if that code were reachable).

As a first step towards improving this, this patch aligns arm64's
implementation of current_top_of_stack() with x86's, always returning the
top of the current task's stack.  With GCC 11.1.0 this results in the bulk
of the unnecessary code being removed, including all of the out-of-line
instrumentable code.

While I don't believe there's a functional problem in practice I've marked
this as a fix since the semantic was clearly wrong, the fix itself is
simple, and other code might rely upon this in future.

Link: https://lkml.kernel.org/r/20220425115603.781311-1-mark.rutland@arm.com
Link: https://lkml.kernel.org/r/20220425115603.781311-2-mark.rutland@arm.com
Fixes: 0b3e336601b82c6a ("arm64: Add support for STACKLEAK gcc plugin")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/processor.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/processor.h~arm64-stackleak-fix-current_top_of_stack
+++ a/arch/arm64/include/asm/processor.h
@@ -381,12 +381,10 @@ long get_tagged_addr_ctrl(struct task_st
  * of header definitions for the use of task_stack_page.
  */
 
-#define current_top_of_stack()								\
-({											\
-	struct stack_info _info;							\
-	BUG_ON(!on_accessible_stack(current, current_stack_pointer, 1, &_info));	\
-	_info.high;									\
-})
+/*
+ * The top of the current task's task stack
+ */
+#define current_top_of_stack()	((unsigned long)current->stack + THREAD_SIZE)
 #define on_thread_stack()	(on_task_stack(current, current_stack_pointer, 1, NULL))
 
 #endif /* __ASSEMBLY__ */
_

Patches currently in -mm which might be from mark.rutland@arm.com are

arm64-stackleak-fix-current_top_of_stack.patch
stackleak-move-skip_erasing-check-earlier.patch
stackleak-rework-stack-low-bound-handling.patch
stackleak-clarify-variable-names.patch
stackleak-rework-stack-high-bound-handling.patch
stackleak-remove-redundant-check.patch
stackleak-add-on-off-stack-variants.patch
arm64-entry-use-stackleak_erase_on_task_stack.patch

