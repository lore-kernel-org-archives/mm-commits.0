From: akpm@linux-foundation.org
Subject: + nfsd-restore-fs_posix_acl-to-nfsd_v4-entry.patch added to -mm tree
Date: Thu, 10 Apr 2008 12:03:19 -0700
Message-ID: <200804101903.m3AJ3JYq012715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbYDJTDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 15:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chuck.lever@oracle.com


The patch titled
     NFSD: Restore FS_POSIX_ACL to NFSD_V4 entry
has been added to the -mm tree.  Its filename is
     nfsd-restore-fs_posix_acl-to-nfsd_v4-entry.patch

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

git-nfsd.patch
nfsd-restore-fs_posix_acl-to-nfsd_v4-entry.patch

