From: akpm@linux-foundation.org
Subject: - uml-use-correct-type-in-blkgetsize-ioctl.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:14 -0700
Message-ID: <200709202115.l8KLFEJt002889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbXITVQK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:16:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.george@ens.fr, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: use correct type in BLKGETSIZE ioctl
has been removed from the -mm tree.  Its filename was
     uml-use-correct-type-in-blkgetsize-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: use correct type in BLKGETSIZE ioctl
From: Nicolas George <nicolas.george@ens.fr>

I found a type mismatch in UML that makes host block devices unusable as ubd
devices on x86_64 and other 64 bits systems (segfault of the mm subsystem):

In block/ioctl.c, the following lines show that the BLKGETSIZE ioctl expects
a pointer to a long:

	case BLKGETSIZE:
		if ((bdev->bd_inode->i_size >> 9) > ~0UL)
			return -EFBIG;
		return put_ulong(arg, bdev->bd_inode->i_size >> 9);

In arch/um/os-Linux/file.c, os_file_size calls it with an int.

The ioctl_list man page should be fixed as well.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/file.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/um/os-Linux/file.c~uml-use-correct-type-in-blkgetsize-ioctl arch/um/os-Linux/file.c
--- a/arch/um/os-Linux/file.c~uml-use-correct-type-in-blkgetsize-ioctl
+++ a/arch/um/os-Linux/file.c
@@ -320,7 +320,8 @@ int os_file_size(char *file, unsigned lo
 	}
 
 	if(S_ISBLK(buf.ust_mode)){
-		int fd, blocks;
+		int fd;
+		long blocks;
 
 		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
 		if(fd < 0){
_

Patches currently in -mm which might be from nicolas.george@ens.fr are
