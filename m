Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC073C5859
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439082; cv=none; b=biyOjJYrynjkL5JHNbgM8iZtJ8d2xH6IqBH/61V0JoQvVeQbBaWWTD5TP3gXTiic2iaiM2iyfj0dOtRWzIwd0OjVBX8UvKcCcZdhL70t2mZrxDrVYyVBt6SAFCngtVIUOXhX7hvs83jNvfXlMAgDIix1jVT3MPDHpD+vh/Kkmm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439082; c=relaxed/simple;
	bh=Iid8U1o8qhiqLxGAp33iXAhaOo885l106/tjzgTBbAs=;
	h=Date:To:From:Subject:Message-Id; b=dT6/JQjJzW4ij0dagfjEKDViBGRs8hmXypoo8MWPmSDpiNS46924F7/ne8R3O9byamtDLCh0xkYvt5t8f5SWDgFN01Q5C7E84Fib+9QdIotuBA7I0YcHzsyd7Yo7FHe/3LkF3nWhOzxq+qcdriVcqEXU1pjBzR6oAUwC/vHN6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GP2nVCeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GP2nVCeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4691F00898;
	Tue,  2 Jun 2026 22:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439081;
	bh=4P+q2PnJHyUKgyI8FpLI77pNs0XZmrbJWj0G5AobYw8=;
	h=Date:To:From:Subject;
	b=GP2nVCeAYXT339iZ+1kXvsP7CpCqoCWkgSBooS3dD7HcXwefjOI15HI4ukZxLGY3s
	 nFj2Duu3q9OFF7pxny1BbvBlBbhIeMFJFawQEGunh1RCn+PfF5gxC7cy2TE9y7xzHt
	 lw2N2DYHT1xq7dnYgTAdQzD9qsy9x60c3sSbPSQA=
Date: Tue, 02 Jun 2026 15:24:40 -0700
To: mm-commits@vger.kernel.org,leon@kernel.org,jgg@ziepe.ca,apopple@nvidia.com,liuqiang@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch removed from -mm tree
Message-Id: <20260602222441.4E4691F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_hmm: fix error path in dmirror_devmem_fault()
has been removed from the -mm tree.  Its filename was
     lib-test_hmm-fix-error-path-in-dmirror_devmem_fault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qiang Liu <liuqiang@kylinos.cn>
Subject: lib/test_hmm: fix error path in dmirror_devmem_fault()
Date: Fri, 15 May 2026 15:03:11 +0800

Handle migrate_vma_setup() failure via goto err for unified cleanup.

Link: https://lore.kernel.org/20260515070312.130435-1-liuqiangneo@163.com
Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_hmm.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/lib/test_hmm.c~lib-test_hmm-fix-error-path-in-dmirror_devmem_fault
+++ a/lib/test_hmm.c
@@ -1679,8 +1679,14 @@ static vm_fault_t dmirror_devmem_fault(s
 	if (order)
 		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
 
-	if (migrate_vma_setup(&args))
-		return VM_FAULT_SIGBUS;
+	/*
+	 * In practice migrate_vma_setup() should never fail unless the
+	 * test is wrong as it just tests some static VMA properties.
+	 */
+	if (migrate_vma_setup(&args)) {
+		ret = VM_FAULT_SIGBUS;
+		goto err;
+	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
 	if (ret)
_

Patches currently in -mm which might be from liuqiang@kylinos.cn are


