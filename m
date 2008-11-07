From: akpm@linux-foundation.org
Subject: + vfs-fix-shrink_submounts.patch added to -mm tree
Date: Thu, 06 Nov 2008 17:23:15 -0800
Message-ID: <200811070123.mA71NFsY007826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYKGBYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs: fix shrink_submounts
has been added to the -mm tree.  Its filename is
     vfs-fix-shrink_submounts.patch

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
Subject: vfs: fix shrink_submounts
From: Eric W. Biederman <ebiederm@xmission.com>

In the last refactoring of shrink_submounts a variable was not completely
renamed.  So finish the renaming of mnt to m now.

Without this if you attempt to mount an nfs mount that has both automatic
nfs sub mounts on it, and has normal mounts on it.  The unmount will
succeed when it should not.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/namespace.c~vfs-fix-shrink_submounts fs/namespace.c
--- a/fs/namespace.c~vfs-fix-shrink_submounts
+++ a/fs/namespace.c
@@ -1815,8 +1815,8 @@ static void shrink_submounts(struct vfsm
 		while (!list_empty(&graveyard)) {
 			m = list_first_entry(&graveyard, struct vfsmount,
 						mnt_expire);
-			touch_mnt_namespace(mnt->mnt_ns);
-			umount_tree(mnt, 1, umounts);
+			touch_mnt_namespace(m->mnt_ns);
+			umount_tree(m, 1, umounts);
 		}
 	}
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

linux-next.patch
vfs-fix-shrink_submounts.patch
vmcore-remove-saved_max_pfn-check.patch

