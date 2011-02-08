From: akpm@linux-foundation.org
Subject: + fs-nameic-fix-filp_cachep-memory-corruption.patch added to -mm tree
Date: Tue, 08 Feb 2011 15:26:50 -0800
Message-ID: <201102082326.p18NQovm031862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab1BHX0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 18:26:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, npiggin@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     fs/namei.c: fix filp_cachep memory corruption
has been added to the -mm tree.  Its filename is
     fs-nameic-fix-filp_cachep-memory-corruption.patch

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

fs-nameic-fix-filp_cachep-memory-corruption.patch

