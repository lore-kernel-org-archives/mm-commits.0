From: akpm@linux-foundation.org
Subject: - ecryptfs-fix-missed-mutex_unlock.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:37 -0700
Message-ID: <200805270726.m4R7QbDJ014684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804AbYE0H13 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:27:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: fix missed mutex_unlock
has been removed from the -mm tree.  Its filename was
     ecryptfs-fix-missed-mutex_unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: fix missed mutex_unlock
From: Cyrill Gorcunov <gorcunov@gmail.com>

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-fix-missed-mutex_unlock
+++ a/fs/ecryptfs/crypto.c
@@ -1906,9 +1906,9 @@ int ecryptfs_get_tfm_and_mutex_for_ciphe
 			goto out;
 		}
 	}
-	mutex_unlock(&key_tfm_list_mutex);
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
+	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

linux-next.patch

