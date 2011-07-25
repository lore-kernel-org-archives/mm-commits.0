From: akpm@linux-foundation.org
Subject: [merged] vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp.patch removed from -mm tree
Date: Mon, 25 Jul 2011 12:04:58 -0700
Message-ID: <201107251904.p6PJ47pf022531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab1GYTEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 15:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: use ERR_CAST for err-ptr tossing in lookup_instantiate_filp
has been removed from the -mm tree.  Its filename was
     vfs-use-err_cast-for-err-ptr-tossing-in-lookup_instantiate_filp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-remove-useless-rcu-lock-unlock-from-mapping_tagged.patch

