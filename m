From: akpm@linux-foundation.org
Subject: [merged] ncpfs-use-memdup_user.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:31:26 -0700
Message-ID: <200904221831.n3MIVQwV006753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbZDVSd4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:33:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, petr@vandrovec.name, mm-commits@vger.kernel.org


The patch titled
     ncpfs: use memdup_user()
has been removed from the -mm tree.  Its filename was
     ncpfs-use-memdup_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ncpfs: use memdup_user()
From: Li Zefan <lizf@cn.fujitsu.com>

Remove open-coded memdup_user().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ioctl.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff -puN fs/ncpfs/ioctl.c~ncpfs-use-memdup_user fs/ncpfs/ioctl.c
--- a/fs/ncpfs/ioctl.c~ncpfs-use-memdup_user
+++ a/fs/ncpfs/ioctl.c
@@ -660,13 +660,10 @@ outrel:			
 			if (user.object_name_len > NCP_OBJECT_NAME_MAX_LEN)
 				return -ENOMEM;
 			if (user.object_name_len) {
-				newname = kmalloc(user.object_name_len, GFP_USER);
-				if (!newname)
-					return -ENOMEM;
-				if (copy_from_user(newname, user.object_name, user.object_name_len)) {
-					kfree(newname);
-					return -EFAULT;
-				}
+				newname = memdup_user(user.object_name,
+						      user.object_name_len);
+				if (IS_ERR(newname))
+					return PTR_ERR(newname);
 			} else {
 				newname = NULL;
 			}
@@ -760,13 +757,9 @@ outrel:			
 			if (user.len > NCP_PRIVATE_DATA_MAX_LEN)
 				return -ENOMEM;
 			if (user.len) {
-				new = kmalloc(user.len, GFP_USER);
-				if (!new)
-					return -ENOMEM;
-				if (copy_from_user(new, user.data, user.len)) {
-					kfree(new);
-					return -EFAULT;
-				}
+				new = memdup_user(user.data, user.len);
+				if (IS_ERR(new))
+					return PTR_ERR(new);
 			} else {
 				new = NULL;
 			}
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch

