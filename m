From: akpm@linux-foundation.org
Subject: + vmsplice-relax-alignement-requirements-for-splice_f_gift.patch added to -mm tree
Date: Thu, 19 Apr 2012 13:07:15 -0700
Message-ID: <20120419200715.CB9EDA055E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61015 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2DSUHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Apr 2012 16:07:17 -0400
Received: by yhgm50 with SMTP id m50so1020450yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 19 Apr 2012 13:07:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, axboe@kernel.dk, davem@davemloft.net, hughd@google.com, mszeredi@suse.cz, therbert@google.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, xiaosuo@gmail.com


The patch titled
     Subject: vmsplice: relax alignement requirements for SPLICE_F_GIFT
has been added to the -mm tree.  Its filename is
     vmsplice-relax-alignement-requirements-for-splice_f_gift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: vmsplice: relax alignement requirements for SPLICE_F_GIFT

It seems there is no fundamental reason to limit vmsplice() SPLICE_F_GIFT
to page aligned chunks.

All helpers are prepared to cope with offsets in page.

This limitation makes vmsplice() API very impractical in the zero-copy
land.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Changli Gao <xiaosuo@gmail.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/splice.c~vmsplice-relax-alignement-requirements-for-splice_f_gift fs/splice.c
--- a/fs/splice.c~vmsplice-relax-alignement-requirements-for-splice_f_gift
+++ a/fs/splice.c
@@ -1388,7 +1388,7 @@ static long do_splice(struct file *in, l
  */
 static int get_iovec_page_array(const struct iovec __user *iov,
 				unsigned int nr_vecs, struct page **pages,
-				struct partial_page *partial, int aligned,
+				struct partial_page *partial, bool aligned,
 				unsigned int pipe_buffers)
 {
 	int buffers = 0, error = 0;
@@ -1626,7 +1626,7 @@ static long vmsplice_to_pipe(struct file
 		return -ENOMEM;
 
 	spd.nr_pages = get_iovec_page_array(iov, nr_segs, spd.pages,
-					    spd.partial, flags & SPLICE_F_GIFT,
+					    spd.partial, false,
 					    pipe->buffers);
 	if (spd.nr_pages <= 0)
 		ret = spd.nr_pages;
_
Subject: Subject: vmsplice: relax alignement requirements for SPLICE_F_GIFT

Patches currently in -mm which might be from eric.dumazet@gmail.com are

linux-next.patch
net-use-this_cpu_xxx-replace-percpu_xxx-funcs.patch
vmsplice-relax-alignement-requirements-for-splice_f_gift.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

