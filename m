From: akpm@linux-foundation.org
Subject: - pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:23:42 -0700
Message-ID: <200807232336.m6NNaJVC018072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbYGWXgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:36:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, Valdis.Kletnieks@vt.edu, andi@firstfloor.org, lenb@kernel.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     pm-acpi-hibernation-utilize-hardware-signature.patch causes build error
has been removed from the -mm tree.  Its filename was
     pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch

This patch was dropped because it was folded into pm-acpi-hibernation-utilize-hardware-signature.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm-acpi-hibernation-utilize-hardware-signature.patch causes build error
From: Shaohua Li <shaohua.li@intel.com>

On Sun, 2008-07-13 at 04:44 -0400, Valdis.Kletnieks@vt.edu wrote:
> Patch pm-acpi-hibernation-utilize-hardware-signature.patch in the 07/11 mmotm
> causes a link error:
>
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `acpi_sleep_setup':
> sleep.c:(.init.text+0x6854): undefined reference to `acpi_no_s4_hw_signature'
>
> Not at all surprising, since the patch doesn't actually include a body
> for the function, only references.  Did a (hopefully) previous patch that
> added the body get lost along the way?
this should fix it.

Reported-by: <Valdis.Kletnieks@vt.edu>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/sleep.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/acpi/sleep.c~pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error arch/x86/kernel/acpi/sleep.c
--- a/arch/x86/kernel/acpi/sleep.c~pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error
+++ a/arch/x86/kernel/acpi/sleep.c
@@ -150,8 +150,10 @@ static int __init acpi_sleep_setup(char 
 			acpi_realmode_flags |= 2;
 		if (strncmp(str, "s3_beep", 7) == 0)
 			acpi_realmode_flags |= 4;
+#ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
+#endif
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
pm-acpi-hibernation-utilize-hardware-signature.patch
pm-acpi-hibernation-utilize-hardware-signaturepatch-causes-build-error.patch

