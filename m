From: akpm@linux-foundation.org
Subject: [merged] inotify-fix-undefined-reference-to-anon_inode_getfd.patch removed from -mm tree
Date: Tue, 27 Apr 2010 11:01:38 -0400
Message-ID: <201004271803.o3RI3B1U010956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756604Ab0D0SIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Apr 2010 14:08:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk@arm.linux.org.uk, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, rmk+kernel@arm.linux.org.uk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inotify: fix "undefined reference to `anon_inode_getfd'"
has been removed from the -mm tree.  Its filename was
     inotify-fix-undefined-reference-to-anon_inode_getfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: inotify: fix "undefined reference to `anon_inode_getfd'"
From: Russell King <rmk@arm.linux.org.uk>

Fix:

fs/built-in.o: In function `sys_inotify_init1':
summary.c:(.text+0x347a4): undefined reference to `anon_inode_getfd'

found by kautobuild with arms bcmring_defconfig, which ends up with
INOTIFY_USER enabled (through the 'default y') but leaves ANON_INODES
unset.  However, inotify_user.c uses anon_inode_getfd().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/notify/inotify/Kconfig~inotify-fix-undefined-reference-to-anon_inode_getfd fs/notify/inotify/Kconfig
--- a/fs/notify/inotify/Kconfig~inotify-fix-undefined-reference-to-anon_inode_getfd
+++ a/fs/notify/inotify/Kconfig
@@ -1,6 +1,7 @@
 config INOTIFY_USER
 	bool "Inotify support for userspace"
 	select FSNOTIFY
+	select ANON_INODES
 	default y
 	---help---
 	  Say Y here to enable inotify support for userspace, including the
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

linux-next.patch
sched-prevent-compiler-from-optimising-sched_avg_update-loop.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch

