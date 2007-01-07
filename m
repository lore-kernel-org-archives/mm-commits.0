From: akpm@osdl.org
Subject: - add-afs_super_magic-to-magich.patch removed from -mm tree
Date: Sat, 06 Jan 2007 23:57:54 -0800
Message-ID: <200701070757.l077vsfo012918@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40690 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbXAGH6D (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 02:58:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: megacz@cs.berkeley.edu, jaltman@secure-endpoints.com, mm-commits@vger.kernel.org


The patch titled
     Add AFS_SUPER_MAGIC to magic.h
has been removed from the -mm tree.  Its filename was
     add-afs_super_magic-to-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add AFS_SUPER_MAGIC to magic.h
From: Adam Megacz <megacz@cs.berkeley.edu>

Jeffrey Altman, one of the gatekeepers of OpenAFS (the open source project
which inherited the Transarc/IBM AFS codebase) has requested that the magic
number 0x5346414F (little endian 'OAFS') be allocated for the f_type field
of the fsinfo structure on Linux:

  https://lists.openafs.org/pipermail/openafs-info/2006-December/024829.html

Add it to include/linux/magic.h, mostly as a way of publishing this number
and ensuring that no other filesystem accidentally uses it.

Cc: Jeffrey Altman <jaltman@secure-endpoints.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/magic.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/magic.h~add-afs_super_magic-to-magich include/linux/magic.h
--- a/include/linux/magic.h~add-afs_super_magic-to-magich
+++ a/include/linux/magic.h
@@ -3,6 +3,7 @@
 
 #define ADFS_SUPER_MAGIC	0xadf5
 #define AFFS_SUPER_MAGIC	0xadff
+#define AFS_SUPER_MAGIC                0x5346414F
 #define AUTOFS_SUPER_MAGIC	0x0187
 #define CODA_SUPER_MAGIC	0x73757245
 #define EFS_SUPER_MAGIC		0x414A53
_

Patches currently in -mm which might be from megacz@cs.berkeley.edu are
