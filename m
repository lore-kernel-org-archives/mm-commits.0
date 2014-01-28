From: akpm@linux-foundation.org
Subject: [merged]
 firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:10:01 -0800
Message-ID: <52e80089.Zub9cD0kDPgWWUuE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaA1TKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mikew@google.com, ard.biesheuvel@linaro.org

Subject: [merged] firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch removed from -mm tree
To: ard.biesheuvel@linaro.org,mikew@google.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:01 -0800


The patch titled
     Subject: firmware/google: drop 'select EFI' to avoid recursive dependency
has been removed from the -mm tree.  Its filename was
     firmware-google-drop-select-efi-to-avoid-recursive-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: firmware/google: drop 'select EFI' to avoid recursive dependency

The GOOGLE_SMI Kconfig symbol depends on DMI and selects EFI.  This causes
problems on other archs when introducing DMI support that depends on EFI,
as it results in a recursive dependency:

arch/arm/Kconfig:1845:error: recursive dependency detected!
arch/arm/Kconfig:1845:	symbol DMI depends on EFI

Fix by changing the 'select EFI' to a 'depends on EFI'.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/google/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/firmware/google/Kconfig~firmware-google-drop-select-efi-to-avoid-recursive-dependency drivers/firmware/google/Kconfig
--- a/drivers/firmware/google/Kconfig~firmware-google-drop-select-efi-to-avoid-recursive-dependency
+++ a/drivers/firmware/google/Kconfig
@@ -12,8 +12,7 @@ menu "Google Firmware Drivers"
 
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
-	depends on ACPI && DMI
-	select EFI
+	depends on ACPI && DMI && EFI
 	select EFI_VARS
 	help
 	  Say Y here if you want to enable SMI callbacks for Google
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

origin.patch

