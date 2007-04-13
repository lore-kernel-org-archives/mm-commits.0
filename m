From: akpm@linux-foundation.org
Subject: - autofs4-fix-race-in-unhashed-dentry-code.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:23 -0700
Message-ID: <200704132328.l3DNSNxs012517@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60334 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161041AbXDMX23 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix race in unhashed dentry code
has been removed from the -mm tree.  Its filename was
     autofs4-fix-race-in-unhashed-dentry-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs4: fix race in unhashed dentry code
From: Jeff Mahoney <jeffm@suse.com>

Commit f50b6f8691cae2e0064c499dd3ef3f31142987f0 introduced a race in
autofs4 between autofs_lookup_unhashed() and autofs_dentry_release().

autofs_dentry_release() ends up clearing the ->dentry and ->inode members
of autofs_info before removing it from the rehash list.  The list is
protected by the rehash lock in both functions, but since
autofs_dentry_release() starts tearing the autofs_info struct down before
removing it from the list, autofs_lookup_unhashed() can get a autofs_info
with a NULL dentry.

This patch moves the clearing of ->dentry and ->inode after the removal
from the rehash list.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-race-in-unhashed-dentry-code fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-race-in-unhashed-dentry-code
+++ a/fs/autofs4/root.c
@@ -470,9 +470,6 @@ void autofs4_dentry_release(struct dentr
 	if (inf) {
 		struct autofs_sb_info *sbi = autofs4_sbi(de->d_sb);
 
-		inf->dentry = NULL;
-		inf->inode = NULL;
-
 		if (sbi) {
 			spin_lock(&sbi->rehash_lock);
 			if (!list_empty(&inf->rehash))
@@ -480,6 +477,9 @@ void autofs4_dentry_release(struct dentr
 			spin_unlock(&sbi->rehash_lock);
 		}
 
+		inf->dentry = NULL;
+		inf->inode = NULL;
+
 		autofs4_free_ino(inf);
 	}
 }
_

Patches currently in -mm which might be from jeffm@suse.com are

origin.patch
