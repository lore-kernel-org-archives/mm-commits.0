From: akpm@osdl.org
Subject: + add-afs_super_magic-to-magich.patch added to -mm tree
Date: Fri, 29 Dec 2006 16:51:25 -0800
Message-ID: <200612300051.kBU0pQnD008289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbWL3Avs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Dec 2006 19:51:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: megacz@cs.berkeley.edu, jaltman@secure-endpoints.com


The patch titled
     Add AFS_SUPER_MAGIC to magic.h
has been added to the -mm tree.  Its filename is
     add-afs_super_magic-to-magich.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

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

add-afs_super_magic-to-magich.patch

