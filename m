From: akpm@linux-foundation.org
Subject: + bfs-fix-bitmap-size-argument-to-find_first_zero_bit.patch added to -mm tree
Date: Tue, 08 Mar 2011 16:36:53 -0800
Message-ID: <201103090036.p290ar4e004203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755451Ab1CIAg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2011 19:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, tigran@aivazian.fsnet.co.uk


The patch titled
     bfs: fix bitmap size argument to find_first_zero_bit()
has been added to the -mm tree.  Its filename is
     bfs-fix-bitmap-size-argument-to-find_first_zero_bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bfs: fix bitmap size argument to find_first_zero_bit()
From: Akinobu Mita <akinobu.mita@gmail.com>

The usage of find_first_zero_bit() in bfs_create() is wrong for two
reasons.

The bitmap size argument to find_first_zero_bit() is info->si_lasti but
the correct bitmap size is info->si_lasti + 1 as info->si_lasti is the
last valid index in info->si_imap bitmap.

Another problem is that it is impossible to detect that info->si_imap
bitmap is full because there is an off-by-one bug in the return value
check for find_first_zero_bit().  If no zero bits exist in info->si_imap,
find_first_zero_bit() returns info->si_lasti.  But the check can't catch
it due to the off-by-one.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/bfs/dir.c~bfs-fix-bitmap-size-argument-to-find_first_zero_bit fs/bfs/dir.c
--- a/fs/bfs/dir.c~bfs-fix-bitmap-size-argument-to-find_first_zero_bit
+++ a/fs/bfs/dir.c
@@ -97,7 +97,7 @@ static int bfs_create(struct inode *dir,
 	if (!inode)
 		return -ENOSPC;
 	mutex_lock(&info->bfs_lock);
-	ino = find_first_zero_bit(info->si_imap, info->si_lasti);
+	ino = find_first_zero_bit(info->si_imap, info->si_lasti + 1);
 	if (ino > info->si_lasti) {
 		mutex_unlock(&info->bfs_lock);
 		iput(inode);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
mm-debug-pagealloc-fix-kconfig-dependency-warning.patch
smp-move-smp-setup-functions-to-kernel-smpc.patch
bfs-fix-bitmap-size-argument-to-find_first_zero_bit.patch
kvm-stop-including-asm-generic-bitops-leh-directly.patch
rds-stop-including-asm-generic-bitops-leh-directly.patch
bitops-merge-little-and-big-endian-definisions-in-asm-generic-bitops-leh.patch
asm-generic-rename-generic-little-endian-bitops-functions.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types-convert-little-endian-bitops-macros-to-static-inline-functions.patch
powerpc-introduce-little-endian-bitops.patch
powerpc-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
s390-introduce-little-endian-bitops.patch
s390-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
arm-introduce-little-endian-bitops.patch
arm-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
m68k-introduce-little-endian-bitops.patch
m68k-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-config_generic_find_bit_le.patch
m68knommu-introduce-little-endian-bitops.patch
m68knommu-introduce-little-endian-bitops-convert-little-endian-bitops-macros-to-static-inline-functions.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
asm-generic-use-little-endian-bitops.patch
kvm-use-little-endian-bitops.patch
rds-use-little-endian-bitops.patch
ext3-use-little-endian-bitops.patch
ext4-use-little-endian-bitops.patch
ocfs2-use-little-endian-bitops.patch
nilfs2-use-little-endian-bitops.patch
reiserfs-use-little-endian-bitops.patch
udf-use-little-endian-bitops.patch
ufs-use-little-endian-bitops.patch
md-use-little-endian-bitops.patch
dm-use-little-endian-bitops.patch
bitops-remove-ext2-non-atomic-bitops-from-asm-bitopsh.patch
m68k-remove-inline-asm-from-minix_find_first_zero_bit.patch
bitops-remove-minix-bitops-from-asm-bitopsh.patch

