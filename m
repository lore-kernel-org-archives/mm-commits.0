From: akpm@linux-foundation.org
Subject: - powerpc-powermac-local_irq_disable-is-redundant-after-local_irq_save.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:51:18 -0800
Message-ID: <200702071951.l17JpIpA025143@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33494 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422737AbXBGTve (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:51:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     POWERPC-Powermac: local_irq_disable() is redundant after local_irq_save()
has been removed from the -mm tree.  Its filename was
     powerpc-powermac-local_irq_disable-is-redundant-after-local_irq_save.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: POWERPC-Powermac: local_irq_disable() is redundant after local_irq_save()
From: Jiri Kosina <jkosina@suse.cz>

arch/powerpc/platforms/powermac/smp.c::smp_core99_kick_cpu() contains
local_irq_disable() call after local_irq_save().  This looks redundant.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powermac/smp.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/platforms/powermac/smp.c~powerpc-powermac-local_irq_disable-is-redundant-after-local_irq_save arch/powerpc/platforms/powermac/smp.c
--- a/arch/powerpc/platforms/powermac/smp.c~powerpc-powermac-local_irq_disable-is-redundant-after-local_irq_save
+++ a/arch/powerpc/platforms/powermac/smp.c
@@ -795,7 +795,6 @@ static void __devinit smp_core99_kick_cp
 		ppc_md.progress("smp_core99_kick_cpu", 0x346);
 
 	local_irq_save(flags);
-	local_irq_disable();
 
 	/* Save reset vector */
 	save_vector = *vector;
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
git-powerpc.patch
git-netdev-all.patch
scsi-buslogic-local_irq_disable-is-redundant-after-local_irq_save.patch
git-ipwireless_cs.patch
cris-local_irq_disable-is-redundant-after-local_irq_save.patch
cris-turn-local_save_flags-local_irq_disable-into-local_irq_save-in-headers.patch
char-amiserial-turn-local_save_flags-local_irq_disable-into-local_irq_save.patch
tick-management-dyntick--highres-functionality-fix.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
