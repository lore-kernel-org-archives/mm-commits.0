From: akpm@linux-foundation.org
Subject: [merged] x86-hpet-allow-force-enable-on-ich10-hpet.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:03:52 -0800
Message-ID: <200901261903.n0QJ3q2K029162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbZAZTEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:04:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: hpet: allow force enable on ICH10 HPET
has been removed from the -mm tree.  Its filename was
     x86-hpet-allow-force-enable-on-ich10-hpet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
