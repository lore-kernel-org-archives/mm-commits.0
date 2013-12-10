From: akpm@linux-foundation.org
Subject: + proc-set-attributes-of-pde-using-accessor-functions.patch added to -mm tree
Date: Tue, 10 Dec 2013 15:03:45 -0800
Message-ID: <52a79dd1.gVHil2LI4Byepikn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3LJXDq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Dec 2013 18:03:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rui.xiang@huawei.com

Subject: + proc-set-attributes-of-pde-using-accessor-functions.patch added to -mm tree
To: rui.xiang@huawei.com
From: akpm@linux-foundation.org
Date: Tue, 10 Dec 2013 15:03:45 -0800


The patch titled
     Subject: proc: set attributes of pde using accessor functions
has been added to the -mm tree.  Its filename is
     proc-set-attributes-of-pde-using-accessor-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-set-attributes-of-pde-using-accessor-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-set-attributes-of-pde-using-accessor-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: proc: set attributes of pde using accessor functions

Use existing accessors proc_set_user() and proc_set_size() to set
attributes.  Just a cleanup.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c      |    3 +--
 fs/proc/proc_devtree.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/proc/generic.c~proc-set-attributes-of-pde-using-accessor-functions fs/proc/generic.c
--- a/fs/proc/generic.c~proc-set-attributes-of-pde-using-accessor-functions
+++ a/fs/proc/generic.c
@@ -49,8 +49,7 @@ static int proc_notify_change(struct den
 	setattr_copy(inode, iattr);
 	mark_inode_dirty(inode);
 
-	de->uid = inode->i_uid;
-	de->gid = inode->i_gid;
+	proc_set_user(de, inode->i_uid, inode->i_gid);
 	de->mode = inode->i_mode;
 	return 0;
 }
diff -puN fs/proc/proc_devtree.c~proc-set-attributes-of-pde-using-accessor-functions fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~proc-set-attributes-of-pde-using-accessor-functions
+++ a/fs/proc/proc_devtree.c
@@ -74,9 +74,9 @@ __proc_device_tree_add_prop(struct proc_
 		return NULL;
 
 	if (!strncmp(name, "security-", 9))
-		ent->size = 0; /* don't leak number of password chars */
+		proc_set_size(ent, 0); /* don't leak number of password chars */
 	else
-		ent->size = pp->length;
+		proc_set_size(ent, pp->length);
 
 	return ent;
 }
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

autofs-fix-the-return-value-of-autofs4_fill_super.patch
autofs-use-is_root-to-replace-root-dentry-checks.patch
proc-set-attributes-of-pde-using-accessor-functions.patch

