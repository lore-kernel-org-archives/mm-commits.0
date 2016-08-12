From: akpm@linux-foundation.org
Subject: + autofs-fix-print-format-for-ioctl-warning-message.patch added
 to -mm tree
Date: Thu, 11 Aug 2016 20:07:30 -0700
Message-ID: <57ad3d72.dANcFmc7ILT0dDde%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbcHLDRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix print format for ioctl warning message
has been added to the -mm tree.  Its filename is
     autofs-fix-print-format-for-ioctl-warning-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-print-format-for-ioctl-warning-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-print-format-for-ioctl-warning-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

autofs-fix-typos-in-documentation-filesystems-autofs4txt.patch
autofs-drop-unnecessary-extern-in-autofs_ih.patch
autofs-test-autofs-versions-first-on-sb-initialization.patch
autofs-add-warn_on1-for-non-dir-link-inode-case.patch
autofs-use-autofs4_free_ino-to-kfree-dentry-data.patch
autofs-remove-obsolete-sb-fields.patch
autofs-dont-fail-to-free_dev_ioctlparam.patch
autofs-remove-autofs_devid_len.patch
autofs-fix-documentation-regarding-devid-on-ioctl.patch
autofs-update-struct-autofs_dev_ioctl-in-documentation.patch
autofs-fix-pr_debug-message.patch
autofs-fix-print-format-for-ioctl-warning-message.patch
autofs-move-inclusion-of-linux-limitsh-to-uapi.patch

