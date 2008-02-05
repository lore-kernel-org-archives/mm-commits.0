From: akpm@linux-foundation.org
Subject: - uml-fix-infinite-mconsole-loop.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:38:42 -0800
Message-ID: <200802052238.m15McNYb012945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36932 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760640AbYBEWlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magotari@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix infinite mconsole loop
has been removed from the -mm tree.  Its filename was
     uml-fix-infinite-mconsole-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix infinite mconsole loop
From: Karol Swietlicki <magotari@gmail.com>

This patch takes care of a problem with the stopping code.

The function inside the while condition returns 0 to signify a problem.  A
problem could be for example a bad command or a bad version of the mconsole
client.  A bad command would terminate the stopping loop and resume the
kernel.  This is a problem.

A better solution is to make the loop infinite and don't leave it until we are
explicitly told to.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_kern.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/um/drivers/mconsole_kern.c~uml-fix-infinite-mconsole-loop arch/um/drivers/mconsole_kern.c
--- a/arch/um/drivers/mconsole_kern.c~uml-fix-infinite-mconsole-loop
+++ a/arch/um/drivers/mconsole_kern.c
@@ -305,7 +305,9 @@ void mconsole_stop(struct mc_request *re
 	deactivate_fd(req->originating_fd, MCONSOLE_IRQ);
 	os_set_fd_block(req->originating_fd, 1);
 	mconsole_reply(req, "stopped", 0, 0);
-	while (mconsole_get_request(req->originating_fd, req)) {
+	for (;;) {
+		if (!mconsole_get_request(req->originating_fd, req))
+			continue;
 		if (req->cmd->handler == mconsole_go)
 			break;
 		if (req->cmd->handler == mconsole_stop) {
_

Patches currently in -mm which might be from magotari@gmail.com are

origin.patch
