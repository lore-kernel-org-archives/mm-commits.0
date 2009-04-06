From: akpm@linux-foundation.org
Subject: [merged] cifs-use-kzfree.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:01 -0700
Message-ID: <200904061939.n36Jd10H013632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529AbZDFTmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, penberg@cs.helsinki.fi, sfrench@samba.org, mm-commits@vger.kernel.org


The patch titled
     cifs: use kzfree()
has been removed from the -mm tree.  Its filename was
     cifs-use-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/connect.c |    6 +-----
 fs/cifs/misc.c    |   10 ++--------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff -puN fs/cifs/connect.c~cifs-use-kzfree fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-use-kzfree
+++ a/fs/cifs/connect.c
@@ -2485,11 +2485,7 @@ mount_fail_check:
 out:
 	/* zero out password before freeing */
 	if (volume_info) {
-		if (volume_info->password != NULL) {
-			memset(volume_info->password, 0,
-				strlen(volume_info->password));
-			kfree(volume_info->password);
-		}
+		kzfree(volume_info->password);
 		kfree(volume_info->UNC);
 		kfree(volume_info->prepath);
 		kfree(volume_info);
diff -puN fs/cifs/misc.c~cifs-use-kzfree fs/cifs/misc.c
--- a/fs/cifs/misc.c~cifs-use-kzfree
+++ a/fs/cifs/misc.c
@@ -97,10 +97,7 @@ sesInfoFree(struct cifsSesInfo *buf_to_f
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free->domainName);
 	kfree(buf_to_free);
 }
@@ -132,10 +129,7 @@ tconInfoFree(struct cifsTconInfo *buf_to
 	}
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free);
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch

