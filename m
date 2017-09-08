From: akpm@linux-foundation.org
Subject: [patch 105/126] autofs: drop wrong comment
Date: Fri, 08 Sep 2017 16:16:43 -0700
Message-ID: <20170908231643.dVXbTrna1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53464 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757209AbdIHXQp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:16:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, raven@themaw.net, tkusumi@tuxera.com, torvalds@linux-foundation.org

From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: drop wrong comment

This comment was correct when it was added in 8d7b48e0 ("autofs4: add
miscellaneous device for ioctls") in 2008, but not after 4e44b685 "Get rid
of path_lookup in autofs4" in 2009 which introduced find_autofs_mount().

Link: http://lkml.kernel.org/r/150285069148.4670.17959501481201077445.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-drop-wrong-comment fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-drop-wrong-comment
+++ a/fs/autofs4/dev-ioctl.c
@@ -258,11 +258,6 @@ static int autofs_dev_ioctl_open_mountpo
 		if (err)
 			goto out;
 
-		/*
-		 * Find autofs super block that has the device number
-		 * corresponding to the autofs fs we want to open.
-		 */
