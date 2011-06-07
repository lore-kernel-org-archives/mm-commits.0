From: akpm@linux-foundation.org
Subject: + lpfc-silence-debug_strict_user_copy_checks=y-warning.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:43:45 -0700
Message-ID: <201106072343.p57NhjgX002512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab1FGXnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, james.smart@emulex.com


The patch titled
     lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
has been added to the -mm tree.  Its filename is
     lpfc-silence-debug_strict_user_copy_checks=y-warning.patch

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
lpfc-silence-debug_strict_user_copy_checks=y-warning.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch
x86-implement-strict-user-copy-checks-for-x86_64.patch
consolidate-config_debug_strict_user_copy_checks.patch

