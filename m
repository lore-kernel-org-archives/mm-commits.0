From: akpm@linux-foundation.org
Subject: + arm-add-support-for-memtest.patch added to -mm tree
Date: Thu, 12 Mar 2015 13:41:55 -0700
Message-ID: <5501fa13.+4RMXKHjbYDQ79P+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLUl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Mar 2015 16:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: add support for memtest
has been added to the -mm tree.  Its filename is
     arm-add-support-for-memtest.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-add-support-for-memtest.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-add-support-for-memtest.patch

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
Subject: arm: add support for memtest

Add support for memtest command line option.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/arm/mm/init.c~arm-add-support-for-memtest arch/arm/mm/init.c
--- a/arch/arm/mm/init.c~arm-add-support-for-memtest
+++ a/arch/arm/mm/init.c
@@ -335,6 +335,9 @@ void __init bootmem_init(void)
 
 	find_limits(&min, &max_low, &max_high);
 
+	early_memtest((phys_addr_t)min << PAGE_SHIFT,
+		      (phys_addr_t)max_low << PAGE_SHIFT);
+
 	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(),
 	 * so must be done after the fixed reservations
_

Patches currently in -mm which might be from vladimir.murzin@arm.com are

mm-move-memtest-under-mm.patch
memtest-use-phys_addr_t-for-physical-addresses.patch
arm64-add-support-for-memtest.patch
arm-add-support-for-memtest.patch
kconfig-memtest-update-number-of-test-patterns-up-to-17.patch
documentation-update-arch-list-in-the-memtest-entry.patch
linux-next.patch

