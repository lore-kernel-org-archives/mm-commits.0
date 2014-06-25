From: akpm@linux-foundation.org
Subject: + autofs4-fix-false-positive-compile-error.patch added to -mm
 tree
Date: Wed, 25 Jun 2014 13:07:05 -0700
Message-ID: <53ab2be9.OtvMMnsdCq7z1QPD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaFYUHG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jun 2014 16:07:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix false positive compile error
has been added to the -mm tree.  Its filename is
     autofs4-fix-false-positive-compile-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-fix-false-positive-compile-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-fix-false-positive-compile-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix false positive compile error

On strict build environments we can see:

fs/autofs4/inode.c: In function 'autofs4_fill_super':
fs/autofs4/inode.c:312: error: 'pgrp' may be used uninitialized in this
function
make[2]: *** [fs/autofs4/inode.o] Error 1
make[1]: *** [fs/autofs4] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....

This is due to the use of pgrp_set being used to indicate pgrp has
has been set rather than initializing pgrp itself.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/inode.c~autofs4-fix-false-positive-compile-error fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-fix-false-positive-compile-error
+++ a/fs/autofs4/inode.c
@@ -210,7 +210,7 @@ int autofs4_fill_super(struct super_bloc
 	int pipefd;
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
-	int pgrp;
+	int pgrp = 0;
 	bool pgrp_set = false;
 	int ret = -EINVAL;
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-fix-false-positive-compile-error.patch
proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch

