From: akpm@linux-foundation.org
Subject: [patch 062/102] arm64: use simpler API for random address
 requests
Date: Tue, 11 Oct 2016 13:54:02 -0700
Message-ID: <57fd516a.ot0ycGdX/R7lmcFe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38103 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcJKUyD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jason@lakedaemon.net, catalin.marinas@arm.com, keescook@chromium.org, linux@arm.linux.org.uk, will.deacon@arm.com

From: Jason Cooper <jason@lakedaemon.net>
Subject: arm64: use simpler API for random address requests

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can simplify
the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Link: http://lkml.kernel.org/r/20160803233913.32511-5-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/process.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN arch/arm64/kernel/process.c~arm64-use-simpler-api-for-random-address-requests arch/arm64/kernel/process.c
--- a/arch/arm64/kernel/process.c~arm64-use-simpler-api-for-random-address-requests
+++ a/arch/arm64/kernel/process.c
@@ -372,12 +372,8 @@ unsigned long arch_align_stack(unsigned
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk;
-
 	if (is_compat_task())
-		range_end += 0x02000000;
+		return randomize_page(mm->brk, 0x02000000);
 	else
-		range_end += 0x40000000;
