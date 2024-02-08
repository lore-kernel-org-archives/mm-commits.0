Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D734F1EB
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427662; cv=none; b=ZUO/spFv7gSLqHYpBLkIKOykgSSD2sRJJcdZWM4Xt8c4LSGKj+FFQeH8MxJUesg+ewDtiXKuatiqXzHHKJKCN4L9FZsK1jSK6i+Q4xxKAEoArcOkYwoZuiruioI83rnRXQUTs4KKEDafg8pxIiZ7pyDE93oBhQiheZfAntHkBzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427662; c=relaxed/simple;
	bh=gjGUbeGeXR6IHkphOg8t8S+VD3cKpJLOaLvw7qecfAw=;
	h=Date:To:From:Subject:Message-Id; b=EmJHQ3lO+DeMNxKNpZ2Ux8A+7cxA0zf3uOhQa1DIHFbofLu7gddZ7XILPvadjQljBQQhznztWTsg+4pzuVEW/j+OlhWWO1psNkQrFT9woLjIST9HtHNYCSv01NWIh6J4RTQg+17yVYecfRLAItzsYpZsqLEuMT02AEpBs2ivE5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dh60pIvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dh60pIvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5C1C43394;
	Thu,  8 Feb 2024 21:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707427661;
	bh=gjGUbeGeXR6IHkphOg8t8S+VD3cKpJLOaLvw7qecfAw=;
	h=Date:To:From:Subject:From;
	b=dh60pIvYeAXOdIaYbijjMlqbk3MLaVv8tJCRfW1Gwwz2y5h8MaaDJTHkYSvptGABB
	 nIkVUCOf2mTmTCwVvPzN4RA49O9tIbIfn+79iLG8nF973kxzyAIrnqX24aHTSfyput
	 RCE4m1xiMMrj56RQumPmjmcSWqBcGpSgzdCj+phI=
Date: Thu, 08 Feb 2024 13:27:41 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.l.verma@intel.com,torvalds@linux-foundation.org,snitzer@kernel.org,mpatocka@redhat.com,linux@armlinux.org.uk,david@fromorbit.com,dave.jiang@intel.com,dan.j.williams@intel.com,arnd@arndb.de,agk@redhat.com,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvdimm-pmem-cleanup-alloc_dax-error-handling.patch added to mm-unstable branch
Message-Id: <20240208212741.CC5C1C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvdimm/pmem: cleanup alloc_dax() error handling
has been added to the -mm mm-unstable branch.  Its filename is
     nvdimm-pmem-cleanup-alloc_dax-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvdimm-pmem-cleanup-alloc_dax-error-handling.patch

This patch will later appear in the mm-unstable branch at
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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: nvdimm/pmem: cleanup alloc_dax() error handling
Date: Thu, 8 Feb 2024 13:49:10 -0500

Now that alloc_dax() returns ERR_PTR(-EOPNOTSUPP) rather than NULL, the
callers do not have to handle NULL return values anymore.

Link: https://lkml.kernel.org/r/20240208184913.484340-10-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvdimm/pmem.c~nvdimm-pmem-cleanup-alloc_dax-error-handling
+++ a/drivers/nvdimm/pmem.c
@@ -558,8 +558,8 @@ static int pmem_attach_disk(struct devic
 	disk->bb = &pmem->bb;
 
 	dax_dev = alloc_dax(pmem, &pmem_dax_ops);
-	if (IS_ERR_OR_NULL(dax_dev)) {
-		rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
+	if (IS_ERR(dax_dev)) {
+		rc = PTR_ERR(dax_dev);
 		if (rc != -EOPNOTSUPP)
 			goto out;
 	} else {
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

nvdimm-pmem-fix-leak-on-dax_add_host-failure.patch
nvdimm-pmem-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dm-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dcssblk-handle-alloc_dax-eopnotsupp-failure.patch
virtio-treat-alloc_dax-eopnotsupp-failure-as-non-fatal.patch
dax-check-for-data-cache-aliasing-at-runtime.patch
introduce-cpu_dcache_is_aliasing-across-all-architectures.patch
dax-fix-incorrect-list-of-data-cache-aliasing-architectures.patch
nvdimm-pmem-cleanup-alloc_dax-error-handling.patch
dm-cleanup-alloc_dax-error-handling.patch
dcssblk-cleanup-alloc_dax-error-handling.patch
virtio-cleanup-alloc_dax-error-handling.patch

