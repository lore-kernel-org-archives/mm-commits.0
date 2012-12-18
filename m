From: akpm@linux-foundation.org
Subject: [merged] vfs-increment-iversion-when-a-file-is-truncated.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:51:06 -0800
Message-ID: <20121218205107.3BCDE200167@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:36935 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab2LRUvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:51:10 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so71127lbc.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:51:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitry.kasatkin@intel.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk, zohar@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: increment iversion when a file is truncated
has been removed from the -mm tree.  Its filename was
     vfs-increment-iversion-when-a-file-is-truncated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: vfs: increment iversion when a file is truncated

When a file is truncated with truncate()/ftruncate() and then closed,
iversion is not updated.  This patch uses ATTR_SIZE flag as an indication
to increment iversion.

Mimi said:

On fput(), i_version is used to detect and flag files that have changed
and need to be re-measured in the IMA measurement policy.  When a file
is truncated with truncate()/ftruncate() and then closed, i_version is
not updated.  As a result, although the file has changed, it will not be
re-measured and added to the IMA measurement list on subsequent access.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated fs/attr.c
--- a/fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated
+++ a/fs/attr.c
@@ -187,6 +187,11 @@ int notify_change(struct dentry * dentry
 			inode_inc_iversion(inode);
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

Patches currently in -mm which might be from dmitry.kasatkin@intel.com are

origin.patch

