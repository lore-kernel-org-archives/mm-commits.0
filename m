From: akpm@linux-foundation.org
Subject: + autofs-drop-wrong-comment.patch added to -mm tree
Date: Thu, 17 Aug 2017 15:47:59 -0700
Message-ID: <59961d1f.OZmyhWwDK7Nrs4KE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753005AbdHQWsA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:48:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: drop wrong comment
has been added to the -mm tree.  Its filename is
     autofs-drop-wrong-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-drop-wrong-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-drop-wrong-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
