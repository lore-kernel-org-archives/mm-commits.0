From: akpm@linux-foundation.org
Subject: + ipmi-fix-mem-leak-in-try_init_dmi.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:06:50 -0700
Message-ID: <200707192206.l6JM6oe1025400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763220AbXGSWHE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:07:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com, cminyard@mvista.com


The patch titled
     ipmi: Fix mem leak in try_init_dmi()
has been added to the -mm tree.  Its filename is
     ipmi-fix-mem-leak-in-try_init_dmi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
ipmi-fix-mem-leak-in-try_init_dmi.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
