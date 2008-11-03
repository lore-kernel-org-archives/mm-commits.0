From: akpm@linux-foundation.org
Subject: + intel_menlo-max_state-is-unsigned-invalid-test.patch added to -mm tree
Date: Mon, 03 Nov 2008 14:35:44 -0800
Message-ID: <200811032235.mA3MZiWg007862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942AbYKCWf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 17:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, lenb@kernel.org


The patch titled
     intel_menlo: max_state is unsigned, invalid test
has been added to the -mm tree.  Its filename is
     intel_menlo-max_state-is-unsigned-invalid-test.patch

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

linux-next.patch
intel_menlo-max_state-is-unsigned-invalid-test.patch
u14-34f-fix-scsi_dma_map-failure-case.patch
make-various-things-static.patch

