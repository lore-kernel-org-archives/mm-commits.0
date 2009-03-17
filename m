From: akpm@linux-foundation.org
Subject: [alternative-merged] acpi-get_throttling_state-cannot-be-larger-state_count.patch removed from -mm tree
Date: Tue, 17 Mar 2009 00:11:50 -0700
Message-ID: <200903170714.n2H7EoVE031407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbZCQHSs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Mar 2009 03:18:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, lenb@kernel.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: get_throttling_state() cannot be larger than state_count
has been removed from the -mm tree.  Its filename was
     acpi-get_throttling_state-cannot-be-larger-state_count.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: get_throttling_state() cannot be larger than state_count
From: Roel Kluin <roel.kluin@gmail.com>

With for(i = 0; i < n; i++) { ... } i reaches n.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-get_throttling_state-cannot-be-larger-state_count drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-get_throttling_state-cannot-be-larger-state_count
+++ a/drivers/acpi/processor_throttling.c
@@ -785,7 +785,7 @@ static int acpi_get_throttling_state(str
 		if (tx->control == value)
 			break;
 	}
-	if (i > pr->throttling.state_count)
+	if (i >= pr->throttling.state_count)
 		i = -1;
 	return i;
 }
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
powerpc-spufs-check-file-offset-before-calculating-write-size-in-fixed-sized-files.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
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

