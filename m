From: akpm@linux-foundation.org
Subject: [merged] x86-avoid-early-crash-in-disable_local_apic.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:03 -0800
Message-ID: <200901261904.n0QJ43BL029439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbZAZTEw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: avoid early crash in disable_local_APIC()
has been removed from the -mm tree.  Its filename was
     x86-avoid-early-crash-in-disable_local_apic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: avoid early crash in disable_local_APIC()
From: "Jan Beulich" <jbeulich@novell.com>

E.g. when called due to an early panic.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/x86/kernel/apic.c~x86-avoid-early-crash-in-disable_local_apic arch/x86/kernel/apic.c
--- a/arch/x86/kernel/apic.c~x86-avoid-early-crash-in-disable_local_apic
+++ a/arch/x86/kernel/apic.c
@@ -895,6 +895,10 @@ void disable_local_APIC(void)
 {
 	unsigned int value;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
 	clear_local_APIC();
 
 	/*
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch

