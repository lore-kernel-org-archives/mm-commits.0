From: akpm@linux-foundation.org
Subject: + selinux-fix-something.patch added to -mm tree
Date: Tue, 05 Jun 2012 12:51:17 -0700
Message-ID: <20120605195119.21A2DA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:33588 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2FETvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 15:51:20 -0400
Received: by ghbz15 with SMTP id z15so628014ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 12:51:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com


The patch titled
     Subject: selinux: fix something
has been added to the -mm tree.  Its filename is
     selinux-fix-something.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Paris <eparis@redhat.com>
Subject: selinux: fix something



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~selinux-fix-something security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-fix-something
+++ a/security/selinux/hooks.c
@@ -2717,7 +2717,7 @@ static int selinux_inode_setattr(struct 
 			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, dentry, FILE__SETATTR);
 
-	if (ia_valid & ATTR_SIZE)
+	if ((ia_valid & ATTR_SIZE) && selinux_policycap_openperm)
 		av |= FILE__OPEN;
 
 	return dentry_has_perm(cred, dentry, av);
_
Subject: Subject: selinux: fix something

Patches currently in -mm which might be from eparis@redhat.com are

selinux-fix-something.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch

