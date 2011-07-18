From: akpm@linux-foundation.org
Subject: + vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp.patch added to -mm tree
Date: Mon, 18 Jul 2011 13:23:45 -0700
Message-ID: <201107182023.p6IKNj0q025681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239Ab1GRUXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 16:23:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, viro@zeniv.linux.org.uk


The patch titled
     vfs: use ERR_CAST for err-ptr tossing in lookup_instantiate_filp
has been added to the -mm tree.  Its filename is
     vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp.patch

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
Subject: vfs: use ERR_CAST for err-ptr tossing in lookup_instantiate_filp
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

Replace unclear (struct dentry *) to (struct file *) typecast with
ERR_CAST() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/open.c~vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp fs/open.c
--- a/fs/open.c~vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp
+++ a/fs/open.c
@@ -793,7 +793,7 @@ out:
 	return nd->intent.open.file;
 out_err:
 	release_open_intent(nd);
-	nd->intent.open.file = (struct file *)dentry;
+	nd->intent.open.file = ERR_CAST(dentry);
 	goto out;
 }
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch
vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp.patch

