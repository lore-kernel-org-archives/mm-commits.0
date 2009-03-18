From: akpm@linux-foundation.org
Subject: [merged] acpi-wmic-unsigned-cannot-be-less-than-0.patch removed from -mm tree
Date: Wed, 18 Mar 2009 15:48:03 -0700
Message-ID: <200903182248.n2IMm3bv020254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbZCRWv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 18:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: wmi.c: unsigned cannot be less than 0
has been removed from the -mm tree.  Its filename was
     acpi-wmic-unsigned-cannot-be-less-than-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: wmi.c: unsigned cannot be less than 0
From: Roel Kluin <roel.kluin@gmail.com>

include/linux/pci-acpi.h:74:

typedef u32                 acpi_status;

result is unsigned, so an error returned by acpi_bus_register_driver()
will not be noticed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/platform/x86/wmi.c~acpi-wmic-unsigned-cannot-be-less-than-0 drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c~acpi-wmic-unsigned-cannot-be-less-than-0
+++ a/drivers/platform/x86/wmi.c
@@ -708,7 +708,7 @@ static int __init acpi_wmi_add(struct ac
 
 static int __init acpi_wmi_init(void)
 {
-	acpi_status result;
+	int result;
 
 	INIT_LIST_HEAD(&wmi_blocks.list);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
pata-rb532-cf-platform_get_irq-failure-ignored.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
hugetlb-chg-cannot-become-less-than-0.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
rtc-test-before-subtraction-on-unsigned.patch
rtc-test-before-subtraction-on-unsigned-fix.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
hppfs-hppfs_read_file-may-return-error.patch

