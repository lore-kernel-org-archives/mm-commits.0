From: akpm@linux-foundation.org
Subject: - sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:03 -0700
Message-ID: <200804300549.m3U5n3n8029943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378AbYD3GKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     sysv fs: remove superfluous check for __GNUC__ compiler
has been removed from the -mm tree.  Its filename was
     sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysv fs: remove superfluous check for __GNUC__ compiler
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Since <linux/sysv_fs.h> isn't exported to userspace, there is little
point checking that this is a GNU-compatible compiler.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysv_fs.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/sysv_fs.h~sysv-fs-remove-superfluous-check-for-__gnuc__-compiler include/linux/sysv_fs.h
--- a/include/linux/sysv_fs.h~sysv-fs-remove-superfluous-check-for-__gnuc__-compiler
+++ a/include/linux/sysv_fs.h
@@ -1,11 +1,7 @@
 #ifndef _LINUX_SYSV_FS_H
 #define _LINUX_SYSV_FS_H
 
-#if defined(__GNUC__)
-# define __packed2__	__attribute__((packed, aligned(2)))
-#else
->> I want to scream! <<
-#endif
+#define __packed2__	__attribute__((packed, aligned(2)))
 
 
 #ifndef __KERNEL__
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-dvb.patch
git-mtd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

