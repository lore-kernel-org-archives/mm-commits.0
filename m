Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C03130495
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725924728; cv=none; b=mLePJgqDp7JcfW0/nzm30UsOQuuwnhM2oT3shq3jZT0xaRX8Pb+lrrcGJPhYaVyLiBHDZIVgHteBENvSGBZhjUWHgkQOTXVzldHRXqotT4fcrTnPz/5sAfV07WbiKwrzfZ2QxV2KBU8tMw8vNFJzbdhRuxb6klt8WPRfHhKfgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725924728; c=relaxed/simple;
	bh=N/0YXrpdtq7TCjjGjC0vP8WpiHOc/5ANb09CqLVUUpY=;
	h=Date:To:From:Subject:Message-Id; b=HeAagBuVXyLtV2T9KZUDvijPVaVR6gRMRTVgeTMcoIQk+em+e7YQnDer67LQll5nWgrVRFvXdyzSpnt89pLB3/lgU26a6rXf65MqwWGcjwTRZlrUQyjqkhj3nslAVeRI6xKqWEd9qKG+BFIsE/p2oP6nu1tfUF3fVMhqFTBfaRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wquQMUVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wquQMUVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33233C4CEC5;
	Mon,  9 Sep 2024 23:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725924728;
	bh=N/0YXrpdtq7TCjjGjC0vP8WpiHOc/5ANb09CqLVUUpY=;
	h=Date:To:From:Subject:From;
	b=wquQMUVxxVu4LInH04KUEntxxz5bl21AlQZJxKFRB0dqBnBqgWbj/aN1rkGS3TKan
	 4NIOytXPs62gY4NYdf2JFe0MhJr+txt3cNdjge9QzmOAs+x1DBz/GXkAGmwPCV8x2o
	 zNMYUDyS2BpYMFAEHQvST1qCGoMB4EvBaZtJT9P8=
Date: Mon, 09 Sep 2024 16:32:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanshuai@oppo.com,v-songbaohua@oppo.com,usamaarif642@gmail.com,ryan.roberts@arm.com,kasong@tencent.com,kaleshsingh@google.com,ioworker0@gmail.com,hanchuanhua@oppo.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-count-the-number-of-anonymous-thps-per-size-fix.patch removed from -mm tree
Message-Id: <20240909233208.33233C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-count-the-number-of-anonymous-thps-per-size-fix
has been removed from the -mm tree.  Its filename was
     mm-count-the-number-of-anonymous-thps-per-size-fix.patch

This patch was dropped because it was folded into mm-count-the-number-of-anonymous-thps-per-size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-count-the-number-of-anonymous-thps-per-size-fix
Date: Tue Aug 27 06:00:44 PM PDT 2024

documentation fixups, per David

Link: https://lkml.kernel.org/r/3e8add35-e26b-443b-8a04-1078f4bc78f6@redhat.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-count-the-number-of-anonymous-thps-per-size-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -552,9 +552,9 @@ split_deferred
         be split under memory pressure, if splitting is possible.
 
 nr_anon
-       the number of transparent anon huge pages we have in the whole system.
-       These huge pages could be entirely mapped or have partially
-       unmapped/unused subpages.
+       the number of anonymous THP we have in the whole system. These THPs
+       might be currently entirely mapped or have partially unmapped/unused
+       subpages.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-count-the-number-of-anonymous-thps-per-size.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix.patch
mm-hugetlb-sort-out-global-lock-annotations-fix-fix.patch
mmtmpfs-consider-end-of-file-write-in-shmem_is_huge-checkpatch-fixes.patch
mm-page_alloc-fix-build-with-config_unaccepted_memory=n.patch
mm-vma-return-the-exact-errno-in-vms_gather_munmap_vmas-fix.patch

