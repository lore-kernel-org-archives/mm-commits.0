From: akpm@linux-foundation.org
Subject: - hfsplus-missing-o_largefile-check.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:09 -0700
Message-ID: <200810202036.m9KKa96L011308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbYJTUrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, did447@gmail.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfsplus: missing O_LARGEFILE check
has been removed from the -mm tree.  Its filename was
     hfsplus-missing-o_largefile-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hfsplus: missing O_LARGEFILE check
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

hfsplus: O_LARGEFILE checking is missing

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8490

Reported-by: didier <did447@gmail.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/hfsplus/inode.c~hfsplus-missing-o_largefile-check fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-missing-o_largefile-check
+++ a/fs/hfsplus/inode.c
@@ -254,6 +254,8 @@ static int hfsplus_file_open(struct inod
 {
 	if (HFSPLUS_IS_RSRC(inode))
 		inode = HFSPLUS_I(inode).rsrc_inode;
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+		return -EOVERFLOW;
 	atomic_inc(&HFSPLUS_I(inode).opencnt);
 	return 0;
 }
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
linux-next.patch
max3100-spi-uart-driver.patch
max3100-spi-uart-driver-fix.patch

