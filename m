From: akpm@linux-foundation.org
Subject: - nfs-remove-8-bytes-of-padding-from-struct-nfs_fattr-on-64-bit-builds.patch removed from -mm tree
Date: Thu, 09 Oct 2008 15:28:26 -0700
Message-ID: <200810092228.m99MSQuu006074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYJIW2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2008 18:28:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, mm-commits@vger.kernel.org


The patch titled
     nfs: remove 8 bytes of padding from struct nfs_fattr on 64 bit builds
has been removed from the -mm tree.  Its filename was
     nfs-remove-8-bytes-of-padding-from-struct-nfs_fattr-on-64-bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: remove 8 bytes of padding from struct nfs_fattr on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

remove 8 bytes of padding from struct nfs_fattr on 64 bit builds

This also removes padding from several nfs structures, including
16 bytes from  nfs4_opendata, nfs4_createdata,nfs3_createdata
& 8 bytes from nfs_read_data,nfs_write_data,nfs_removeres,nfs4_closedata

This also reduces the reported stack usage of many nfs functions (30+).

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nfs_xdr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/nfs_xdr.h~nfs-remove-8-bytes-of-padding-from-struct-nfs_fattr-on-64-bit-builds include/linux/nfs_xdr.h
--- a/include/linux/nfs_xdr.h~nfs-remove-8-bytes-of-padding-from-struct-nfs_fattr-on-64-bit-builds
+++ a/include/linux/nfs_xdr.h
@@ -36,6 +36,7 @@ struct nfs_fattr {
 	__u32			nlink;
 	__u32			uid;
 	__u32			gid;
+	dev_t			rdev;
 	__u64			size;
 	union {
 		struct {
@@ -46,7 +47,6 @@ struct nfs_fattr {
 			__u64	used;
 		} nfs3;
 	} du;
-	dev_t			rdev;
 	struct nfs_fsid		fsid;
 	__u64			fileid;
 	struct timespec		atime;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

git-tip.patch
git-nfs.patch
libata-reorder-ata_device-to-remove-8-bytes-of-padding-on-64-bits.patch

