From: akpm@linux-foundation.org
Subject: + autofs-make-disc-device-user-accessible.patch added to -mm tree
Date: Tue, 08 Aug 2017 16:10:39 -0700
Message-ID: <598a44ef.ntN7IIQLHCIhJkSq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdHHXKk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2017 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, dhowells@redhat.com, oholy@redhat.com, walters@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: make disc device user accessible
has been added to the -mm tree.  Its filename is
     autofs-make-disc-device-user-accessible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-make-disc-device-user-accessible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-make-disc-device-user-accessible.patch

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

autofs-fix-at_no_automount-not-being-honored.patch
autofs-make-disc-device-user-accessible.patch
autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch

