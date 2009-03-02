From: akpm@linux-foundation.org
Subject: + acpi-wmic-unsigned-cannot-be-less-than-0.patch added to -mm tree
Date: Mon, 02 Mar 2009 14:12:50 -0800
Message-ID: <200903022212.n22MConL027805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791AbZCBWNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 17:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, lenb@kernel.org


The patch titled
     acpi: wmi.c: unsigned cannot be less than 0
has been added to the -mm tree.  Its filename is
     acpi-wmic-unsigned-cannot-be-less-than-0.patch

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
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
acpi-wmic-unsigned-cannot-be-less-than-0.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
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
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch

