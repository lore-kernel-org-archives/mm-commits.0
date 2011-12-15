From: akpm@linux-foundation.org
Subject: + pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch added to -mm tree
Date: Thu, 15 Dec 2011 13:16:37 -0800
Message-ID: <20111215211638.2206420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49261 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab1LOVQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:16:40 -0500
Received: by eekc1 with SMTP id c1so75178eek.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:16:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: levinsasha928@gmail.com, penberg@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size
has been added to the -mm tree.  Its filename is
     pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch

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
From: Sasha Levin <levinsasha928@gmail.com>
Subject: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size

When a user with the CAP_SYS_RESOURCE cap tries to F_SETPIPE_SZ a pipe
with size bigger than kmalloc() can alloc it spits out an ugly warning:

[    3.651552] ------------[ cut here ]------------
[    3.652644] WARNING: at mm/page_alloc.c:2095 __alloc_pages_nodemask+0x5d3/0x7a0()
[    3.654313] Pid: 733, comm: a.out Not tainted 3.2.0-rc1+ #4
[    3.655568] Call Trace:
[    3.656207]  [<ffffffff810de163>] ? __alloc_pages_nodemask+0x5d3/0x7a0
[    3.657698]  [<ffffffff8107a575>] warn_slowpath_common+0x75/0xb0
[    3.659018]  [<ffffffff8107a675>] warn_slowpath_null+0x15/0x20
[    3.660468]  [<ffffffff810de163>] __alloc_pages_nodemask+0x5d3/0x7a0
[    3.665725]  [<ffffffff810f5432>] ? handle_pte_fault+0xf2/0x200
[    3.667032]  [<ffffffff8167b849>] ? _raw_spin_unlock+0x9/0x40
[    3.668283]  [<ffffffff810f2d76>] ? __pte_alloc+0x96/0x150
[    3.669354]  [<ffffffff81121121>] ? get_empty_filp+0x91/0x160
[    3.670238]  [<ffffffff810f6764>] ? handle_mm_fault+0x1a4/0x360
[    3.671139]  [<ffffffff810de342>] __get_free_pages+0x12/0x50
[    3.671972]  [<ffffffff811169fb>] __kmalloc+0x12b/0x150
[    3.672782]  [<ffffffff811283f5>] pipe_set_size+0x75/0x120
[    3.673681]  [<ffffffff81129998>] pipe_fcntl+0xf8/0x140
[    3.674833]  [<ffffffff81130264>] do_fcntl+0x2d4/0x410
[    3.675960]  [<ffffffff81129722>] ? do_pipe_flags+0xb2/0x100
[    3.677218]  [<ffffffff81130406>] sys_fcntl+0x66/0xa0
[    3.678037]  [<ffffffff8167c612>] system_call_fastpath+0x16/0x1b
[    3.679008] ---[ end trace 432f702e6db7b5ee ]---

Instead, make kcalloc() handle the overflow case and fail quietly.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/pipe.c~pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size fs/pipe.c
--- a/fs/pipe.c~pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size
+++ a/fs/pipe.c
@@ -1137,7 +1137,7 @@ static long pipe_set_size(struct pipe_in
 	if (nr_pages < pipe->nrbufs)
 		return -EBUSY;
 
-	bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL);
+	bufs = kcalloc(nr_pages, sizeof(struct pipe_buffer), GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
_
Subject: Subject: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size

Patches currently in -mm which might be from levinsasha928@gmail.com are

linux-next.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch

