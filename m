From: akpm@linux-foundation.org
Subject: + arm64-add-support-for-memtest.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:41:53 -0700
Message-ID: <5501fa11.6Vmdi2xX9NBQmJOL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: add support for memtest
has been added to the -mm tree.  Its filename is
     arm64-add-support-for-memtest.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-add-support-for-memtest.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-add-support-for-memtest.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: arm64: add support for memtest

Add support for memtest command line option.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/arm64/mm/init.c~arm64-add-support-for-memtest arch/arm64/mm/init.c
--- a/arch/arm64/mm/init.c~arm64-add-support-for-memtest
+++ a/arch/arm64/mm/init.c
@@ -190,6 +190,8 @@ void __init bootmem_init(void)
 	min = PFN_UP(memblock_start_of_DRAM());
 	max = PFN_DOWN(memblock_end_of_DRAM());
 
+	early_memtest(min << PAGE_SHIFT, max << PAGE_SHIFT);
+
 	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(), so must be
 	 * done after the fixed reservations.
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
linux-next.patch

