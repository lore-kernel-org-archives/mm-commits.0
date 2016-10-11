From: akpm@linux-foundation.org
Subject: [patch 064/102] unicore32: use simpler API for random address
 requests
Date: Tue, 11 Oct 2016 13:54:08 -0700
Message-ID: <57fd5170.tnxLk48KX9zMS45s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcJKUyJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jason@lakedaemon.net, gxt@mprc.pku.edu.cn, keescook@chromium.org, tytso@mit.edu

From: Jason Cooper <jason@lakedaemon.net>
Subject: unicore32: use simpler API for random address requests

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can simplify
the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Link: http://lkml.kernel.org/r/20160803233913.32511-7-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/kernel/process.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/unicore32/kernel/process.c~unicore32-use-simpler-api-for-random-address-requests arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~unicore32-use-simpler-api-for-random-address-requests
+++ a/arch/unicore32/kernel/process.c
@@ -295,8 +295,7 @@ unsigned long get_wchan(struct task_stru
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_page(mm->brk, 0x02000000);
 }
 
 /*
_
