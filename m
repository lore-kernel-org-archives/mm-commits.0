From: akpm@linux-foundation.org
Subject: - uml-fix-mconsole-stop.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:15 -0800
Message-ID: <200802052236.m15MauqP012742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762300AbYBEWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magotari@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: fix mconsole stop
has been removed from the -mm tree.  Its filename was
     uml-fix-mconsole-stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
