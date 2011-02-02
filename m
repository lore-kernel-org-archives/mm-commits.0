From: akpm@linux-foundation.org
Subject: + gpu-stub-fix-acpi_video-build-error-fix-stub-kconfig-dependencies.patch added to -mm tree
Date: Tue, 01 Feb 2011 16:48:44 -0800
Message-ID: <201102020048.p120miII008336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab1BBAuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2011 19:50:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, airlied@redhat.com, lenb@kernel.org, luming.yu@intel.com, mingo@elte.hu, rjw@sisk.pl, sfr@canb.auug.org.au


The patch titled
     gpu/stub: fix acpi_video build error, fix stub kconfig dependencies
has been added to the -mm tree.  Its filename is
     gpu-stub-fix-acpi_video-build-error-fix-stub-kconfig-dependencies.patch

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
Subject: gpu/stub: fix acpi_video build error, fix stub kconfig dependencies
From: Randy Dunlap <randy.dunlap@oracle.com>

The comments under "config STUB_POULSBO" are close to correct, but they
are not being followed.  This patch updates them to reflect the
requirements for THERMAL.

This build error is caused by STUB_POULSBO selecting ACPI_VIDEO when
ACPI_VIDEO's config requirements are not met.

ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Luming Yu <luming.yu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/stub/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/gpu/stub/Kconfig~gpu-stub-fix-acpi_video-build-error-fix-stub-kconfig-dependencies drivers/gpu/stub/Kconfig
--- a/drivers/gpu/stub/Kconfig~gpu-stub-fix-acpi_video-build-error-fix-stub-kconfig-dependencies
+++ a/drivers/gpu/stub/Kconfig
@@ -1,11 +1,13 @@
 config STUB_POULSBO
 	tristate "Intel GMA500 Stub Driver"
 	depends on PCI
+	depends on NET # for THERMAL
 	# Poulsbo stub depends on ACPI_VIDEO when ACPI is enabled
 	# but for select to work, need to select ACPI_VIDEO's dependencies, ick
 	select BACKLIGHT_CLASS_DEVICE if ACPI
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
+	select THERMAL if ACPI
 	help
 	  Choose this option if you have a system that has Intel GMA500
 	  (Poulsbo) integrated graphics. If M is selected, the module will
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
gpu-stub-fix-acpi_video-build-error-fix-stub-kconfig-dependencies.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-apple_bl-depends-on-acpi.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

