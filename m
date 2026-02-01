Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388893EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905038; cv=none; b=LT6gq5kPRzwnEgSSwMqnKJdNsSVFbIda9LRAXrkJIuUxDIizJy8i7T/kH+GxAxzLFN0Ut/qxEEstN3bs2gpfLm4qLOq17NeDitUT2XVUS/QsINpHIMeJG0GZK7pxo8HQqvDMOYT3byRUKj/HDC9mGEsOhUN/wSgdJmU8Lhp1meg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905038; c=relaxed/simple;
	bh=TPT5xbdGCZuv9Jqk207xKXtESxL2LxIAFTSCVgAzTcE=;
	h=Date:To:From:Subject:Message-Id; b=HLeJQFvTzAHs9yC7JHs7SzznopMqUCeiK9V5xdMppcM7k4woUMkV23TQFsiWseUF2FpmUL+7VdDIVlY8tGWg/un259QkKd7XpT3K2i9TotMHftDYoBbVl/hfZA2ffsntz0HUDheP5/4aHKjZg2SqM+VzFU1IdnjflDY524TpSXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXuyhlVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXuyhlVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B54C4CEF1;
	Sun,  1 Feb 2026 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905038;
	bh=TPT5xbdGCZuv9Jqk207xKXtESxL2LxIAFTSCVgAzTcE=;
	h=Date:To:From:Subject:From;
	b=lXuyhlVVacOJL+ml3hxXzVEB2Kvg7r4r5VhjoUzRYW6CSkXT+VoaCWvA9j1WivqPN
	 KJmvAkpP1oDmIAg2h0t9VbPqhOp5bGPr8Et1cqmBpBzPE3+7CBac08kgUp2nlOE+85
	 WDZkW2uNAVsLGqlRKCsqNUiozfhgrk1XYOrHZmE4=
Date: Sat, 31 Jan 2026 16:17:17 -0800
To: mm-commits@vger.kernel.org,steven.price@arm.com,pabeni@redhat.com,leon@kernel.org,kuba@kernel.org,horms@kernel.org,felix.kuehling@amd.com,edumazet@google.com,davem@davemloft.net,christian.koenig@amd.com,boris.brezillon@collabora.com,aliceryhl@google.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rdma-umem-dont-abuse-current-group_leader.patch removed from -mm tree
Message-Id: <20260201001718.07B54C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: RDMA/umem: don't abuse current->group_leader
has been removed from the -mm tree.  Its filename was
     rdma-umem-dont-abuse-current-group_leader.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: RDMA/umem: don't abuse current->group_leader
Date: Sun, 25 Jan 2026 17:07:52 +0100

Cleanup and preparation to simplify the next changes.

Use current->tgid instead of current->group_leader->pid.

Link: https://lkml.kernel.org/r/aXY_2JIhCeGAYC0r@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Leon Romanovsky <leon@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Christan König <christian.koenig@amd.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem_odp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/core/umem_odp.c~rdma-umem-dont-abuse-current-group_leader
+++ a/drivers/infiniband/core/umem_odp.c
@@ -149,7 +149,7 @@ struct ib_umem_odp *ib_umem_odp_alloc_im
 	umem->owning_mm = current->mm;
 	umem_odp->page_shift = PAGE_SHIFT;
 
-	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	umem_odp->tgid = get_task_pid(current, PIDTYPE_TGID);
 	ib_init_umem_implicit_odp(umem_odp);
 	return umem_odp;
 }
@@ -258,7 +258,7 @@ struct ib_umem_odp *ib_umem_odp_get(stru
 		umem_odp->page_shift = HPAGE_SHIFT;
 #endif
 
-	umem_odp->tgid = get_task_pid(current->group_leader, PIDTYPE_PID);
+	umem_odp->tgid = get_task_pid(current, PIDTYPE_TGID);
 	ret = ib_init_umem_odp(umem_odp, ops);
 	if (ret)
 		goto err_put_pid;
_

Patches currently in -mm which might be from oleg@redhat.com are


