From: akpm@linux-foundation.org
Subject: [merged] fs-coda-fix-readlink-buffer-overflow.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:12:33 -0700
Message-ID: <55f31991.Cbrjv6itCkqebbyo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSMd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/coda: fix readlink buffer overflow
has been removed from the -mm tree.  Its filename was
     fs-coda-fix-readlink-buffer-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Harkes <jaharkes@cs.cmu.edu>
Subject: fs/coda: fix readlink buffer overflow

Dan Carpenter discovered a buffer overflow in the Coda file system
readlink code.  A userspace file system daemon can return a 4096 byte
result which then triggers a one byte write past the allocated readlink
result buffer.

This does not trigger with an unmodified Coda implementation because Coda
has a 1024 byte limit for symbolic links, however other userspace file
systems using the Coda kernel module could be affected.

Although this is an obvious overflow, I don't think this has to be handled
as too sensitive from a security perspective because the overflow is on
the Coda userspace daemon side which already needs root to open Coda's
kernel device and to mount the file system before we get to the point that
links can be read.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow fs/coda/upcall.c
--- a/fs/coda/upcall.c~fs-coda-fix-readlink-buffer-overflow
+++ a/fs/coda/upcall.c
@@ -353,7 +353,7 @@ int venus_readlink(struct super_block *s
         char *result;
         
 	insize = max_t(unsigned int,
-		     INSIZE(readlink), OUTSIZE(readlink)+ *length + 1);
+		     INSIZE(readlink), OUTSIZE(readlink)+ *length);
 	UPARG(CODA_READLINK);
 
         inp->coda_readlink.VFid = *fid;
@@ -361,8 +361,8 @@ int venus_readlink(struct super_block *s
 	error = coda_upcall(coda_vcp(sb), insize, &outsize, inp);
 	if (!error) {
 		retlen = outp->coda_readlink.count;
-		if ( retlen > *length )
-			retlen = *length;
+		if (retlen >= *length)
+			retlen = *length - 1;
 		*length = retlen;
 		result =  (char *)outp + (long)outp->coda_readlink.data;
 		memcpy(buffer, result, retlen);
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are


