From: akpm@linux-foundation.org
Subject: - arch-i386-kernel-apmc-apm_init-warning-fix.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:19 -0700
Message-ID: <200707312356.l6VNuJOL029311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761039AbXHAARG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eugeneteo@kernel.sg, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     arch/i386/kernel/apm.c: apm_init() warning fix
has been removed from the -mm tree.  Its filename was
     arch-i386-kernel-apmc-apm_init-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/i386/kernel/apm.c: apm_init() warning fix
From: Eugene Teo <eugeneteo@kernel.sg>

arch/i386/kernel/apm.c: In function 'apm_init':
arch/i386/kernel/apm.c:2240: warning: format '%lx' expects type 'long
	unsigned int', but argument 3 has type 'u32'

apm_info.bios.offset is of type 'u32'.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/apm.c~arch-i386-kernel-apmc-apm_init-warning-fix arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~arch-i386-kernel-apmc-apm_init-warning-fix
+++ a/arch/i386/kernel/apm.c
@@ -2235,7 +2235,7 @@ static int __init apm_init(void)
 		apm_info.bios.cseg_16_len = 0; /* 64k */
 
 	if (debug) {
-		printk(KERN_INFO "apm: entry %x:%lx cseg16 %x dseg %x",
+		printk(KERN_INFO "apm: entry %x:%x cseg16 %x dseg %x",
 			apm_info.bios.cseg, apm_info.bios.offset,
 			apm_info.bios.cseg_16, apm_info.bios.dseg);
 		if (apm_info.bios.version > 0x100)
_

Patches currently in -mm which might be from eugeneteo@kernel.sg are

origin.patch
fs-partitions-checkc-add-add_partition-error-handling.patch
