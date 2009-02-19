From: akpm@linux-foundation.org
Subject: + ecryptfs-use-kzfree.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:24:56 -0800
Message-ID: <200902192024.n1JKOuAH020703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbZBSUZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, penberg@cs.helsinki.fi, tyhicks@linux.vnet.ibm.com


The patch titled
     ecryptfs: use kzfree()
has been added to the -mm tree.  Its filename is
     ecryptfs-use-kzfree.patch

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

slab-introduce-kzfree.patch
linux-next.patch
crypto-use-kzfree.patch
s390-use-kzfree.patch
md-use-kzfree.patch
usb-use-kzfree.patch
cifs-use-kzfree.patch
ecryptfs-use-kzfree.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-shrink_all_memory-use-scnr_reclaimed.patch
mm-shrink_all_memory-use-scnr_reclaimed-checkpatch-fixes.patch
vmscan-clip-swap_cluster_max-in-shrink_all_memory.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch

