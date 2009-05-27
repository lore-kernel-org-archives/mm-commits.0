From: akpm@linux-foundation.org
Subject: + x86-platform-oqo-select-input_polldev.patch added to -mm tree
Date: Tue, 26 May 2009 23:59:27 -0700
Message-ID: <200905270659.n4R6xRuj027002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759389AbZE0HBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 03:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dmitry.torokhov@gmail.com, lenb@kernel.org, mjg59@srcf.ucam.org


The patch titled
     x86 platform: oqo: select INPUT_POLLDEV
has been added to the -mm tree.  Its filename is
     x86-platform-oqo-select-input_polldev.patch

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
Subject: x86 platform: oqo: select INPUT_POLLDEV
From: Randy Dunlap <randy.dunlap@oracle.com>

OQO_WMI uses INPUT_POLLDEV, but it can select that instead of depending on
it, since it represents library code.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/platform/x86/Kconfig~x86-platform-oqo-select-input_polldev drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~x86-platform-oqo-select-input_polldev
+++ a/drivers/platform/x86/Kconfig
@@ -146,9 +146,10 @@ config MSI_LAPTOP
 config OQO_WMI
        tristate "OQO WMI extras"
        depends on ACPI_WMI
-       depends on INPUT && INPUT_POLLDEV
+       depends on INPUT
        depends on RFKILL
        depends on BACKLIGHT_CLASS_DEVICE
+	select INPUT_POLLDEV
        help
          Say Y here if you want to support rfkill and backlight control on
          series 2 OQO handheld devices.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
x86-platform-oqo-select-input_polldev.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
lockd-fix-file_locking=n-build-error.patch
hexdump-remove-the-trailing-space.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

