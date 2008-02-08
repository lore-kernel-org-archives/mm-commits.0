From: akpm@linux-foundation.org
Subject: - convert-loglevel-related-kernel-boot-parameters-to-early_param.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:41 -0800
Message-ID: <200802082020.m18KKMEe011158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933336AbYBHUk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:40:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     Convert loglevel-related kernel boot parameters to early_param
has been removed from the -mm tree.  Its filename was
     convert-loglevel-related-kernel-boot-parameters-to-early_param.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Convert loglevel-related kernel boot parameters to early_param
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

So we can use them for the early console like console=uart8250 or
earlycon=uart8250 or early_printk

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param init/main.c
--- a/init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param
+++ a/init/main.c
@@ -238,22 +238,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 10;
-	return 1;
+	return 0;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 4;
-	return 1;
+	return 0;
 }
 
-__setup("debug", debug_kernel);
-__setup("quiet", quiet_kernel);
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
@@ -261,7 +257,7 @@ static int __init loglevel(char *str)
 	return 1;
 }
 
-__setup("loglevel=", loglevel);
+early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
