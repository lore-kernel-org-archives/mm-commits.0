From: akpm@linux-foundation.org
Subject: + do_pipe-drop-its-last-user-in-arch-alpha.patch added to -mm tree
Date: Mon, 02 Feb 2009 12:45:28 -0800
Message-ID: <200902022045.n12KjSs3008296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316AbZBBUpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 15:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, ink@jurassic.park.msu.ru, jens.axboe@oracle.com, rth@twiddle.net, viro@zeniv.linux.org.uk


The patch titled
     do_pipe(): drop its last user in arch/alpha/
has been added to the -mm tree.  Its filename is
     do_pipe-drop-its-last-user-in-arch-alpha.patch

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
Subject: do_pipe(): drop its last user in arch/alpha/
From: Cheng Renquan <crquan@gmail.com>

The last user of do_pipe is in arch/alpha/, after replacing it with
do_pipe_flags, the do_pipe can be removed.

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Acked-by: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/entry.S   |    3 ++-
 arch/alpha/kernel/osf_sys.c |    2 +-
 fs/pipe.c                   |    5 -----
 include/linux/fs.h          |    1 -
 4 files changed, 3 insertions(+), 8 deletions(-)

diff -puN arch/alpha/kernel/entry.S~do_pipe-drop-its-last-user-in-arch-alpha arch/alpha/kernel/entry.S
--- a/arch/alpha/kernel/entry.S~do_pipe-drop-its-last-user-in-arch-alpha
+++ a/arch/alpha/kernel/entry.S
@@ -903,8 +903,9 @@ sys_alpha_pipe:
 	stq	$26, 0($sp)
 	.prologue 0
 
+	mov	$31, $17
 	lda	$16, 8($sp)
-	jsr	$26, do_pipe
+	jsr	$26, do_pipe_flags
 
 	ldq	$26, 0($sp)
 	bne	$0, 1f
diff -puN arch/alpha/kernel/osf_sys.c~do_pipe-drop-its-last-user-in-arch-alpha arch/alpha/kernel/osf_sys.c
--- a/arch/alpha/kernel/osf_sys.c~do_pipe-drop-its-last-user-in-arch-alpha
+++ a/arch/alpha/kernel/osf_sys.c
@@ -46,7 +46,7 @@
 #include <asm/hwrpb.h>
 #include <asm/processor.h>
 
-extern int do_pipe(int *);
+extern int do_pipe_flags(int *, int);
 
 /*
  * Brk needs to return an error.  Still support Linux's brk(0) query idiom,
diff -puN fs/pipe.c~do_pipe-drop-its-last-user-in-arch-alpha fs/pipe.c
--- a/fs/pipe.c~do_pipe-drop-its-last-user-in-arch-alpha
+++ a/fs/pipe.c
@@ -1035,11 +1035,6 @@ int do_pipe_flags(int *fd, int flags)
 	return error;
 }
 
-int do_pipe(int *fd)
-{
-	return do_pipe_flags(fd, 0);
-}
