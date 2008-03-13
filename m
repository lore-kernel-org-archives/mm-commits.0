From: akpm@linux-foundation.org
Subject: + quota-remove-superfluous-dquot_off-in-fs-namespacec.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:46:41 -0700
Message-ID: <200803132146.m2DLkfWK001922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYCMVqp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:46:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz


The patch titled
     quota: remove superfluous DQUOT_OFF() in fs/namespace.c
has been added to the -mm tree.  Its filename is
     quota-remove-superfluous-dquot_off-in-fs-namespacec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove superfluous DQUOT_OFF() in fs/namespace.c
From: Jan Kara <jack@suse.cz>

We don't need to turn quotas off before remounting root ro, because
do_remount_sb() already handles this.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/namespace.c~quota-remove-superfluous-dquot_off-in-fs-namespacec fs/namespace.c
--- a/fs/namespace.c~quota-remove-superfluous-dquot_off-in-fs-namespacec
+++ a/fs/namespace.c
@@ -14,7 +14,6 @@
 #include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/quotaops.h>
 #include <linux/acct.h>
 #include <linux/capability.h>
 #include <linux/cpumask.h>
@@ -928,7 +927,6 @@ static int do_umount(struct vfsmount *mn
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY)) {
 			lock_kernel();
-			DQUOT_OFF(sb);
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
 			unlock_kernel();
 		}
_

Patches currently in -mm which might be from jack@suse.cz are

git-udf.patch
git-ocfs2.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-add-possibly-missing-iput-when-quotaon-and-quotaoff-races.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
quota-le_add_cpu-conversion.patch

