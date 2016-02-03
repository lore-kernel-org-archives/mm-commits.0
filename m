From: akpm@linux-foundation.org
Subject: + autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch added to
 -mm tree
Date: Tue, 02 Feb 2016 19:42:29 -0800
Message-ID: <56b17725.49pXuvX+umbFCX47%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbcBCDma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 22:42:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix string.h include in auto_dev-ioctl.h
has been added to the -mm tree.  Its filename is
     autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-fix-stringh-include-in-auto_dev-ioctlh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix string.h include in auto_dev-ioctl.h

Since including linux/string.h will now do the right thing remove the
conditional check.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/auto_dev-ioctl.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/auto_dev-ioctl.h~autofs4-fix-stringh-include-in-auto_dev-ioctlh include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs4-fix-stringh-include-in-auto_dev-ioctlh
+++ a/include/linux/auto_dev-ioctl.h
@@ -11,12 +11,7 @@
 #define _LINUX_AUTO_DEV_IOCTL_H
 
 #include <linux/auto_fs.h>
