From: akpm@linux-foundation.org
Subject: + ncpfs-use-memdup_user.patch added to -mm tree
Date: Thu, 09 Apr 2009 22:35:44 -0700
Message-ID: <200904100535.n3A5ZifC015144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935931AbZDJFhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 01:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, petr@vandrovec.name


The patch titled
     ncpfs: use memdup_user()
has been added to the -mm tree.  Its filename is
     ncpfs-use-memdup_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

documentation-sysctl-nettxt-fix-a-typo.patch
cls_cgroup-remove-unneeded-cgroup_lock.patch
devcgroup-skip-superfluous-checks-when-found-the-dev_all-elem.patch
xattr-use-memdup_user.patch
btrfs-use-memdup_user.patch
sysfs-use-memdup_user.patch
xfs-use-memdup_user.patch
ncpfs-use-memdup_user.patch
ecryptfs-use-memdup_user.patch

