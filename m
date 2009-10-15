From: akpm@linux-foundation.org
Subject: + compat_ioctl-do-not-hold-bkl-in-handlers.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:03:13 -0700
Message-ID: <200910152303.n9FN3DOC016930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763140AbZJOXD4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:03:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, gregkh@suse.de


The patch titled
     compat_ioctl: do not hold BKL in handlers
has been added to the -mm tree.  Its filename is
     compat_ioctl-do-not-hold-bkl-in-handlers.patch

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
Subject: compat_ioctl: do not hold BKL in handlers
From: Arnd Bergmann <arnd@arndb.de>

We have always called ioctl conversion handlers under the big kernel lock,
although that is generally not necessary.  In particular it is not needed
for conversion of data structures and for calling sys_ioctl or
do_vfs_ioctl, which will get the BKL again if needed.

Handlers doing more than those two have been moved out, so we can kill off
the BKL from compat_sys_ioctl.  This may significantly improve latencies
with 32 bit applications, and it avoids a common scenario where a thread
acquires the BKL twice.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/compat_ioctl.c~compat_ioctl-do-not-hold-bkl-in-handlers fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-do-not-hold-bkl-in-handlers
+++ a/fs/compat_ioctl.c
@@ -2590,9 +2590,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 
  found_handler:
 	if (t->handler) {
-		lock_kernel();
 		error = t->handler(fd, cmd, arg, filp);
-		unlock_kernel();
 		goto out_fput;
 	}
 
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
compat_ioctl-remove-vt-specific-ioctl-handlers.patch
compat_ioctl-do-not-hold-bkl-in-handlers.patch

