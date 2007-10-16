From: akpm@linux-foundation.org
Subject: - uml-remove-unneeded-if-from-hostfs.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:38:05 -0700
Message-ID: <200710162038.l9GKc5o4015413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42722 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763337AbXJPVH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove unneeded if from hostfs
has been removed from the -mm tree.  Its filename was
     uml-remove-unneeded-if-from-hostfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: remove unneeded if from hostfs
From: Jeff Dike <jdike@addtoit.com>

Get rid of an empty if statement which might look like a bug to a
casual reader.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hostfs/hostfs_user.c~uml-remove-unneeded-if-from-hostfs fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-remove-unneeded-if-from-hostfs
+++ a/fs/hostfs/hostfs_user.c
@@ -283,7 +283,7 @@ int set_attr(const char *file, struct ho
 		}
 	}
 
-	if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
+	/* Note: ctime is not handled */
 	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
bitops-introduce-lock-ops.patch
