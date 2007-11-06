From: akpm@linux-foundation.org
Subject: - ecryptfs-increment-extent_offset-once-per-loop-interation.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:52:35 -0800
Message-ID: <200711060552.lA65qZwp007333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769AbXKFFxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:53:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: increment extent_offset once per loop interation
has been removed from the -mm tree.  Its filename was
     ecryptfs-increment-extent_offset-once-per-loop-interation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: increment extent_offset once per loop interation
From: Michael Halcrow <mhalcrow@us.ibm.com>

The extent_offset is getting incremented twice per loop iteration through any
given page.  It should only be getting incremented once.  This bug should only
impact hosts with >4K page sizes.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ecryptfs/crypto.c~ecryptfs-increment-extent_offset-once-per-loop-interation fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~ecryptfs-increment-extent_offset-once-per-loop-interation
+++ a/fs/ecryptfs/crypto.c
@@ -504,7 +504,6 @@ int ecryptfs_encrypt_page(struct page *p
 					"\n", rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
@@ -640,7 +639,6 @@ int ecryptfs_decrypt_page(struct page *p
 			       "rc = [%d]\n", __FUNCTION__, rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

origin.patch
ecryptfs-cast-page-index-to-loff_t-instead-of-off_t.patch
git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
d_path-make-d_path-use-a-struct-path.patch
