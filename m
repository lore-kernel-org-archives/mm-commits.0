From: akpm@linux-foundation.org
Subject: - all-transmeta-cpus-have-constant-tscs.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:52 -0800
Message-ID: <200702082152.l18Lqqul027668@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41425 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423427AbXBHVw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:52:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     All Transmeta CPUs have constant TSCs
has been removed from the -mm tree.  Its filename was
     all-transmeta-cpus-have-constant-tscs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: All Transmeta CPUs have constant TSCs
From: "H. Peter Anvin" <hpa@zytor.com>

All Transmeta CPUs ever produced have constant-rate TSCs.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/transmeta.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/i386/kernel/cpu/transmeta.c~all-transmeta-cpus-have-constant-tscs arch/i386/kernel/cpu/transmeta.c
--- a/arch/i386/kernel/cpu/transmeta.c~all-transmeta-cpus-have-constant-tscs
+++ a/arch/i386/kernel/cpu/transmeta.c
@@ -72,6 +72,9 @@ static void __cpuinit init_transmeta(str
 	wrmsr(0x80860004, ~0, uk);
 	c->x86_capability[0] = cpuid_edx(0x00000001);
 	wrmsr(0x80860004, cap_mask, uk);
+
+	/* All Transmeta CPUs have a constant TSC */
+	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
 	
 	/* If we can run i686 user-space code, call us an i686 */
 #define USER686 (X86_FEATURE_TSC|X86_FEATURE_CX8|X86_FEATURE_CMOV)
_

Patches currently in -mm which might be from hpa@zytor.com are

8250-uart-backup-timer.patch
