From: akpm@linux-foundation.org
Subject: [alternative-merged] fs-nameic-fix-filp_cachep-memory-corruption.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:18:07 -0800
Message-ID: <201102142018.p1EKI7DE022954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab1BNUS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hooanon05@yahoo.co.jp, npiggin@kernel.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/namei.c: fix filp_cachep memory corruption
has been removed from the -mm tree.  Its filename was
     fs-nameic-fix-filp_cachep-memory-corruption.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/namei.c: fix filp_cachep memory corruption
From: J. R. Okajima <hooanon05@yahoo.co.jp>

In 31e6b01 ("fs: rcu-walk for path lookup") the condition "-ESTALE &&
!LOOKUP_REVAL" is added to "goto reval" in do_filp_open(), and it looks up
again with LOOKUP_REVAL _after_ release_open_intent().  Since
release_open_intent() is called by do_last() and finish_open() too, add
the same condition to all of them.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/namei.c~fs-nameic-fix-filp_cachep-memory-corruption fs/namei.c
--- a/fs/namei.c~fs-nameic-fix-filp_cachep-memory-corruption
+++ a/fs/namei.c
@@ -2265,7 +2265,8 @@ static struct file *finish_open(struct n
 	return filp;
 
 exit:
-	if (!IS_ERR(nd->intent.open.file))
+	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_put(&nd->path);
 	return ERR_PTR(error);
@@ -2389,7 +2390,8 @@ exit_mutex_unlock:
 exit_dput:
 	path_put_conditional(path, nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
+	if (!(error == -ESTALE && !(nd->flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd->intent.open.file))
 		release_open_intent(nd);
 	path_put(&nd->path);
 	return ERR_PTR(error);
@@ -2560,7 +2562,8 @@ exit_dput:
 out_path:
 	path_put(&nd.path);
 out_filp:
-	if (!IS_ERR(nd.intent.open.file))
+	if (!(error == -ESTALE && !(flags & LOOKUP_REVAL))
+	    && !IS_ERR(nd.intent.open.file))
 		release_open_intent(&nd);
 	filp = ERR_PTR(error);
 	goto out;
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

origin.patch

