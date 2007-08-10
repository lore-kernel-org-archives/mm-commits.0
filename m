From: akpm@linux-foundation.org
Subject: - x86_64-make-acpi-the-default-reset-option.patch removed from -mm tree
Date: Fri, 10 Aug 2007 16:35:55 -0700
Message-ID: <200708102335.l7ANZtg1015695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754930AbXHJXgQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 19:36:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adurbin@google.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: make ACPI the default reset option
has been removed from the -mm tree.  Its filename was
     x86_64-make-acpi-the-default-reset-option.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: x86_64: make ACPI the default reset option
From: Aaron Durbin <adurbin@google.com>

Make ACPI be the default reset method for x86_64. If the reset mechanism fails
using ACPI, it will default to using the keyboard controller.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    4 ++--
 arch/x86_64/kernel/reboot.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-make-acpi-the-default-reset-option Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-make-acpi-the-default-reset-option
+++ a/Documentation/x86_64/boot-options.txt
@@ -115,10 +115,10 @@ Rebooting
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
-   kbd    Use the keyboard controller. cold reset (default)
+   kbd    Use the keyboard controller. cold reset
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
-          the keyboard controller.
+          the keyboard controller. (default)
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
diff -puN arch/x86_64/kernel/reboot.c~x86_64-make-acpi-the-default-reset-option arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86_64-make-acpi-the-default-reset-option
+++ a/arch/x86_64/kernel/reboot.c
@@ -30,7 +30,7 @@ static enum { 
 	BOOT_TRIPLE = 't',
 	BOOT_KBD = 'k',
 	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
+} reboot_type = BOOT_ACPI;
 static int reboot_mode = 0;
 int reboot_force;
 
_

Patches currently in -mm which might be from adurbin@google.com are

fix-hpet-init-race.patch
acpi-add-reboot-mechanism.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
