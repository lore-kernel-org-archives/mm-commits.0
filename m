From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-forgotten-format-specifier.patch added to -mm tree
Date: Wed, 14 Feb 2007 14:03:47 -0800
Message-ID: <200702142203.l1EM3lab010691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbXBNWHF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 17:07:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: t.hisch@gmail.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix forgotten format specifier
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-forgotten-format-specifier.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: fix forgotten format specifier
From: Thomas Hisch <t.hisch@gmail.com>

Add format specifier %d for uid in ecryptfs_printk

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/messaging.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ecryptfs/messaging.c~ecryptfs-fix-forgotten-format-specifier fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-fix-forgotten-format-specifier
+++ a/fs/ecryptfs/messaging.c
@@ -169,7 +169,8 @@ int ecryptfs_process_helo(unsigned int t
 	if (!new_id) {
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR, "Failed to allocate memory; unable "
-				"to register daemon [%d] for user\n", pid, uid);
+				"to register daemon [%d] for user [%d]\n",
+				pid, uid);
 		goto unlock;
 	}
 	if (!ecryptfs_find_daemon_id(uid, &old_id)) {
_

Patches currently in -mm which might be from t.hisch@gmail.com are

ecryptfs-fix-forgotten-format-specifier.patch
