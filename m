From: akpm@linux-foundation.org
Subject: - include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:36:33 -0700
Message-ID: <200710162036.l9GKaXXe015191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965672AbXJPVeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     include/asm-m32r/thread_info.h: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/asm-m32r/thread_info.h: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m32r/thread_info.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN include/asm-m32r/thread_info.h~include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc include/asm-m32r/thread_info.h
--- a/include/asm-m32r/thread_info.h~include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc
+++ a/include/asm-m32r/thread_info.h
@@ -100,9 +100,8 @@ static inline struct thread_info *curren
 	({							\
 		struct thread_info *ret;			\
 	 							\
-	 	ret = kmalloc(THREAD_SIZE, GFP_KERNEL);		\
-	 	if (ret)					\
-	 		memset(ret, 0, THREAD_SIZE);		\
+	 	ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
+								\
 	 	ret;						\
 	 })
 #else
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
git-alsa.patch
git-cifs.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
add-a-rounddown_pow_of_two-routine-to-log2hpatch-fix.patch
kernel-forkc-remove-unneeded-variable-initialization-in-copy_process.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
