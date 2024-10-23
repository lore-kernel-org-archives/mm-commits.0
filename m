Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F1478C9C;
	Wed, 23 Oct 2024 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729726308; cv=none; b=Sx2XqPvwHY6X1+RFILXg3b2FR1LFXm5gC8Dm79EP0aSd9MzTHbAkFu/ZpZuMRMgYNKIdG8kh3YrOvDNGtFiOfIIfePX7deODdKmpuU3tSnmnGX0SFanIUwCGeC59mjG3aPmOTKJMnnBRH1UrL2wYlSwZGpEFiHO9ykZ+DEmKKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729726308; c=relaxed/simple;
	bh=YbWYuKtDd+ETf6Zk2BpyeVmCMzdsoDkdQkPr92Yy/yU=;
	h=Date:To:From:Subject:Message-Id; b=ejaqRKRXcDXPsDAwvZtsZq0N14T1fVCOW6IEyAwrAba0S/QBDWQZvsHXXw/SoeO1PxVQchALz7SDGbcR4S0jhGiwE1oBQV6ZB5TqH+XKu3jkHP92tRE8j8HXQSCGPz04QMZI4NaPYgiIVGwYzDMont6p3j3n0azIaOpLoxxQn4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ysLAswPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ysLAswPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1964EC4CEC6;
	Wed, 23 Oct 2024 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729726308;
	bh=YbWYuKtDd+ETf6Zk2BpyeVmCMzdsoDkdQkPr92Yy/yU=;
	h=Date:To:From:Subject:From;
	b=ysLAswPSFkv6+kdOiAIISSR6hfJwH9w7zHBorK5r/H2pu1/8ShTUGPp2DufxqhvAY
	 Xnqpsubz5+n1tMGQcxpu+jAihOmC1JUw0GsY3pGlRipxhf7oTkuiDIe3bpJISTmakX
	 1znirve9s46A9CW/4EyegfWCmC46UtbyrPEhgbz8=
Date: Wed, 23 Oct 2024 16:31:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch added to mm-nonmm-unstable branch
Message-Id: <20241023233148.1964EC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ipc: fix memleak if msg_init_ns failed in create_ipc_ns
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wupeng Ma <mawupeng1@huawei.com>
Subject: ipc: fix memleak if msg_init_ns failed in create_ipc_ns
Date: Wed, 23 Oct 2024 17:31:29 +0800


Percpu memory allocation may failed during create_ipc_ns however this
fail is not handled properly since ipc sysctls and mq sysctls is not
released properly. Fix this by release these two resource when failure.

Here is the kmemleak stack when percpu failed:

unreferenced object 0xffff88819de2a600 (size 512):
  comm "shmem_2nstest", pid 120711, jiffies 4300542254
  hex dump (first 32 bytes):
    60 aa 9d 84 ff ff ff ff fc 18 48 b2 84 88 ff ff  `.........H.....
    04 00 00 00 a4 01 00 00 20 e4 56 81 ff ff ff ff  ........ .V.....
  backtrace (crc be7cba35):
    [<ffffffff81b43f83>] __kmalloc_node_track_caller_noprof+0x333/0x420
    [<ffffffff81a52e56>] kmemdup_noprof+0x26/0x50
    [<ffffffff821b2f37>] setup_mq_sysctls+0x57/0x1d0
    [<ffffffff821b29cc>] copy_ipcs+0x29c/0x3b0
    [<ffffffff815d6a10>] create_new_namespaces+0x1d0/0x920
    [<ffffffff815d7449>] copy_namespaces+0x2e9/0x3e0
    [<ffffffff815458f3>] copy_process+0x29f3/0x7ff0
    [<ffffffff8154b080>] kernel_clone+0xc0/0x650
    [<ffffffff8154b6b1>] __do_sys_clone+0xa1/0xe0
    [<ffffffff843df8ff>] do_syscall_64+0xbf/0x1c0
    [<ffffffff846000b0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

Link: https://lkml.kernel.org/r/20241023093129.3074301-1-mawupeng1@huawei.com
Fixes: 72d1e611082e ("ipc/msg: mitigate the lock contention with percpu counter")
Signed-off-by: Ma Wupeng <mawupeng1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/namespace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/ipc/namespace.c~ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns
+++ a/ipc/namespace.c
@@ -83,13 +83,15 @@ static struct ipc_namespace *create_ipc_
 
 	err = msg_init_ns(ns);
 	if (err)
-		goto fail_put;
+		goto fail_ipc;
 
 	sem_init_ns(ns);
 	shm_init_ns(ns);
 
 	return ns;
 
+fail_ipc:
+	retire_ipc_sysctls(ns);
 fail_mq:
 	retire_mq_sysctls(ns);
 
_

Patches currently in -mm which might be from mawupeng1@huawei.com are

ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch

