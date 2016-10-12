From: akpm@linux-foundation.org
Subject: [merged] autofs-fix-print-format-for-ioctl-warning-message.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:24:06 -0700
Message-ID: <57fe8dd6.ZBxJtpNdJV7St8iu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33197 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755936AbcJLTYh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix print format for ioctl warning message
has been removed from the -mm tree.  Its filename was
     autofs-fix-print-format-for-ioctl-warning-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: fix print format for ioctl warning message

All other warnings use "cmd(0x%08x)" and this is the only one with
"cmd(%d)".  (below comes from my userspace debug program, but not
automount daemon)

[ 1139.905676] autofs4:pid:1640:check_dev_ioctl_version: ioctl control interface version mismatch: kernel(1.0), user(0.0), cmd(-1072131215)

Link: http://lkml.kernel.org/r/20160812024851.12352.75458.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-fix-print-format-for-ioctl-warning-message fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-fix-print-format-for-ioctl-warning-message
+++ a/fs/autofs4/dev-ioctl.c
@@ -75,7 +75,7 @@ static int check_dev_ioctl_version(int c
 	if ((param->ver_major != AUTOFS_DEV_IOCTL_VERSION_MAJOR) ||
 	    (param->ver_minor > AUTOFS_DEV_IOCTL_VERSION_MINOR)) {
 		pr_warn("ioctl control interface version mismatch: "
-			"kernel(%u.%u), user(%u.%u), cmd(%d)\n",
+			"kernel(%u.%u), user(%u.%u), cmd(0x%08x)\n",
 			AUTOFS_DEV_IOCTL_VERSION_MAJOR,
 			AUTOFS_DEV_IOCTL_VERSION_MINOR,
 			param->ver_major, param->ver_minor, cmd);
_

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


