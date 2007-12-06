From: akpm@linux-foundation.org
Subject: + uml-fix-mconsole-stop.patch added to -mm tree
Date: Thu, 06 Dec 2007 11:47:30 -0800
Message-ID: <200712061947.lB6JlUIb008665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754223AbXLFTre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2007 14:47:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: fix mconsole stop
has been added to the -mm tree.  Its filename is
     uml-fix-mconsole-stop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix mconsole stop
From: Karol Swietlicki <magotari@gmail.com>

Bring back the functionality of stopping user mode linux with the help of
mconsole.

[jdike - the bug being fixed is that the mconsole file descriptor is already
set O_NONBLOCK or not, depending on whether we want no blocking (the normal
case) or we want blocking (when an mconsole stop is in effect), so the
MSG_DONTWAIT is redundant in the normal case, and wrong when we want to
block.]

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/mconsole_user.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/um/drivers/mconsole_user.c~uml-fix-mconsole-stop arch/um/drivers/mconsole_user.c
--- a/arch/um/drivers/mconsole_user.c~uml-fix-mconsole-stop
+++ a/arch/um/drivers/mconsole_user.c
@@ -83,9 +83,8 @@ int mconsole_get_request(int fd, struct 
 	int len;
 
 	req->originlen = sizeof(req->origin);
-	req->len = recvfrom(fd, &req->request, sizeof(req->request),
-			    MSG_DONTWAIT, (struct sockaddr *) req->origin,
-			    &req->originlen);
+	req->len = recvfrom(fd, &req->request, sizeof(req->request), 0,
+			    (struct sockaddr *) req->origin, &req->originlen);
 	if (req->len < 0)
 		return 0;
 
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
