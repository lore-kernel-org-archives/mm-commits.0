From: akpm@linux-foundation.org
Subject: + ecryptfs-swap-dput-and-mntput.patch added to -mm tree
Date: Mon, 17 Mar 2008 21:31:30 -0700
Message-ID: <200803180431.m2I4VUrK014269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbYCREdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhalcrow@us.ibm.com, rajouri.jammu@gmail.com, sandeen@redhat.com


The patch titled
     eCryptfs: Swap dput() and mntput()
has been added to the -mm tree.  Its filename is
     ecryptfs-swap-dput-and-mntput.patch

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
Subject: eCryptfs: Swap dput() and mntput()
From: Michael Halcrow <mhalcrow@us.ibm.com>

ecryptfs_d_release() is doing a mntput before doing the dput.  This patch
moves the dput before the mntput.

Thanks to Rajouri Jammu for reporting this.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Rajouri Jammu <rajouri.jammu@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/dentry.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-swap-dput-and-mntput fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-swap-dput-and-mntput
+++ a/fs/ecryptfs/dentry.c
@@ -80,8 +80,8 @@ static void ecryptfs_d_release(struct de
 {
 	if (ecryptfs_dentry_to_private(dentry)) {
 		if (ecryptfs_dentry_to_lower(dentry)) {
-			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 			dput(ecryptfs_dentry_to_lower(dentry));
+			mntput(ecryptfs_dentry_to_lower_mnt(dentry));
 		}
 		kmem_cache_free(ecryptfs_dentry_info_cache,
 				ecryptfs_dentry_to_private(dentry));
_

Patches currently in -mm which might be from mhalcrow@us.ibm.com are

ecryptfs-swap-dput-and-mntput.patch
git-unionfs.patch
remove-ecryptfs_header_cache_0.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
remove-duplicated-unlikely-in-is_err.patch

