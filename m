From: akpm@linux-foundation.org
Subject: + reiser4-fix-kill_hook_internal.patch added to -mm tree
Date: Tue, 06 May 2008 13:38:49 -0700
Message-ID: <200805062038.m46KcnJ1026126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759900AbYEFUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: fix kill_hook_internal
has been added to the -mm tree.  Its filename is
     reiser4-fix-kill_hook_internal.patch

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
Subject: reiser4: fix kill_hook_internal
From: Edward Shishkin <edward.shishkin@gmail.com>

Problem:
Failed assertion (nikita-2754): child znode is not loaded
when looking at its number of items in kill_hook_internal().
Nobody cares about its loading.

Fixup:
Added missed zload/zrelse of the child.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/item/internal.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/reiser4/plugin/item/internal.c~reiser4-fix-kill_hook_internal fs/reiser4/plugin/item/internal.c
--- a/fs/reiser4/plugin/item/internal.c~reiser4-fix-kill_hook_internal
+++ a/fs/reiser4/plugin/item/internal.c
@@ -308,6 +308,7 @@ int kill_hook_internal(const coord_t * i
 		       struct carry_kill_data *p UNUSED_ARG)
 {
 	znode *child;
+	int result = 0;
 
 	assert("nikita-1222", item != NULL);
 	assert("nikita-1224", from == 0);
@@ -316,7 +317,14 @@ int kill_hook_internal(const coord_t * i
 	child = znode_at(item, item->node);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
-	else if (node_is_empty(child)) {
+	assert("edward-1560", child != NULL);
+
+	result = zload(child);
+	if (result) {
+		zput(child);
+		return result;
+	}
+	if (node_is_empty(child)) {
 		reiser4_tree *tree;
 
 		assert("nikita-1397", znode_is_write_locked(child));
@@ -328,14 +336,14 @@ int kill_hook_internal(const coord_t * i
 		init_parent_coord(&child->in_parent, NULL);
 		--item->node->c_count;
 		write_unlock_tree(tree);
-		zput(child);
-		return 0;
 	} else {
 		warning("nikita-1223",
 			"Cowardly refuse to remove link to non-empty node");
-		zput(child);
-		return RETERR(-EIO);
+		result = RETERR(-EIO);
 	}
+	zrelse(child);
+	zput(child);
+	return result;
 }
 
 /* hook called by ->shift() node plugin method when iternal item was just
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

reiser4.patch
reiser4-fix-handling-enospc-cryptcompress.patch
reiser4-fix-handling-enospc-unix_file.patch
reiser4-fix-kill_hook_internal.patch

