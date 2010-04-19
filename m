From: akpm@linux-foundation.org
Subject: + inotify-fix-undefined-reference-to-anon_inode_getfd.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:48:26 -0700
Message-ID: <201004192248.o3JMmQGH014307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab0DSWsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, rmk+kernel@arm.linux.org.uk, viro@zeniv.linux.org.uk


The patch titled
     inotify: fix "undefined reference to `anon_inode_getfd'"
has been added to the -mm tree.  Its filename is
     inotify-fix-undefined-reference-to-anon_inode_getfd.patch

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
inotify-fix-undefined-reference-to-anon_inode_getfd.patch
sched-prevent-compiler-from-optimising-sched_avg_update-loop.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch

