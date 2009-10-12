From: akpm@linux-foundation.org
Subject: + cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch added to -mm tree
Date: Mon, 12 Oct 2009 16:21:58 -0700
Message-ID: <200910122321.n9CNLwDo022208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757397AbZJLXXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 19:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, cascardo@holoscopio.com, lenb@kernel.org


The patch titled
     cmpc_acpi: depends on ACPI
has been added to the -mm tree.  Its filename is
     cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cmpc_acpi: depends on ACPI
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix about 100 build errors/warnings when ACPI is not enabled.  E.g.:

drivers/platform/x86/cmpc_acpi.c:50: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:55: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:56: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:72: warning: 'struct acpi_device' declared inside parameter list
drivers/platform/x86/cmpc_acpi.c:77: error: dereferencing pointer to incomplete type
drivers/platform/x86/cmpc_acpi.c:79: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi
+++ a/drivers/platform/x86/Kconfig
@@ -438,7 +438,7 @@ config ACPI_TOSHIBA
 
 config ACPI_CMPC
 	tristate "CMPC Laptop Extras"
-	depends on X86
+	depends on X86 && ACPI
 	select INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	default n
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

cpufreq-add-cpufreq_get-stub-for-config_cpu_freq=n.patch
linux-next.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-depends-on-acpi.patch
scsi-fix-func-names-in-kernel-doc.patch
pcmcia-fix-controller-printk-format-warnings.patch
readahead-add-blk_run_backing_dev.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
reiser4-export-remove_from_page_cache-fix.patch

