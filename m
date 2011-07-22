From: akpm@linux-foundation.org
Subject: + uml-drivers-net_userc-memory-leak-fix.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:34:35 -0700
Message-ID: <201107222234.p6MMYZ0U019082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab1GVWeo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:34:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vitalivanov@gmail.com, richard@nod.at


The patch titled
     uml: drivers/net_user.c memory leak fix
has been added to the -mm tree.  Its filename is
     uml-drivers-net_userc-memory-leak-fix.patch

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
Subject: uml: drivers/net_user.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>

Perform memory cleanup on exit.  On receiving invalid 'pid' we still
should clean 'output' variable.

Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_user.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/net_user.c~uml-drivers-net_userc-memory-leak-fix arch/um/drivers/net_user.c
--- a/arch/um/drivers/net_user.c~uml-drivers-net_userc-memory-leak-fix
+++ a/arch/um/drivers/net_user.c
@@ -228,7 +228,10 @@ static void change(char *dev, char *what
 		       "buffer\n");
 
 	pid = change_tramp(argv, output, output_len);
-	if (pid < 0) return;
+	if (pid < 0) {
+		kfree(output);
+		return;
+	}
 
 	if (output != NULL) {
 		printk("%s", output);
_

Patches currently in -mm which might be from vitalivanov@gmail.com are

linux-next.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
uml-drivers-net_userc-memory-leak-fix.patch
gcov-disable-constructors-for-uml.patch

