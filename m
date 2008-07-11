From: akpm@linux-foundation.org
Subject: - acpi-fix-build-with-config_pm_sleep=n.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:50:55 -0700
Message-ID: <200807112350.m6BNotpU010992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbYGKXvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, andi@firstfloor.org, jbarnes@virtuousgeek.org, lenb@kernel.org, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     acpi: fix build with CONFIG_PM_SLEEP=n
has been removed from the -mm tree.  Its filename was
     acpi-fix-build-with-config_pm_sleep=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix build with CONFIG_PM_SLEEP=n
From: David Howells <dhowells@redhat.com>

Fix acpi_pm_device_sleep_wake() by providing a stub for CONFIG_PM_SLEEP=n.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/acpi/acpi_bus.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/acpi/acpi_bus.h~acpi-fix-build-with-config_pm_sleep=n include/acpi/acpi_bus.h
--- a/include/acpi/acpi_bus.h~acpi-fix-build-with-config_pm_sleep=n
+++ a/include/acpi/acpi_bus.h
@@ -384,6 +384,10 @@ static inline int acpi_pm_device_sleep_s
 		*p = ACPI_STATE_D0;
 	return ACPI_STATE_D3;
 }
+static inline int acpi_pm_device_sleep_wake(struct device *dev, bool enable)
+{
+	return -ENODEV;
+}
 #endif /* !CONFIG_PM_SLEEP */
 
 #endif				/* CONFIG_ACPI */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

