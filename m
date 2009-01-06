From: akpm@linux-foundation.org
Subject: + x86-hpet-allow-force-enable-on-ich10-hpet.patch added to -mm tree
Date: Mon, 05 Jan 2009 16:01:12 -0800
Message-ID: <200901060001.n0601Cwh004816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbZAFABf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 19:01:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: hpet: allow force enable on ICH10 HPET
has been added to the -mm tree.  Its filename is
     x86-hpet-allow-force-enable-on-ich10-hpet.patch

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
Subject: x86: hpet: allow force enable on ICH10 HPET
From: Andi Kleen <andi@firstfloor.org>

Intel "Smackover" x58 BIOS don't have HPET enabled in the BIOS, so allow
to force enable it at least.  The register layout is the same as in other
recent ICHs, so all the code can be reused.

Using numerical PCI-ID because it's unlikely the PCI-ID will be used
anywhere else.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/quirks.c~x86-hpet-allow-force-enable-on-ich10-hpet arch/x86/kernel/quirks.c
--- a/arch/x86/kernel/quirks.c~x86-hpet-allow-force-enable-on-ich10-hpet
+++ a/arch/x86/kernel/quirks.c
@@ -172,7 +172,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH9_7,
 			 ich_force_enable_hpet);
