From: akpm@linux-foundation.org
Subject: + convert-loglevel-related-kernel-boot-parameters-to-early_param.patch added to -mm tree
Date: Fri, 01 Feb 2008 02:44:39 -0800
Message-ID: <200802011044.m11AiK4m008171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509AbYBAKor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2008 05:44:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, yinghai.lu@Sun.COM


The patch titled
     Convert loglevel-related kernel boot parameters to early_param
has been added to the -mm tree.  Its filename is
     convert-loglevel-related-kernel-boot-parameters-to-early_param.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 init/main.c     |   10 +++-------
 kernel/printk.c |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param init/main.c
--- a/init/main.c~convert-loglevel-related-kernel-boot-parameters-to-early_param
+++ a/init/main.c
@@ -232,22 +232,18 @@ EXPORT_SYMBOL(loops_per_jiffy);
 
 static int __init debug_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 10;
 	return 1;
 }
 
 static int __init quiet_kernel(char *str)
 {
-	if (*str)
-		return 0;
 	console_loglevel = 4;
 	return 1;
 }
 
-__setup("debug", debug_kernel);
-__setup("quiet", quiet_kernel);
+early_param("debug", debug_kernel);
+early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
@@ -255,7 +251,7 @@ static int __init loglevel(char *str)
 	return 1;
 }
 
-__setup("loglevel=", loglevel);
+early_param("loglevel", loglevel);
 
 /*
  * Unknown boot options get handed to init, unless they look like
diff -puN kernel/printk.c~convert-loglevel-related-kernel-boot-parameters-to-early_param kernel/printk.c
--- a/kernel/printk.c~convert-loglevel-related-kernel-boot-parameters-to-early_param
+++ a/kernel/printk.c
@@ -457,7 +457,7 @@ static int __init ignore_loglevel_setup(
 	return 1;
 }
 
-__setup("ignore_loglevel", ignore_loglevel_setup);
+early_param("ignore_loglevel", ignore_loglevel_setup);
 
 /*
  * Write out chars from start to end - 1 inclusive
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used-vs-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
kernel-printkc-concerns-about-the-console-handover.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
