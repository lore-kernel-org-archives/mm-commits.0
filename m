From: akpm@linux-foundation.org
Subject: [merged] drivers-base-corec-use-strreplace.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:48:13 -0700
Message-ID: <5591af0d.sRN3ztceAKLyRbcE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbF2UsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:48:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/base/core.c: use strreplace()
has been removed from the -mm tree.  Its filename was
     drivers-base-corec-use-strreplace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: drivers/base/core.c: use strreplace()

This eliminates a little .text and avoids repeating the strchr call when
we meet a '!' (which will happen at least once).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/base/core.c~drivers-base-corec-use-strreplace drivers/base/core.c
--- a/drivers/base/core.c~drivers-base-corec-use-strreplace
+++ a/drivers/base/core.c
@@ -1303,12 +1303,11 @@ const char *device_get_devnode(struct de
 		return dev_name(dev);
 
 	/* replace '!' in the name with '/' */
-	*tmp = kstrdup(dev_name(dev), GFP_KERNEL);
-	if (!*tmp)
+	s = kstrdup(dev_name(dev), GFP_KERNEL);
+	if (!s)
 		return NULL;
-	while ((s = strchr(*tmp, '!')))
-		s[0] = '/';
-	return *tmp;
+	strreplace(s, '!', '/');
+	return *tmp = s;
 }
 
 /**
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

