From: akpm@linux-foundation.org
Subject: [withdrawn] fs-pipec-implement-minimum-pipe-size-for-arg==0.patch removed from -mm tree
Date: Thu, 28 Sep 2017 15:31:56 -0700
Message-ID: <59cd785c.f8ZoB22c8LbvHxHQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55160 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbdI1Wb5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Sep 2017 18:31:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mtk.manpages@gmail.com, sp3485@columbia.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/pipe.c: implement minimum pipe size for arg==0
has been removed from the -mm tree.  Its filename was
     fs-pipec-implement-minimum-pipe-size-for-arg==0.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs/pipe.c: implement minimum pipe size for arg==0

Shankara reports that running Syskaller with UBSAN causes this message:
  UBSAN: Undefined behaviour in ./include/linux/log2.h:57:13

Syzkaller is trying to set the pipe size to 0UL. The call chain is:
	pipe_set_size(pipe, 0UL)
	...
	size = round_pipe_size(arg); // arg == 0UL
which does
	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT; // = 0UL
	return roundup_pow_of_two(nr_pages) << PAGE_SHIFT;
which is undefined when the argument is 0... and which calls
	fls_long(-1) // == 64
and then returns 1UL << 64. This is where UBSAN kicks in.

The fcntl() man page [http://man7.org/linux/man-pages/man2/fcntl.2.html]
says that:
	Attempts to set the pipe capacity below the page size are
	silently rounded up to the page size.

We could try to fix the basic low-level functions to handle 0 (where
<linux/log2.h> says the result is undefined when n == 0), but the safest
path for now is probably just to patch fs/pipe.c to make the documented
default happen when arg is 0.

Link: http://lkml.kernel.org/r/b1c6b6fa-1917-da84-f1f4-0fafd6cac732@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Shankara Pailoor <sp3485@columbia.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/pipe.c~fs-pipec-implement-minimum-pipe-size-for-arg==0 fs/pipe.c
--- a/fs/pipe.c~fs-pipec-implement-minimum-pipe-size-for-arg==0
+++ a/fs/pipe.c
@@ -1038,6 +1038,8 @@ static long pipe_set_size(struct pipe_in
 	unsigned long user_bufs;
 	long ret = 0;
 
+	if (!arg)
+		arg = PAGE_SIZE;
 	size = round_pipe_size(arg);
 	nr_pages = size >> PAGE_SHIFT;
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are


