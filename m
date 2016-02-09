From: akpm@linux-foundation.org
Subject: [obsolete] x86-efi-use-proper-units-in-efi_find_mirror.patch
 removed from -mm tree
Date: Tue, 09 Feb 2016 10:48:58 -0800
Message-ID: <56ba349a.fV7p3R/0wALVdOLq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbcBISs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2016 13:48:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, elliott@hpe.com, hpa@zytor.com, linux@rasmusvillemoes.dk, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/efi: use proper units in efi_find_mirror()
has been removed from the -mm tree.  Its filename was
     x86-efi-use-proper-units-in-efi_find_mirror.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: x86/efi: use proper units in efi_find_mirror()

Like in efi_print_mmap() use the proper units when printing sizes.

Currently it's hardcoded to 'MiB', though it might be changed to adaptive
efi_size_format() in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Robert Elliott <elliott@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/platform/efi/efi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/platform/efi/efi.c~x86-efi-use-proper-units-in-efi_find_mirror arch/x86/platform/efi/efi.c
--- a/arch/x86/platform/efi/efi.c~x86-efi-use-proper-units-in-efi_find_mirror
+++ a/arch/x86/platform/efi/efi.c
@@ -144,8 +144,8 @@ void __init efi_find_mirror(void)
 		}
 	}
 	if (mirror_size)
-		pr_info("Memory: %lldM/%lldM mirrored memory\n",
-			mirror_size>>20, total_size>>20);
+		pr_info("Memory: %lld MiB/%lld MiB mirrored memory\n",
+			mirror_size >> 20, total_size >> 20);
 }
 
 /*
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

lib-string-introduce-match_string-helper.patch
lib-string-introduce-match_string-helper-fix.patch
device-property-convert-to-use-match_string-helper.patch
device-property-convert-to-use-match_string-helper-fix.patch
pinctrl-convert-to-use-match_string-helper.patch
drm-edid-convert-to-use-match_string-helper.patch
power-charger_manager-convert-to-use-match_string-helper.patch
power-ab8500-convert-to-use-match_string-helper.patch
ata-hpt366-convert-to-use-match_string-helper.patch
ide-hpt366-convert-to-use-match_string-helper.patch

