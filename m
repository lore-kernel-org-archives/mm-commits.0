From: akpm@linux-foundation.org
Subject: [merged] ecryptfs-use-kzfree.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:35 -0700
Message-ID: <200904011841.n31IfZRu009404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764123AbZDATXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, penberg@cs.helsinki.fi, tyhicks@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: use kzfree()
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-kzfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: use kzfree()
From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/keystore.c  |    3 +--
 fs/ecryptfs/messaging.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/keystore.c~ecryptfs-use-kzfree fs/ecryptfs/keystore.c
--- a/fs/ecryptfs/keystore.c~ecryptfs-use-kzfree
+++ a/fs/ecryptfs/keystore.c
@@ -740,8 +740,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 out_release_free_unlock:
 	crypto_free_hash(s->hash_desc.tfm);
 out_free_unlock:
-	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);
-	kfree(s->block_aligned_filename);
+	kzfree(s->block_aligned_filename);
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
diff -puN fs/ecryptfs/messaging.c~ecryptfs-use-kzfree fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c~ecryptfs-use-kzfree
+++ a/fs/ecryptfs/messaging.c
@@ -291,8 +291,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 	if (daemon->user_ns)
 		put_user_ns(daemon->user_ns);
 	mutex_unlock(&daemon->mux);
-	memset(daemon, 0, sizeof(*daemon));
-	kfree(daemon);
+	kzfree(daemon);
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
cifs-use-kzfree.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

