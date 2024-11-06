Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368B21865EA;
	Wed,  6 Nov 2024 01:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855632; cv=none; b=JpRx6sQgMD1ZjxdNMnLZOvTNAHFHJMXDCldkFov4oMLmL3d/mhzctY5shtl351xzO71FKPT0EoqoenO3zPJrtE4sB3CtFtrqZsOlNFZ+EQsFrsu/IFIj79w8uWhe5DAhnUSRSWrlflo03TWr8U20urTW7ET/qOy4DG9nOU73618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855632; c=relaxed/simple;
	bh=/MMoDEzuAYbS9Kqzg8bMd6grxDEF23J2Z+gD9DHw6X4=;
	h=Date:To:From:Subject:Message-Id; b=oIFwAWKw8D/yh92vn1/hWYy7Z2kBo46SW/7NQc4W7nyJxjkmvQYPWxg5pl0xHZzHpNvPI04/A1ZoTgBUlTFtYn/AMcE8OUJawQKeNJrlzD+taB6PzYcfDhIWZm+LMDfEbaUeWRZ8mXLKsudpiRNCjLeeyWx3OWVGyRzJg0vnZTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2nts/Rb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2nts/Rb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F401BC4CECF;
	Wed,  6 Nov 2024 01:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855632;
	bh=/MMoDEzuAYbS9Kqzg8bMd6grxDEF23J2Z+gD9DHw6X4=;
	h=Date:To:From:Subject:From;
	b=2nts/Rb0/b5Fi7TL9uJ6ByydNoW2K3hePGQDuJMy6RqnzVkU0j/fjO739BNruQN3H
	 DwQqTWhsLUYbTo3UplFy0PSW7o6Kp/WhSLdJ7GejfYU59bQ1KbkYSOJrCIcFXBytVY
	 yw4O+/+LzQPsOghY1D3zEVqlkF+hb70TEKbtzibQ=
Date: Tue, 05 Nov 2024 17:13:51 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mawupeng1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch removed from -mm tree
Message-Id: <20241106011351.F401BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc: fix memleak if msg_init_ns failed in create_ipc_ns
has been removed from the -mm tree.  Its filename was
     ipc-fix-memleak-if-msg_init_ns-failed-in-create_ipc_ns.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wupeng Ma <mawupeng1@huawei.com>
Subject: ipc: fix memleak if msg_init_ns failed in create_ipc_ns
Date: Wed, 23 Oct 2024 17:31:29 +0800

From: Ma Wupeng <mawupeng1@huawei.com>

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


