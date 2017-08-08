From: akpm@linux-foundation.org
Subject: +
 autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch added
 to -mm tree
Date: Tue, 08 Aug 2017 16:10:41 -0700
Message-ID: <598a44f1.MA6oQkrJ6ZiXMLR3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdHHXKm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2017 19:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, dhowells@redhat.com, oholy@redhat.com, walters@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: make dev ioctl version and ismountpoint user accessible
has been added to the -mm tree.  Its filename is
     autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch

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
Subject: autofs: make dev ioctl version and ismountpoint user accessible

Some of the autofs miscellaneous device ioctls need to be accessable to
user space applications without CAP_SYS_ADMIN to get information about
autofs mounts.

Link: http://lkml.kernel.org/r/150216642517.11652.2338933266137331637.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Colin Walters <walters@redhat.com>
Cc: Ondrej Holy <oholy@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c              |   12 ++++++++----
 include/uapi/linux/auto_dev-ioctl.h |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible
+++ a/fs/autofs4/dev-ioctl.c
@@ -628,10 +628,6 @@ static int _autofs_dev_ioctl(unsigned in
 	ioctl_fn fn = NULL;
 	int err = 0;
 
-	/* only root can play with this */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	cmd_first = _IOC_NR(AUTOFS_DEV_IOCTL_IOC_FIRST);
 	cmd = _IOC_NR(command);
 
@@ -640,6 +636,14 @@ static int _autofs_dev_ioctl(unsigned in
 		return -ENOTTY;
 	}
 
+	/* Only root can use ioctls other than AUTOFS_DEV_IOCTL_VERSION_CMD
+	 * and AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD
+	 */
+	if (cmd != AUTOFS_DEV_IOCTL_VERSION_CMD &&
+	    cmd != AUTOFS_DEV_IOCTL_ISMOUNTPOINT_CMD &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	/* Copy the parameters into kernel space. */
 	param = copy_dev_ioctl(user);
 	if (IS_ERR(param))
diff -puN include/uapi/linux/auto_dev-ioctl.h~autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible include/uapi/linux/auto_dev-ioctl.h
--- a/include/uapi/linux/auto_dev-ioctl.h~autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible
+++ a/include/uapi/linux/auto_dev-ioctl.h
@@ -16,7 +16,7 @@
 #define AUTOFS_DEVICE_NAME		"autofs"
 
 #define AUTOFS_DEV_IOCTL_VERSION_MAJOR	1
-#define AUTOFS_DEV_IOCTL_VERSION_MINOR	0
+#define AUTOFS_DEV_IOCTL_VERSION_MINOR	1
 
 #define AUTOFS_DEV_IOCTL_SIZE		sizeof(struct autofs_dev_ioctl)
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs-fix-at_no_automount-not-being-honored.patch
autofs-make-disc-device-user-accessible.patch
autofs-make-dev-ioctl-version-and-ismountpoint-user-accessible.patch

