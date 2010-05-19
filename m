From: akpm@linux-foundation.org
Subject: [merged] fs-writebackc-bitfields-should-be-unsigned.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:40 -0400
Message-ID: <201005191733.o4JHX6xQ025791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753807Ab0ESRdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, hsweeten@visionengravers.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs-writeback.c: bitfields should be unsigned
has been removed from the -mm tree.  Its filename was
     fs-writebackc-bitfields-should-be-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-writeback.c: bitfields should be unsigned
From: H Hartley Sweeten <hartleys@visionengravers.com>

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/fs-writeback.c~fs-writebackc-bitfields-should-be-unsigned fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-writebackc-bitfields-should-be-unsigned
+++ a/fs/fs-writeback.c
@@ -42,9 +42,9 @@ struct wb_writeback_args {
 	long nr_pages;
 	struct super_block *sb;
 	enum writeback_sync_modes sync_mode;
-	int for_kupdate:1;
-	int range_cyclic:1;
-	int for_background:1;
+	unsigned int for_kupdate:1;
+	unsigned int range_cyclic:1;
+	unsigned int for_background:1;
 };
 
 /*
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch
rtc-isl1208-use-sysfs_create-remove_group.patch

