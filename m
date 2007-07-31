From: akpm@linux-foundation.org
Subject: - ipmi-fix-mem-leak-in-try_init_dmi.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:03 -0700
Message-ID: <200707312358.l6VNw3c6029521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760514AbXHAAQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: Fix mem leak in try_init_dmi()
has been removed from the -mm tree.  Its filename was
     ipmi-fix-mem-leak-in-try_init_dmi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ipmi: Fix mem leak in try_init_dmi()
From: Jesper Juhl <jesper.juhl@gmail.com>

This is only called at init time and only happens if the BIOS screws
something up, so the leak is slight and it is probably not worth sending to
2.6.22.x.  The driver would not initialize the interface in the case, and I
have no reports of this happening.  I have booted and run tests on a system
with this patch.  Note that the original patch was munged by the mailer,
here's a new one.

If we ever hit the "default:" case in the switch in try_init_dmi(),
then we'll leak the storage allocated with kzalloc() and assigned
to 'info'.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-mem-leak-in-try_init_dmi drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-fix-mem-leak-in-try_init_dmi
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2050,6 +2050,7 @@ static __devinit void try_init_dmi(struc
 		info->si_type = SI_BT;
 		break;
 	default:
+		kfree(info);
 		return;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
powerpc-clean-out-a-bunch-of-duplicate-includes.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hid.patch
ia64-remove-a-few-duplicate-includes.patch
clean-up-duplicate-includes-in-drivers-input.patch
mips-remove-some-duplicate-includes.patch
git-mtd.patch
clean-up-duplicate-includes-in-drivers-net.patch
clean-up-duplicate-includes-in-drivers-atm.patch
clean-up-duplicate-includes-in-net-atm.patch
clean-up-duplicate-includes-in-net-ipv4.patch
clean-up-duplicate-includes-in-net-ipv6.patch
clean-up-duplicate-includes-in-net-sched.patch
clean-up-duplicate-includes-in-net-sunrpc.patch
clean-up-duplicate-includes-in-net-tipc.patch
clean-up-duplicate-includes-in-net-xfrm.patch
dccp-fix-memory-leak-and-clean-up-style-dccp_feat_empty_confirm.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
sh64-arch-sh64-kernel-signalh-duplicate-include-removal.patch
clean-up-duplicate-includes-in-drivers-scsi.patch
clean-up-duplicate-includes-in-drivers-block.patch
clean-up-duplicate-includes-in-arch-i386-xen.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
clean-up-duplicate-includes-in-drivers-spi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
