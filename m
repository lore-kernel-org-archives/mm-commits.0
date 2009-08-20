From: akpm@linux-foundation.org
Subject: + selinux-adjust-rules-for-attr_force.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:35:13 -0700
Message-ID: <200908202135.n7KLZDsI031004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbZHTVgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:36:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, eparis@redhat.com, eteo@redhat.com, hch@lst.de, hirofumi@mail.parknet.co.jp, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     selinux: adjust rules for ATTR_FORCE
has been added to the -mm tree.  Its filename is
     selinux-adjust-rules-for-attr_force.patch

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
Subject: selinux: adjust rules for ATTR_FORCE
From: Amerigo Wang <amwang@redhat.com>

As suggested by OGAWA Hirofumi in thread:
http://lkml.org/lkml/2009/8/7/132, we should let selinux_inode_setattr()
to match our ATTR_* rules.  ATTR_FORCE should not force things like
ATTR_SIZE.

[hirofumi@mail.parknet.co.jp: tweaks]
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN security/selinux/hooks.c~selinux-adjust-rules-for-attr_force security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-adjust-rules-for-attr_force
+++ a/security/selinux/hooks.c
@@ -2711,12 +2711,18 @@ static int selinux_inode_permission(stru
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	const struct cred *cred = current_cred();
+	unsigned int ia_valid = iattr->ia_valid;
 
-	if (iattr->ia_valid & ATTR_FORCE)
-		return 0;
+	/* ATTR_FORCE is just used for ATTR_KILL_S[UG]ID. */
+	if (ia_valid & ATTR_FORCE) {
+		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_MODE |
+			      ATTR_FORCE);
+		if (!ia_valid)
+			return 0;
+	}
 
-	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
-			       ATTR_ATIME_SET | ATTR_MTIME_SET))
+	if (ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
 
 	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
selinux-adjust-rules-for-attr_force.patch
vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
xtensa-use-generic-sys_pipe.patch
kcore-fix-proc-kcores-statst_size.patch
elf-clean-up-fill_note_info.patch
elf-clean-up-fill_note_info-fix.patch

