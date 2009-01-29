From: akpm@linux-foundation.org
Subject: + nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:15:54 -0800
Message-ID: <200901290815.n0T8FsfV001105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbZA2IQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkatiyar@gmail.com, bfields@fieldses.org, chuck.lever@oracle.com, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     nfs: nfs and nfsd should depend upon CONFIG_FILE_LOCKING
has been added to the -mm tree.  Its filename is
     nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch

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

nfs-nfs-and-nfsd-should-depend-upon-config_file_locking.patch

