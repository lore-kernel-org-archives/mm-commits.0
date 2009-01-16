From: akpm@linux-foundation.org
Subject: + x86-avoid-early-crash-in-disable_local_apic.patch added to -mm tree
Date: Thu, 15 Jan 2009 16:00:10 -0800
Message-ID: <200901160000.n0G00A9R027683@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbZAPAAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 19:00:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, andi@firstfloor.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: avoid early crash in disable_local_APIC()
has been added to the -mm tree.  Its filename is
     x86-avoid-early-crash-in-disable_local_apic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

i386-fix-assumed-to-be-contiguous-leaf-page-tables-for-kmap_atomic-region.patch
x86-fully-honor-nolapic.patch
x86-avoid-early-crash-in-disable_local_apic.patch
x86-simplify-highmem-related-kconfig-entries.patch

