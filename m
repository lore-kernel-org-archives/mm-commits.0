From: akpm@linux-foundation.org
Subject: - intel_menlo-max_state-is-unsigned-invalid-test.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:24:40 -0800
Message-ID: <200811102024.mAAKOeR8020072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYKJUZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:25:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     intel_menlo: max_state is unsigned, invalid test
has been removed from the -mm tree.  Its filename was
     intel_menlo-max_state-is-unsigned-invalid-test.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel_menlo: max_state is unsigned, invalid test
From: roel kluin <roel.kluin@gmail.com>

max_state is unsigned, so the test is invalid.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/intel_menlow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/intel_menlow.c~intel_menlo-max_state-is-unsigned-invalid-test drivers/misc/intel_menlow.c
--- a/drivers/misc/intel_menlow.c~intel_menlo-max_state-is-unsigned-invalid-test
+++ a/drivers/misc/intel_menlow.c
@@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(stru
 	if (memory_get_int_max_bandwidth(cdev, &max_state))
 		return -EFAULT;
 
-	if (max_state < 0 || state > max_state)
+	if (max_state == -1 || state > max_state)
 		return -EINVAL;
 
 	arg_list.count = 1;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

atmel_lcdfb-change-irq_base-definition-to-allow-error-reporting.patch
linux-next.patch
intel_menlo-max_state-is-unsigned-invalid-test.patch
u14-34f-fix-scsi_dma_map-failure-case.patch
make-various-things-static.patch

