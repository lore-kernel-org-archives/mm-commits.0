Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793416113;
	b=zJmX6Rz9a81WcQg/VwnUP8yN1zDOexnmwefSJuNgoONS3JyvS8rjnJVWPCwYOlkM4EBO
	 9+RbF1iRZaYV/zaIsqTTaw5yVxmSNa4/vwHa9lVTqykVBNFbWo5pxfYm+jVijbFlKLUHX
	 Vv9+/wM+Po35y2sOwto42G13IKGIYLBN4u+ZFxWWORTwzN3lkcVOoYE5TdjkYuLy+bPk6
	 5Wlts+PXq4zdsccsoZwcp3edXJKBjTRP6Hr7VJIdMvHyvoq1h/mybyBkF5wiJYWAN28jQ
	 Fi78vWif5tDt9CAQZ/v9ymGEXT0HArlqop16w7BWP0ANHU6mhLshTh/ytCOzbUR1+CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793416113;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=/uvhPevNkLzeCNg1txIgzaA4JruNqTaRb8Zh4h3jVic=;
	b=uR3PvUm0hhh8f3tIuhDYhThFR7D6i48MEC5627gSnXpCMQIzk84gz7jDLKeVLvziRV/2
	 zLBGrLfoC8owcrDcpHspkEOxwcj+gzF5+CpI2lq6YalQ4zpQAWHPXwuTGcau6WDctazUp
	 j4cATOczcN0N72tbNox16QnQaoG8an8ZgZzoJBQk9lPsaMpZUuTVtO1RHHG4cWyVHBEg5
	 3cAQPhQnIrjcAMzuIAG0OnJAbeQMrUDuTJcXKHJmM2iIrwGusVbJ8t4LsoLkjDoKfDykp
	 486sAgnzzR7XLiE2iPydvI7UzwlW/6DKHmx8dCclTGXgSHTP9RUddZ0NQowXunYW0vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IXFkIfs2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C33606A31C;
	Sat, 31 Oct 2026 03:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IXFkIfs2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A3A1F000C1;
	Sat, 31 Oct 2026 03:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793416112;
	bh=/uvhPevNkLzeCNg1txIgzaA4JruNqTaRb8Zh4h3jVic=;
	h=Date:To:From:Subject;
	b=IXFkIfs2ntLZH7oji24423rY1tEEzj3fPMPerbeDKZraMQgDbLZRAt6N7Jl9f0eeY
	 u2BTxXQ/o9p4uSMM+i3LJVkWdASgw3UZbPk6AG3RpnX4NU5GN2MNl8Ezyl7Z0XtwjE
	 4/mYTXsKdFuaQGc3DjGNxDbxSdMsMUS+qkL4FJTw=
Date: Fri, 30 Oct 2026 20:08:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,
	manfred@colorfullife.com,dave@stgolabs.net,1075151112@qq.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-mqueue-reject-negative-queues_max-values.patch added to mm-nonmm-unstable branch
Message-Id: <20261031030832.65A3A1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ipc: mqueue: reject negative queues_max values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-mqueue-reject-negative-queues_max-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-mqueue-reject-negative-queues_max-values.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yingjie Wang <1075151112@qq.com>
Subject: ipc: mqueue: reject negative queues_max values
Date: Wed, 26 Aug 2026 14:10:40 +0800

fs.mqueue.queues_max is documented as the maximum number of POSIX message
queues.  Its sysctl entry uses proc_dointvec, but its backing field,
ipc_namespace::mq_queues_max, is unsigned int.

Consequently, writing -1 is accepted and reads back as -1, while the
stored bit pattern is UINT_MAX.  The admission check in do_mq_open() then
permits an effectively unbounded number of queues for callers without
CAP_SYS_RESOURCE, rather than enforcing the configured maximum.

Use proc_dointvec_minmax with a zero lower bound.  This rejects negative
input while retaining the previously accepted nonnegative signed-int
range, including zero.

The issue was reproduced on 6.12.80 and 6.12.105.  With queues_max=1, an
unprivileged workload could create one of three requested queues and the
rest failed with ENOSPC.  With queues_max=-1, all three creations
succeeded.  After this change, writing -1 fails with EINVAL, and the
finite and zero-value controls retain their prior behavior.

Link: https://lore.kernel.org/tencent_0D48FFD2E604EA5FED532748CCAAD5139905@qq.com
Fixes: bdc8e5f85f9a ("namespaces: mqueue namespace: adapt sysctl")
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
---

 ipc/mq_sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/ipc/mq_sysctl.c~ipc-mqueue-reject-negative-queues_max-values
+++ a/ipc/mq_sysctl.c
@@ -26,7 +26,8 @@ static const struct ctl_table mq_sysctls
 		.data		= &init_ipc_ns.mq_queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
 	},
 	{
 		.procname	= "msg_max",
_

Patches currently in -mm which might be from 1075151112@qq.com are

ipc-mqueue-reject-negative-queues_max-values.patch

