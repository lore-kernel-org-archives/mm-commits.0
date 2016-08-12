From: akpm@linux-foundation.org
Subject: + autofs-fix-documentation-regarding-devid-on-ioctl.patch added
 to -mm tree
Date: Thu, 11 Aug 2016 20:07:20 -0700
Message-ID: <57ad3d68.ohPYt9FxsdVe5kT9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHLDHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix Documentation regarding devid on ioctl
has been added to the -mm tree.  Its filename is
     autofs-fix-documentation-regarding-devid-on-ioctl.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-documentation-regarding-devid-on-ioctl.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-documentation-regarding-devid-on-ioctl.patch

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
Subject: autofs: fix Documentation regarding devid on ioctl

The explanation on how ioctl handles devid seems incorrect.  Userspace who
calls this ioctl has no input regarding devid, and ioctl implementation
retrieves devid via superblock.

Link: http://lkml.kernel.org/r/20160812024825.12352.13486.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/autofs4-mount-control.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/autofs4-mount-control.txt~autofs-fix-documentation-regarding-devid-on-ioctl Documentation/filesystems/autofs4-mount-control.txt
--- a/Documentation/filesystems/autofs4-mount-control.txt~autofs-fix-documentation-regarding-devid-on-ioctl
+++ a/Documentation/filesystems/autofs4-mount-control.txt
@@ -323,9 +323,8 @@ mount on the given path dentry.
 
 The call requires an initialized struct autofs_dev_ioctl with the path
 field set to the mount point in question and the size field adjusted
-appropriately as well as the arg1 field set to the device number of the
-containing autofs mount. Upon return the struct field arg1 contains the
-uid and arg2 the gid.
+appropriately. Upon return the struct field arg1 contains the uid and
+arg2 the gid.
 
 When reconstructing an autofs mount tree with active mounts we need to
 re-connect to mounts that may have used the original process uid and
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

