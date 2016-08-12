From: akpm@linux-foundation.org
Subject: + autofs-add-warn_on1-for-non-dir-link-inode-case.patch added to
 -mm tree
Date: Thu, 11 Aug 2016 20:07:07 -0700
Message-ID: <57ad3d5b.l0gk5Trz/dZqFEDk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbcHLDHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: add WARN_ON(1) for non dir/link inode case
has been added to the -mm tree.  Its filename is
     autofs-add-warn_on1-for-non-dir-link-inode-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-add-warn_on1-for-non-dir-link-inode-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-add-warn_on1-for-non-dir-link-inode-case.patch

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
Subject: autofs: add WARN_ON(1) for non dir/link inode case

It's invalid if the given mode is neither dir nor link, so warn on else
case.

Link: http://lkml.kernel.org/r/20160812024754.12352.8536.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/inode.c~autofs-add-warn_on1-for-non-dir-link-inode-case fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-add-warn_on1-for-non-dir-link-inode-case
+++ a/fs/autofs4/inode.c
@@ -368,7 +368,8 @@ struct inode *autofs4_get_inode(struct s
 		inode->i_fop = &autofs4_dir_operations;
 	} else if (S_ISLNK(mode)) {
 		inode->i_op = &autofs4_symlink_inode_operations;
-	}
+	} else
+		WARN_ON(1);
 
 	return inode;
 }
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

