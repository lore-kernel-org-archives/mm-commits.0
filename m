From: akpm@linux-foundation.org
Subject: [merged] dac960-fix-undefined-behavior-on-empty-string.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:25 -0700
Message-ID: <200909231952.n8NJqPx6029107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbZIWTw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:52:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, mm-commits@vger.kernel.org


The patch titled
     dac960: fix undefined behavior on empty string
has been removed from the -mm tree.  Its filename was
     dac960-fix-undefined-behavior-on-empty-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

