From: akpm@linux-foundation.org
Subject: + bsdacct-fix-access-to-invalid-filp-in-acct_on.patch added to -mm tree
Date: Thu, 25 Jun 2009 11:37:35 -0700
Message-ID: <200906251837.n5PIbZwZ032236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZFYShk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 14:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: renaud.lottiaux@kerlabs.com, louis.rilling@kerlabs.com, viro@zeniv.linux.org.uk


The patch titled
     bsdacct: fix access to invalid filp in acct_on()
has been added to the -mm tree.  Its filename is
     bsdacct-fix-access-to-invalid-filp-in-acct_on.patch

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
Subject: bsdacct: fix access to invalid filp in acct_on()
From: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>

The file opened in acct_on and freshly stored in the ns->bacct struct can
be closed in acct_file_reopen by a concurrent call after we release
acct_lock and before we call mntput(file->f_path.mnt).

Record file->f_path.mnt in a local variable and use this variable only.

Signed-off-by: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>
Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/acct.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/acct.c~bsdacct-fix-access-to-invalid-filp-in-acct_on kernel/acct.c
--- a/kernel/acct.c~bsdacct-fix-access-to-invalid-filp-in-acct_on
+++ a/kernel/acct.c
@@ -215,6 +215,7 @@ static void acct_file_reopen(struct bsd_
 static int acct_on(char *name)
 {
 	struct file *file;
+	struct vfsmount *mnt;
 	int error;
 	struct pid_namespace *ns;
 	struct bsd_acct_struct *acct = NULL;
@@ -256,11 +257,12 @@ static int acct_on(char *name)
 		acct = NULL;
 	}
 
-	mnt_pin(file->f_path.mnt);
+	mnt = file->f_path.mnt;
+	mnt_pin(mnt);
 	acct_file_reopen(ns->bacct, file, ns);
 	spin_unlock(&acct_lock);
 
-	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
+	mntput(mnt); /* it's pinned, now give up active reference */
 	kfree(acct);
 
 	return 0;
_

Patches currently in -mm which might be from renaud.lottiaux@kerlabs.com are

bsdacct-fix-access-to-invalid-filp-in-acct_on.patch

