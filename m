From: akpm@linux-foundation.org
Subject: [merged] arm-add-support-for-memtest.patch removed from -mm tree
Date: Wed, 15 Apr 2015 12:30:59 -0700
Message-ID: <552ebc73.rEPvcDOp7L1+JxjX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbDOTZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir.murzin@arm.com, catalin.marinas@arm.com, hpa@zytor.com, mark.rutland@arm.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: add support for memtest
has been removed from the -mm tree.  Its filename was
     arm-add-support-for-memtest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

