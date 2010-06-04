From: akpm@linux-foundation.org
Subject: + cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0.patch added to -mm tree
Date: Fri, 04 Jun 2010 16:51:00 -0700
Message-ID: <201006042351.o54Np0UG025388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757507Ab0FDXvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 19:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mike.miller@hp.com, axboe@kernel.dk, scameron@beardog.cce.hp.com


The patch titled
     cciss: change pad value from 32 to 0
has been added to the -mm tree.  Its filename is
     cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0.patch

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
Subject: cciss: change pad value from 32 to 0
From: Mike Miller <mike.miller@hp.com>

Change the command padding on 32-bit systems to 0 since setting it to 32
has the identical effect.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss_cmd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss_cmd.h~cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0 drivers/block/cciss_cmd.h
--- a/drivers/block/cciss_cmd.h~cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0
+++ a/drivers/block/cciss_cmd.h
@@ -177,7 +177,7 @@ typedef struct _SGDescriptor_struct {
 #define COMMANDLIST_ALIGNMENT (32)
 #define IS_64_BIT ((sizeof(long) - 4)/4)
 #define IS_32_BIT (!IS_64_BIT)
-#define PAD_32 (32)
+#define PAD_32 (0)
 #define PAD_64 (4)
 #define PADSIZE (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 #define DIRECT_LOOKUP_BIT 0x10
_

Patches currently in -mm which might be from mike.miller@hp.com are

cciss-enqueue-and-submit-io.patch
cciss-clean-up-interrupt-handler.patch
cciss-clean-up-interrupt-handler-make-sure-we-request-the-performant-mode-irq.patch
cciss-check-for-msi-in-interrupt_not_for_us.patch
cciss-make-interrupt-access-methods-return-type-bool.patch
cciss-add-performant-mode-support-for-stars-sirius.patch
cciss-add-performant-mode-support-for-stars-sirius-fix-call-to-put_controller_in_performant_mode.patch
cciss-add-performant-mode-support-for-stars-sirius-move-next_command-function-from-ifdef.patch
cciss-add-performant-mode-support-for-stars-sirius-remove-errant-debug-code.patch
cciss-add-performant-mode-support-for-stars-sirius-change-pad-value-from-32-to-0.patch
cciss-new-controller-support-and-bump-driver-version.patch

