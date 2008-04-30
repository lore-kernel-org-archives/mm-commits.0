From: akpm@linux-foundation.org
Subject: + autofs4-check-for-invalid-dentry-in-getpath.patch added to -mm tree
Date: Wed, 30 Apr 2008 13:34:27 -0700
Message-ID: <200804302034.m3UKYRx9001593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759165AbYD3Ueb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 16:34:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: check for invalid dentry in getpath
has been added to the -mm tree.  Its filename is
     autofs4-check-for-invalid-dentry-in-getpath.patch

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
Subject: autofs4: check for invalid dentry in getpath
From: Ian Kent <raven@themaw.net>

Catch invalid dentry when calculating its path.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs4-check-for-invalid-dentry-in-getpath fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-check-for-invalid-dentry-in-getpath
+++ a/fs/autofs4/waitq.c
@@ -171,7 +171,7 @@ static int autofs4_getpath(struct autofs
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
-	if (--len > NAME_MAX) {
+	if (!len || --len > NAME_MAX) {
 		spin_unlock(&dcache_lock);
 		return 0;
 	}
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
autofs4-check-for-invalid-dentry-in-getpath.patch
autofs4-fix-execution-order-race-in-mount-request-code.patch
autofs4-fix-incorrect-return-from-rootc-try_to_fill_dentry.patch
autofs-path_getput-cleanups.patch

