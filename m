From: akpm@linux-foundation.org
Subject: + dac960-fix-undefined-behavior-on-empty-string.patch added to -mm tree
Date: Thu, 23 Jul 2009 14:26:09 -0700
Message-ID: <200907232126.n6NLQ9Qm024169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbZGWV0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Jul 2009 17:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de


The patch titled
     dac960: fix undefined behavior on empty string
has been added to the -mm tree.  Its filename is
     dac960-fix-undefined-behavior-on-empty-string.patch

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
Subject: dac960: fix undefined behavior on empty string
From: Michael Buesch <mb@bu3sch.de>

Fix undefined behavior due to a buffer underrun if an empty string is
written to the proc file.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/DAC960.c~dac960-fix-undefined-behavior-on-empty-string drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~dac960-fix-undefined-behavior-on-empty-string
+++ a/drivers/block/DAC960.c
@@ -6562,7 +6562,7 @@ static int DAC960_ProcWriteUserCommand(s
   if (copy_from_user(CommandBuffer, Buffer, Count)) return -EFAULT;
   CommandBuffer[Count] = '\0';
   Length = strlen(CommandBuffer);
-  if (CommandBuffer[Length-1] == '\n')
+  if (Length > 0 && CommandBuffer[Length-1] == '\n')
     CommandBuffer[--Length] = '\0';
   if (Controller->FirmwareType == DAC960_V1_Controller)
     return (DAC960_V1_ExecuteUserCommand(Controller, CommandBuffer)
_

Patches currently in -mm which might be from mb@bu3sch.de are

dac960-fix-undefined-behavior-on-empty-string.patch

