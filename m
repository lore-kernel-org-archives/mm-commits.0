From: akpm@linux-foundation.org
Subject: + vfs-increment-iversion-when-a-file-is-truncated.patch added to -mm tree
Date: Wed, 04 Jan 2012 15:28:08 -0800
Message-ID: <20120104232809.124B220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34920 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2ADX2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 18:28:11 -0500
Received: by eekc1 with SMTP id c1so617943eek.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 15:28:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmitry.kasatkin@intel.com, viro@zeniv.linux.org.uk, zohar@us.ibm.com


The patch titled
     Subject: vfs: increment iversion when a file is truncated
has been added to the -mm tree.  Its filename is
     vfs-increment-iversion-when-a-file-is-truncated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: vfs: increment iversion when a file is truncated

When a file is truncated with truncate()/ftruncate() and then closed,
iversion is not updated.  This patch uses ATTR_SIZE flag as an indication
to increment iversion.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated fs/attr.c
--- a/fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated
+++ a/fs/attr.c
@@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
+		if (attr->ia_size != inode->i_size)
+			inode_inc_iversion(inode);
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		umode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */
_
Subject: Subject: vfs: increment iversion when a file is truncated

Patches currently in -mm which might be from dmitry.kasatkin@intel.com are

linux-next.patch
vfs-increment-iversion-when-a-file-is-truncated.patch

