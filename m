From: akpm@linux-foundation.org
Subject: - fat-use-generic_file_llseek-for-directory.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:15 -0800
Message-ID: <200811102033.mAAKXFE3024373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754753AbYKJUdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: use generic_file_llseek() for directory
has been removed from the -mm tree.  Its filename was
     fat-use-generic_file_llseek-for-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: use generic_file_llseek() for directory
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Since fat_dir_ioctl() was already fixed (i.e. called under ->i_mutex),
and __fat_readdir() doesn't take BKL anymore. So, BKL for ->llseek()
is pointless, and we have to use generic_file_llseek().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/dir.c~fat-use-generic_file_llseek-for-directory fs/fat/dir.c
--- a/fs/fat/dir.c~fat-use-generic_file_llseek-for-directory
+++ a/fs/fat/dir.c
@@ -832,6 +832,7 @@ static long fat_compat_dir_ioctl(struct 
 #endif /* CONFIG_COMPAT */
 
 const struct file_operations fat_dir_operations = {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= fat_readdir,
 	.ioctl		= fat_dir_ioctl,
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

