From: akpm@linux-foundation.org
Subject: [merged] uml-drivers-net_userc-memory-leak-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:31 -0700
Message-ID: <201107260753.p6Q7rY57003244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab1GZHy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalivanov@gmail.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     uml: drivers/net_user.c memory leak fix
has been removed from the -mm tree.  Its filename was
     uml-drivers-net_userc-memory-leak-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
gcov-disable-constructors-for-uml.patch

