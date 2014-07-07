From: akpm@linux-foundation.org
Subject: [merged] autofs4-fix-false-positive-compile-error.patch removed
 from -mm tree
Date: Mon, 07 Jul 2014 11:11:16 -0700
Message-ID: <53bae2c4.UW3KQsXs4vJRB0UK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40899 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaGGSLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:17 -0400
Received: by mail-yh0-f74.google.com with SMTP id b6so657347yha.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix false positive compile error
has been removed from the -mm tree.  Its filename was
     autofs4-fix-false-positive-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


