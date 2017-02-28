From: akpm@linux-foundation.org
Subject: [merged]
 autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch removed
 from -mm tree
Date: Tue, 28 Feb 2017 12:49:53 -0800
Message-ID: <58b5e271.Y+nh9dLjripAn6Fu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdB1Uvc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkusumi@tuxera.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition
has been removed from the -mm tree.  Its filename was
     autofs-remove-duplicated-autofs_dev_ioctl_size-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition

This macro is already defined in uapi header.  Also use this macro where
possible.

Link: http://lkml.kernel.org/r/148577166656.9801.10322423666945951186.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c              |    2 --
 include/uapi/linux/auto_dev-ioctl.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition
+++ a/fs/autofs4/dev-ioctl.c
@@ -38,8 +38,6 @@
  * which have been left busy at at service shutdown.
  */
 
-#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
