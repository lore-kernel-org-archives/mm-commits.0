From: akpm@linux-foundation.org
Subject: [wrecked] nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:35:05 -0800
Message-ID: <200902021935.n12JZ6J4011034@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbZBBTf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkatiyar@gmail.com, bfields@fieldses.org, chuck.lever@oracle.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: nfs and nfsd should depend upon CONFIG_FILE_LOCKING
has been removed from the -mm tree.  Its filename was
     nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: nfs and nfsd should depend upon CONFIG_FILE_LOCKING
From: Manish Katiyar <mkatiyar@gmail.com>

fs/nfsd/nfs4state.c:1657: warning: unused variable 'flp'

Bruce said "I don't believe we want to support a .config with NFS or NFSD
turned on but CONFIG_FILE_LOCKING off".  No reason was given.

Enable NFS_FS and NFSD only when FILE_LOCKING is enabled.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/Kconfig~nfs-nfs-and-nfsd-should-depend-upon-config_file_locking fs/Kconfig
--- a/fs/Kconfig~nfs-nfs-and-nfsd-should-depend-upon-config_file_locking
+++ a/fs/Kconfig
@@ -253,6 +253,7 @@ if NETWORK_FILESYSTEMS
 config NFS_FS
 	tristate "NFS client support"
 	depends on INET
+	depends on FILE_LOCKING
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
@@ -349,6 +350,7 @@ config NFS_FSCACHE
 config NFSD
 	tristate "NFS server support"
 	depends on INET
+	depends on FILE_LOCKING
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
_

Patches currently in -mm which might be from mkatiyar@gmail.com are

origin.patch
rtc-ds1390-fix-compilation-warnings-in-drivers-rtc-rtc-ds1390c.patch
linux-next.patch
nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch

