From: akpm@linux-foundation.org
Subject: + pcdp-use-early_ioremap-early_iounmap-to-access-pcdp-table.patch added to -mm tree
Date: Fri, 20 Jul 2012 13:37:48 -0700
Message-ID: <20120720203749.0DE50100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55703 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2GTUhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jul 2012 16:37:50 -0400
Received: by qcqs25 with SMTP id s25so492932qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jul 2012 13:37:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: greg.pearson@hp.com, khalid.aziz@hp.com, stable@vger.kernel.org


The patch titled
     Subject: pcdp: use early_ioremap/early_iounmap to access pcdp table
has been added to the -mm tree.  Its filename is
     pcdp-use-early_ioremap-early_iounmap-to-access-pcdp-table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Pearson <greg.pearson@hp.com>
Subject: pcdp: use early_ioremap/early_iounmap to access pcdp table

efi_setup_pcdp_console() is called during boot to parse the HCDP/PCDP EFI
system table and setup an early console for printk output.  The routine
uses ioremap/iounmap to setup access to the HCDP/PCDP table information. 
The call to ioremap is happening early in the boot process which leads to
a panic on x86_64 systems:

    0xffffffff815ffbd4 panic+0x01ca
    0xffffffff810535ec do_exit+0x043c
    0xffffffff81603847 oops_end+0x00a7
    0xffffffff81042859 no_context+0x0119
    0xffffffff81042a68 __bad_area_nosemaphore+0x0138
    0xffffffff81042b5e bad_area_nosemaphore+0x000e
    0xffffffff81606411 do_page_fault+0x0321
    0xffffffff81602cb0 page_fault+0x0020
    0xffffffff81045fc1 reserve_memtype+0x02a1
    0xffffffff810430a3 __ioremap_caller+0x0123
    0xffffffff81043402 ioremap_nocache+0x0012
    0xffffffff81d53e70 efi_setup_pcdp_console+0x002b
    0xffffffff81d1fcc5 setup_arch+0x03a9
    0xffffffff81d19b44 start_kernel+0x00d4
    0xffffffff81d19341 x86_64_start_reservations+0x012c
    0xffffffff81d19449 x86_64_start_kernel+0x00fe

This patch replaces the calls to ioremap/iounmap in
efi_setup_pcdp_console() with calls to early_ioremap/early_iounmap which
can be called during early boot.

This patch was tested on an x86_64 prototype system which uses the
HCDP/PCDP table for early console setup.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Khalid Aziz <khalid.aziz@hp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/pcdp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/pcdp.c~pcdp-use-early_ioremap-early_iounmap-to-access-pcdp-table drivers/firmware/pcdp.c
--- a/drivers/firmware/pcdp.c~pcdp-use-early_ioremap-early_iounmap-to-access-pcdp-table
+++ a/drivers/firmware/pcdp.c
@@ -95,7 +95,7 @@ efi_setup_pcdp_console(char *cmdline)
 	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = ioremap(efi.hcdp, 4096);
+	pcdp = early_ioremap(efi.hcdp, 4096);
 	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
@@ -131,6 +131,6 @@ efi_setup_pcdp_console(char *cmdline)
 	}
 
 out:
-	iounmap(pcdp);
+	early_iounmap(pcdp, 4096);
 	return rc;
 }
_
Subject: Subject: pcdp: use early_ioremap/early_iounmap to access pcdp table

Patches currently in -mm which might be from greg.pearson@hp.com are

pcdp-use-early_ioremap-early_iounmap-to-access-pcdp-table.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch

