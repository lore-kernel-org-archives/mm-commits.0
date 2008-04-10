From: akpm@linux-foundation.org
Subject: - nfsd-restore-fs_posix_acl-to-nfsd_v4-entry.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:39 -0700
Message-ID: <200804102001.m3AK1dmf014993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYDJULR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chuck.lever@oracle.com, mm-commits@vger.kernel.org


The patch titled
     NFSD: Restore FS_POSIX_ACL to NFSD_V4 entry
has been removed from the -mm tree.  Its filename was
     nfsd-restore-fs_posix_acl-to-nfsd_v4-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NFSD: Restore FS_POSIX_ACL to NFSD_V4 entry
From: Chuck Lever <chuck.lever@oracle.com>

A recent clean up to fs/Kconfig mistakenly removed a reverse dependency on
FS_POSIX_ACL from the NFSD_V4 entry, resulting in kernel build failures in
certain cases.

Restore the dependency.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/Kconfig~nfsd-restore-fs_posix_acl-to-nfsd_v4-entry fs/Kconfig
--- a/fs/Kconfig~nfsd-restore-fs_posix_acl-to-nfsd_v4-entry
+++ a/fs/Kconfig
@@ -1706,6 +1706,7 @@ config NFSD_V4
 	bool "NFS server support for NFS version 4 (EXPERIMENTAL)"
 	depends on NFSD && PROC_FS && EXPERIMENTAL
 	select NFSD_V3
+	select FS_POSIX_ACL
 	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support in your system's NFS server for
_

Patches currently in -mm which might be from chuck.lever@oracle.com are

origin.patch
git-nfsd.patch

