From: akpm@linux-foundation.org
Subject: + ecryptfs-increment-extent_offset-once-per-loop-interation.patch added to -mm tree
Date: Fri, 02 Nov 2007 13:08:39 -0700
Message-ID: <200711022008.lA2K8dxg008856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbXKBUSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 16:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com


The patch titled
     eCryptfs: increment extent_offset once per loop interation
has been added to the -mm tree.  Its filename is
     ecryptfs-increment-extent_offset-once-per-loop-interation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -503,7 +503,6 @@ int ecryptfs_encrypt_page(struct page *p
 					"\n", rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
@@ -639,7 +638,6 @@ int ecryptfs_decrypt_page(struct page *p
 			       "rc = [%d]\n", __FUNCTION__, rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

git-unionfs.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
fs-ecryptfs-possible-cleanups.patch
ecryptfs-track-header-bytes-rather-than-extents.patch
ecryptfs-increment-extent_offset-once-per-loop-interation.patch
ecryptfs-set-inode-key-only-once-per-crypto-operation.patch
