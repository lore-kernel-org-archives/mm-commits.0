From: akpm@linux-foundation.org
Subject: [patch 060/102] x86: use simpler API for random address requests
Date: Tue, 11 Oct 2016 13:53:56 -0700
Message-ID: <57fd5164.V3dmtzLVJWfPgIdx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38089 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbcJKUx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jason@lakedaemon.net, hpa@zytor.com, keescook@chromium.org, mingo@redhat.com, tglx@linutronix.de, tytso@mit.edu

From: Jason Cooper <jason@lakedaemon.net>
Subject: x86: use simpler API for random address requests

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can simplify
the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Link: http://lkml.kernel.org/r/20160803233913.32511-3-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process.c    |    3 +--
 arch/x86/kernel/sys_x86_64.c |    5 +----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/process.c~x86-use-simpler-api-for-random-address-requests arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~x86-use-simpler-api-for-random-address-requests
+++ a/arch/x86/kernel/process.c
@@ -509,8 +509,7 @@ unsigned long arch_align_stack(unsigned
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_page(mm->brk, 0x02000000);
 }
 
 /*
diff -puN arch/x86/kernel/sys_x86_64.c~x86-use-simpler-api-for-random-address-requests arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~x86-use-simpler-api-for-random-address-requests
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,6 @@ static void find_start_end(unsigned long
 			   unsigned long *end)
 {
 	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT)) {
-		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
 		   it to that.  This means we need to move the
@@ -112,9 +111,7 @@ static void find_start_end(unsigned long
 		*begin = 0x40000000;
 		*end = 0x80000000;
 		if (current->flags & PF_RANDOMIZE) {
-			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);
-			if (new_begin)
-				*begin = new_begin;
+			*begin = randomize_page(*begin, 0x02000000);
 		}
 	} else {
 		*begin = current->mm->mmap_legacy_base;
_
