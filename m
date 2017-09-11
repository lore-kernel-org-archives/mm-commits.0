From: akpm@linux-foundation.org
Subject: [merged] autofs-make-disc-device-user-accessible.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:43:07 -0700
Message-ID: <20170911194307.mxS70b863%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50412 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdIKTnI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org, oholy@redhat.com, raven@themaw.net, walters@redhat.com


The patch titled
     Subject: autofs: make disc device user accessible
has been removed from the -mm tree.  Its filename was
     autofs-make-disc-device-user-accessible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: make disc device user accessible

The autofs miscellanous device ioctls that shouldn't require CAP_SYS_ADMIN
need to be accessible to user space applications in order to be able to
get information about autofs mounts.

The module checks capabilities so the miscelaneous device should be fine
with broad permissions.

Link: http://lkml.kernel.org/r/150216641928.11652.7388977863125547969.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Colin Walters <walters@redhat.com>
Cc: Ondrej Holy <oholy@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-make-disc-device-user-accessible fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-make-disc-device-user-accessible
+++ a/fs/autofs4/dev-ioctl.c
@@ -733,7 +733,8 @@ static const struct file_operations _dev
 static struct miscdevice _autofs_dev_ioctl_misc = {
 	.minor		= AUTOFS_MINOR,
 	.name		= AUTOFS_DEVICE_NAME,
-	.fops		= &_dev_ioctl_fops
+	.fops		= &_dev_ioctl_fops,
+	.mode           = 0644,
 };
 
 MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
_

Patches currently in -mm which might be from raven@themaw.net are


