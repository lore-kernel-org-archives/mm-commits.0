From: akpm@linux-foundation.org
Subject: + nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:14:15 -0700
Message-ID: <200704280014.l3S0EFtp011301@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757950AbXD1AOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:14:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, ffilz@us.ibm.com, trond.myklebust@fys.uio.no


The patch titled
     NFS: suppress warnings about NFS4ERR_OLD_STATEID in nfs4_handle_exception
has been added to the -mm tree.  Its filename is
     nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: suppress warnings about NFS4ERR_OLD_STATEID in nfs4_handle_exception
From: Jeff Layton <jlayton@redhat.com>

In certain situations, a NFSv4 client can end up with a set of racing calls
that cause the server to return a NFS4ERR_OLD_STATEID error.  When this
occurs, the only real recourse that the client has is to retry the call. 
In the current code, when this occurs, it triggers a useless printk (in
nfs4_map_errors):

    nfs4_map_errors could not handle NFSv4 error 10024

Trond recently mentioned that we really don't need to worry users with that
info.  The following patch is based on a suggestion by Frank Filz and
supresses this error.  Changing the return code here to 0 should be safe
since all callers of nfs4_handle_exception are expected to retry the call
in this situation anyway.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Frank Filz <ffilz@us.ibm.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/nfs4proc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/nfs/nfs4proc.c~nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception fs/nfs/nfs4proc.c
--- a/fs/nfs/nfs4proc.c~nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception
+++ a/fs/nfs/nfs4proc.c
@@ -2774,6 +2774,7 @@ int nfs4_handle_exception(const struct n
 				break;
 		case -NFS4ERR_OLD_STATEID:
 			exception->retry = 1;
+			ret = 0;
 	}
 	/* We failed to handle the error */
 	return nfs4_map_errors(ret);
_

Patches currently in -mm which might be from jlayton@redhat.com are

nfs-suppress-warnings-about-nfs4err_old_stateid-in-nfs4_handle_exception.patch
make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits-comments.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
