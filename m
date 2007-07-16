From: akpm@linux-foundation.org
Subject: - remove-apparently-useless-commented-apm_get_battery_status.patch removed from -mm tree
Date: Mon, 16 Jul 2007 00:45:20 -0700
Message-ID: <200707160745.l6G7jKDw020260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbXGPHpj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 03:45:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, cbou@mail.ru, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Remove apparently useless, commented apm_get_battery_status()
has been removed from the -mm tree.  Its filename was
     remove-apparently-useless-commented-apm_get_battery_status.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Remove apparently useless, commented apm_get_battery_status()
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the "#if 0"ed definition of apm_get_battery_status().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apm.c |   29 -----------------------------
 1 file changed, 29 deletions(-)

diff -puN arch/i386/kernel/apm.c~remove-apparently-useless-commented-apm_get_battery_status arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~remove-apparently-useless-commented-apm_get_battery_status
+++ a/arch/i386/kernel/apm.c
@@ -1006,35 +1006,6 @@ static int apm_get_power_status(u_short 
 	return APM_SUCCESS;
 }
 
-#if 0
-static int apm_get_battery_status(u_short which, u_short *status,
-				  u_short *bat, u_short *life, u_short *nbat)
-{
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-	u32	esi;
-
-	if (apm_info.connection_version < 0x0102) {
-		/* pretend we only have one battery. */
-		if (which != 1)
-			return APM_BAD_DEVICE;
-		*nbat = 1;
-		return apm_get_power_status(status, bat, life);
-	}
-
-	if (apm_bios_call(APM_FUNC_GET_STATUS, (0x8000 | (which)), 0, &eax,
-			&ebx, &ecx, &edx, &esi))
-		return (eax >> 8) & 0xff;
-	*status = ebx;
-	*bat = ecx;
-	*life = edx;
-	*nbat = esi;
-	return APM_SUCCESS;
-}
-#endif
-
 /**
  *	apm_engage_power_management	-	enable PM on a device
  *	@device: identity of device
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-sh.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
