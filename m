From: akpm@linux-foundation.org
Subject: + uml-fix-infinite-mconsole-loop.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:23:40 -0800
Message-ID: <200801280524.m0S5OZde013798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbYA1FYh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:24:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: fix infinite mconsole loop
has been added to the -mm tree.  Its filename is
     uml-fix-infinite-mconsole-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes-fix.patch
uml-remove-now-unused-code.patch
uml-gprof-needs-to-depend-on-frame_pointer.patch
uml-remove-unused-variables-in-the-context-switcher.patch
uml-convert-functions-to-void.patch
uml-remove-duplicate-config-symbol-and-unused-file-and-variables.patch
uml-fix-mconsole-stop.patch
uml-debug_shirq-fixes.patch
uml-fix-infinite-mconsole-loop.patch
