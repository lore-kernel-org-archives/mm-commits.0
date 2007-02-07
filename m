From: akpm@linux-foundation.org
Subject: - fix-x86_64-mm-i386-config-core2.patch removed from -mm tree
Date: Wed, 07 Feb 2007 09:34:47 -0800
Message-ID: <200702071734.l17HYlOn020957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56951 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161401AbXBGRe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 12:34:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix x86_64-mm-i386-config-core2
has been removed from the -mm tree.  Its filename was
     fix-x86_64-mm-i386-config-core2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fix x86_64-mm-i386-config-core2
From: Mattia Dongili <malattia@linux.it>

On Thu, Nov 23, 2006 at 02:17:03AM -0800, Andrew Morton wrote:
...
> +x86_64-mm-i386-config-core2.patch

hmmm... this one missed to update also include/asm/module.h:

  HOSTCC  scripts/genksyms/parse.o
  HOSTCC  scripts/mod/sumversion.o
In file included from include/linux/module.h:22,
                 from include/linux/crypto.h:21,
                 from arch/i386/kernel/asm-offsets.c:7:
include/asm/module.h:60:2: error: #error unknown processor family
  HOSTLD  scripts/genksyms/genksyms
make[1]: *** [arch/i386/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....

If the family name is correct the patch is quite trivial :)

Signed-out-by: Mattia Dongili <malattia@linux.it>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/module.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/asm-i386/module.h~fix-x86_64-mm-i386-config-core2 include/asm-i386/module.h
--- a/include/asm-i386/module.h~fix-x86_64-mm-i386-config-core2
+++ a/include/asm-i386/module.h
@@ -28,6 +28,8 @@ struct mod_arch_specific
 #define MODULE_PROC_FAMILY "PENTIUMII "
 #elif defined CONFIG_MPENTIUMIII
 #define MODULE_PROC_FAMILY "PENTIUMIII "
+#elif defined CONFIG_MCORE2
+#define MODULE_PROC_FAMILY "CORE2 "
 #elif defined CONFIG_MPENTIUMM
 #define MODULE_PROC_FAMILY "PENTIUMM "
 #elif defined CONFIG_MPENTIUM4
_

Patches currently in -mm which might be from malattia@linux.it are

sony_acpi-addacpi_bus_generate-event.patch
sony_acpi-add-lanpower-and-audiopower-controls.patch
sony_acpi-allow-multiple-sony_acpi_values-for-the-same-name.patch
sony_acpi-fix-sony_acpi-backlight-registration-and-unregistration.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
fix-x86_64-mm-i386-config-core2.patch
