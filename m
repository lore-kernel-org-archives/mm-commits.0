From: akpm@linux-foundation.org
Subject: [merged] init-return-proper-error-code-in-do_mounts_rd.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:37 -0700
Message-ID: <201103232044.p2NKiDDV029053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933466Ab1CWUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@gnu.org, mm-commits@vger.kernel.org


The patch titled
     init: return proper error code in do_mounts_rd()
has been removed from the -mm tree.  Its filename was
     init-return-proper-error-code-in-do_mounts_rd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init: return proper error code in do_mounts_rd()
From: Davidlohr Bueso <dave@gnu.org>

In do_mounts_rd() if memory cannot be allocated, return -ENOMEM.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts_rd.c~init-return-proper-error-code-in-do_mounts_rd init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-return-proper-error-code-in-do_mounts_rd
+++ a/init/do_mounts_rd.c
@@ -64,7 +64,7 @@ identify_ramdisk_image(int fd, int start
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
-		return -1;
+		return -ENOMEM;
 
 	minixsb = (struct minix_super_block *) buf;
 	ext2sb = (struct ext2_super_block *) buf;
_

Patches currently in -mm which might be from dave@gnu.org are

origin.patch

