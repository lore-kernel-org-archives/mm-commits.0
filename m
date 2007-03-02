From: akpm@linux-foundation.org
Subject: + altix-reinitialize-acpi-tables.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:37:49 -0800
Message-ID: <200703020237.l222bnjF030190@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35982 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422657AbXCBChz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com


The patch titled
     Altix: reinitialize acpi tables
has been added to the -mm tree.  Its filename is
     altix-reinitialize-acpi-tables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Altix: reinitialize acpi tables
From: John Keller <jpk@sgi.com>

To provide compatibilty with SN kernels that do and do not have ACPI IO
support, the SN PROM must build different versions of some ACPI tables
based on which kernel is booting.  As such, the tables may have to change
at kernel boot time.  By default, prior to kernel boot, the PROM builds an
empty DSDT (header only) and no SSDTs.  If an ACPI capable kernel boots,
the kernel will notify the PROM, at platform setup time, and the PROM will
build full DSDT and SSDT tables.

With the latest changes to acpi_table_init(), the table lengths are saved,
and when our PROM changes them, the changes are not seen, and the kernel
will crash on boot.  Because of issues with kexec support, we are not able
to create the tables prior to acpi_table_init().  As a result, we are
making a second call to acpi_table_init() to process the rebuilt DSDT and
SSDTs.

Signed-off-by: John Keller <jpk@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/sn/kernel/setup.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN arch/ia64/sn/kernel/setup.c~altix-reinitialize-acpi-tables arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~altix-reinitialize-acpi-tables
+++ a/arch/ia64/sn/kernel/setup.c
@@ -397,6 +397,8 @@ void __init sn_setup(char **cmdline_p)
 	ia64_sn_set_os_feature(OSF_PCISEGMENT_ENABLE);
 	ia64_sn_set_os_feature(OSF_ACPI_ENABLE);
 
+	/* Load the new DSDT and SSDT tables into the global table list. */
+ 	acpi_table_init();
 
 #if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
 	/*
_

Patches currently in -mm which might be from jpk@sgi.com are

git-acpi.patch
altix-reinitialize-acpi-tables.patch
