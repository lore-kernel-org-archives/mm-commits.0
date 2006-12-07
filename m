From: akpm@osdl.org
Subject: - avr32-fixup-kprobes-preemption-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:58:50 -0800
Message-ID: <200612072258.kB7Mwon4029435@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163661AbWLGW66 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     avr32: fixup kprobes preemption handling
has been removed from the -mm tree.  Its filename was
     avr32-fixup-kprobes-preemption-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: avr32: fixup kprobes preemption handling
From: Paul Mundt <lethal@linux-sh.org>

While working on SH kprobes, I noticed that avr32 got the preemption
handling wrong in the no probe case.  The idea is that upon entry of
kprobe_handler() preemption is disabled outright across the life of the
kprobe, only to be re-enabled in post_kprobe_handler().

However, in the event that the probe is never activated, there's never any
chance of hitting the post probe handler, which allows for the current
avr32 implementation to disable preemption indefinitely, as it's currently
missing a re-enable when no probe is activated.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/avr32/kernel/kprobes.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/avr32/kernel/kprobes.c~avr32-fixup-kprobes-preemption-handling arch/avr32/kernel/kprobes.c
--- a/arch/avr32/kernel/kprobes.c~avr32-fixup-kprobes-preemption-handling
+++ a/arch/avr32/kernel/kprobes.c
@@ -154,6 +154,7 @@ ss_probe:
 	return 1;
 
 no_kprobe:
+	preempt_enable_no_resched();
 	return ret;
 }
 
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
remove-zone_dma-remains-from-sh-sh64.patch
generic-ioremap_page_range-sh-conversion.patch
generic-ioremap_page_range-sh64-conversion.patch

