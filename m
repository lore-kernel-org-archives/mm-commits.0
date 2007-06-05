From: akpm@linux-foundation.org
Subject: + remove-apparently-useless-commented-apm_get_battery_status.patch added to -mm tree
Date: Tue, 05 Jun 2007 16:57:24 -0700
Message-ID: <200706052357.l55NvOCe005513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934242AbXFEX5j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 19:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, cbou@mail.ru, sfr@canb.auug.org.au


The patch titled
     Remove apparently useless, commented apm_get_battery_status()
has been added to the -mm tree.  Its filename is
     remove-apparently-useless-commented-apm_get_battery_status.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 29 deletions(-)

diff -puN arch/i386/kernel/apm.c~remove-apparently-useless-commented-apm_get_battery_status arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~remove-apparently-useless-commented-apm_get_battery_status
+++ a/arch/i386/kernel/apm.c
@@ -1007,35 +1007,6 @@ static int apm_get_power_status(u_short 
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

ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
cobalt-remove-all-traces-of-cobalt-from-nvramc.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
