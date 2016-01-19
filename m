From: akpm@linux-foundation.org
Subject: [merged] fs-statc-drop-the-last-new_valid_dev-check.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:35 -0800
Message-ID: <569e992b.qqw18gPdQNG/5TAK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/stat.c: drop the last new_valid_dev check
has been removed from the -mm tree.  Its filename was
     fs-statc-drop-the-last-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: fs/stat.c: drop the last new_valid_dev check

New_valid_dev() always returns true, so that's unnecessary to perform
new_valid_dev() checks in some filesystems.  Most checks of
new_valid_dev() have been removed so let's drop this last one and then we
can remove new_valid_dev() from the source code.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/stat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/stat.c~fs-statc-drop-the-last-new_valid_dev-check fs/stat.c
--- a/fs/stat.c~fs-statc-drop-the-last-new_valid_dev-check
+++ a/fs/stat.c
@@ -219,7 +219,7 @@ SYSCALL_DEFINE2(fstat, unsigned int, fd,
 #  define choose_32_64(a,b) b
 #endif
 
-#define valid_dev(x)  choose_32_64(old_valid_dev,new_valid_dev)(x)
+#define valid_dev(x)  choose_32_64(old_valid_dev(x),true)
 #define encode_dev(x) choose_32_64(old_encode_dev,new_encode_dev)(x)
 
 #ifndef INIT_STRUCT_STAT_PADDING
_

Patches currently in -mm which might be from baiyaowei@cmss.chinamobile.com are

init-mainc-obsolete_checksetup-can-be-boolean.patch
init-do_mounts-initrd_load-can-be-boolean.patch
ipc-shm-is_file_shm_hugepages-can-be-boolean.patch

