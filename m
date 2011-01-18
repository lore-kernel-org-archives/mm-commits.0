From: akpm@linux-foundation.org
Subject: + vfs-ignore-error-on-forced-remount.patch added to -mm tree
Date: Tue, 18 Jan 2011 15:10:03 -0800
Message-ID: <201101182310.p0INA3lf011251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752283Ab1ARXKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 18:10:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     vfs: ignore error on forced remount
has been added to the -mm tree.  Its filename is
     vfs-ignore-error-on-forced-remount.patch

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
Subject: vfs: ignore error on forced remount
From: Miklos Szeredi <mszeredi@suse.cz>

On emergency remount we want to force MS_RDONLY on the super block even if
->remount_fs() failed for some reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/super.c~vfs-ignore-error-on-forced-remount fs/super.c
--- a/fs/super.c~vfs-ignore-error-on-forced-remount
+++ a/fs/super.c
@@ -583,7 +583,8 @@ int do_remount_sb(struct super_block *sb
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
+		/* If forced remount, go ahead despite any errors */
+		if (retval && !force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
vfs-ignore-error-on-forced-remount.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch

