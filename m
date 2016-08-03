From: akpm@linux-foundation.org
Subject: + arm-use-simpler-api-for-random-address-requests.patch added to
 -mm tree
Date: Wed, 03 Aug 2016 16:57:06 -0700
Message-ID: <57a284d2.90zIqygthAO7qVUF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbcHCX6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 19:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason@lakedaemon.net, catalin.marinas@arm.com, keescook@chromium.org, linux@arm.linux.org.uk, tytso@mit.edu, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: use simpler API for random address requests
has been added to the -mm tree.  Its filename is
     arm-use-simpler-api-for-random-address-requests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-use-simpler-api-for-random-address-requests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-use-simpler-api-for-random-address-requests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jason Cooper <jason@lakedaemon.net>
Subject: ARM: use simpler API for random address requests

Currently, all callers to randomize_range() set the length to 0 and
calculate end by adding a constant to the start address.  We can simplify
the API to remove a bunch of needless checks and variables.

Use the new randomize_addr(start, range) call to set the requested
address.

Link: http://lkml.kernel.org/r/20160803233913.32511-4-jason@lakedaemon.net
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/process.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/arm/kernel/process.c~arm-use-simpler-api-for-random-address-requests arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~arm-use-simpler-api-for-random-address-requests
+++ a/arch/arm/kernel/process.c
@@ -318,8 +318,7 @@ unsigned long get_wchan(struct task_stru
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
-	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_page(mm->brk, 0x02000000);
 }
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from jason@lakedaemon.net are

random-simplify-api-for-random-address-requests.patch
x86-use-simpler-api-for-random-address-requests.patch
arm-use-simpler-api-for-random-address-requests.patch
arm64-use-simpler-api-for-random-address-requests.patch
tile-use-simpler-api-for-random-address-requests.patch
unicore32-use-simpler-api-for-random-address-requests.patch
random-remove-unused-randomize_range.patch

