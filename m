From: akpm@linux-foundation.org
Subject: [merged] pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:13 -0800
Message-ID: <20120113203213.F15F21E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:52529 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab2AMUcO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:14 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so355515ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: levinsasha928@gmail.com, penberg@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: fail cleanly when root tries F_SETPIPE_SZ with big size
has been removed from the -mm tree.  Its filename was
     pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: switch to sizeof(*bufs) for 80-column niceness]
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
+	bufs = kcalloc(nr_pages, sizeof(*bufs), GFP_KERNEL | __GFP_NOWARN);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from levinsasha928@gmail.com are

origin.patch
linux-next.patch

