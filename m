From: akpm@linux-foundation.org
Subject: + cifs-use-kzfree.patch added to -mm tree
Date: Thu, 19 Feb 2009 12:24:54 -0800
Message-ID: <200902192024.n1JKOsoR020700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbZBSUZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 15:25:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, penberg@cs.helsinki.fi, sfrench@samba.org


The patch titled
     cifs: use kzfree()
has been added to the -mm tree.  Its filename is
     cifs-use-kzfree.patch

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
@@ -2478,11 +2478,7 @@ mount_fail_check:
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

