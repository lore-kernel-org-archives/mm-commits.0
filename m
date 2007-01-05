From: akpm@osdl.org
Subject: + all-transmeta-cpus-have-constant-tscs.patch added to -mm tree
Date: Thu, 04 Jan 2007 18:40:28 -0800
Message-ID: <200701050240.l052eS6L007264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46495 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXAECkl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 21:40:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, ak@suse.de


The patch titled
     All Transmeta CPUs have constant TSCs
has been added to the -mm tree.  Its filename is
     all-transmeta-cpus-have-constant-tscs.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: All Transmeta CPUs have constant TSCs
From: "H. Peter Anvin" <hpa@zytor.com>

All Transmeta CPUs ever produced have constant-rate TSCs.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
all-transmeta-cpus-have-constant-tscs.patch
