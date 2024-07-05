Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774EE364A1
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 20:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720212710; cv=none; b=NKd7/N96sqnUMj4a4OEqckp73EA69Ah+BftO/gRAFIpmmkNeqhUzDv0jFDjvUOqK01RTUdmaF/75Zlt2AmMy+9ZN2rnY6Oar/j768ucsTrekY8GKuJ2P04ynFl1WHhQJlsbYCOcJ/TZVOmTdbn0rpJt+cKcyCve9d3NIiG8iooE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720212710; c=relaxed/simple;
	bh=9uiIhy2RlU1G5Whva7fFSsAk+y5JxBtqtd70DMcNTuM=;
	h=Date:To:From:Subject:Message-Id; b=mY2ojm3jKVJ1TLWWyi+2DGSrhSh7Qbb8zfrzTnQMQyfMcFd3vpENsJpeEc0vOTDxNcDKj6pVH9zX6Ere2Gq9Pp2TloSuHRxG/ct1rdMMN8ZL8XeNMfh/jprDhuyyzcMAGzRZNewIFhEZWyPcarrDNDZfdMwHhkI5tn+45ZhtLU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8kvlFbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8kvlFbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5F9C116B1;
	Fri,  5 Jul 2024 20:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720212710;
	bh=9uiIhy2RlU1G5Whva7fFSsAk+y5JxBtqtd70DMcNTuM=;
	h=Date:To:From:Subject:From;
	b=o8kvlFbkEtTuZ7EPrdbTv01OMZZjxn6ZvE0EPVMKJwKAErW7XTlpXb1ojDcOuYwmO
	 sa09qBinPevEz2biszEMsim6EI8FBAGatvyBl0etugeb6vtdd54WTKuj3jerpQdZyI
	 30xpGTO+tX+Yev3BlTO+xs1btY7K5034fEh7DDKE=
Date: Fri, 05 Jul 2024 13:51:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shy828301@gmail.com,ryan.roberts@arm.com,mingzhe.yang@ly.com,libang.li@antgroup.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-per-order-mthp-split-counters-fix.patch added to mm-unstable branch
Message-Id: <20240705205150.0E5F9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-per-order-mthp-split-counters-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-per-order-mthp-split-counters-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-per-order-mthp-split-counters-fix.patch

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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm-add-per-order-mthp-split-counters-fix
Date: Fri, 5 Jul 2024 19:31:19 +0800

use == for `order' test, per David

Link: https://lkml.kernel.org/r/20240705113119.82210-1-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mingzhe Yang <mingzhe.yang@ly.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-add-per-order-mthp-split-counters-fix
+++ a/mm/huge_memory.c
@@ -3259,7 +3259,7 @@ out_unlock:
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (order >= HPAGE_PMD_ORDER)
+	if (order == HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-add-per-order-mthp-split-counters.patch
mm-add-per-order-mthp-split-counters-v3.patch
mm-add-per-order-mthp-split-counters-fix.patch
mm-add-docs-for-per-order-mthp-split-counters.patch
mm-add-docs-for-per-order-mthp-split-counters-v3.patch

