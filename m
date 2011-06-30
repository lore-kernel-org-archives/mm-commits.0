From: akpm@linux-foundation.org
Subject: [merged] lpfc-silence-debug_strict_user_copy_checks=y-warning.patch removed from -mm tree
Date: Thu, 30 Jun 2011 10:56:15 -0700
Message-ID: <201106301755.p5UHttac003741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027Ab1F3Rz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jun 2011 13:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, james.smart@emulex.com, mm-commits@vger.kernel.org


The patch titled
     lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
has been removed from the -mm tree.  Its filename was
     lpfc-silence-debug_strict_user_copy_checks=y-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
From: Stephen Boyd <sboyd@codeaurora.org>

Enabling DEBUG_STRICT_USER_COPY_CHECKS causes the following warning:

In file included from arch/x86/include/asm/uaccess.h:573,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from include/linux/blkdev.h:12,
                 from drivers/scsi/lpfc/lpfc_debugfs.c:21:
In function 'copy_from_user':
arch/x86/include/asm/uaccess_64.h:65:
warning: call to 'copy_from_user_overflow' declared with
attribute warning: copy_from_user() buffer size is not provably
correct

presumably due to buf_size being signed causing GCC to fail to see that
buf_size can't become negative.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: James Smart <james.smart@emulex.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_debugfs.c~lpfc-silence-debug_strict_user_copy_checks=y-warning drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c~lpfc-silence-debug_strict_user_copy_checks=y-warning
+++ a/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1147,7 +1147,8 @@ static int lpfc_idiag_cmd_get(const char
 {
 	char mybuf[64];
 	char *pbuf, *step_str;
-	int bsize, i;
+	int i;
+	size_t bsize;
 
 	/* Protect copy from user */
 	if (!access_ok(VERIFY_READ, buf, nbytes))
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch

