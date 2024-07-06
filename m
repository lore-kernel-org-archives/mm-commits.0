Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0509E13C80F
	for <mm-commits@vger.kernel.org>; Sat,  6 Jul 2024 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720292045; cv=none; b=WPYaZmfKVvLM+4qQ8T1yzC56imjnNfRHh3IVN44ZnFcwwQxoLQx1BI4zFt0sEyHnD0H5DGWCVbbmrqZw4/WfkrQtmZMt6fYh2KXOppmc8fL60bioia0JokelPpkgZR4tkTP3mlI/g1C5OAObi2ZzbZyHxRl3CBe8juFs+MRa1ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720292045; c=relaxed/simple;
	bh=qPi2M7Q6k2/V7TMj4+QmXw60JPGZ8zh3B5uXXmcCNQ8=;
	h=Date:To:From:Subject:Message-Id; b=sSWHa08sm6S70tJeaaWmYWLxo50nx5qwrOtD4LrHuPh7knS5fUiSbIzknz1x27FmQcZkXb9J3W5vhKL73q3jtLto36u3lHDExTeufAKHj4+FEhZr63+XMgNt3OdLl1eeuny1ZtcdzJTM3+UC7sDfaMVxXmMD3/PrxhIyf7VO7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BkMyrzcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BkMyrzcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF304C2BD10;
	Sat,  6 Jul 2024 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720292044;
	bh=qPi2M7Q6k2/V7TMj4+QmXw60JPGZ8zh3B5uXXmcCNQ8=;
	h=Date:To:From:Subject:From;
	b=BkMyrzcbU7mrlUx1ls0YIHm1DSw/bHKFZlVjOx80C9CTTxvs/ifwj11q0eCd/HkIn
	 Ku/eC+UkChyZbb3zwhLYjqrvFubkBCmpIMertlFWhk5OYrBSZWSFnL5RgQ/rnBbT6L
	 cQ5Smp8iFEaYu7J6Pi9xNbn8TBji8321yjx3BTy4=
Date: Sat, 06 Jul 2024 11:54:04 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-input-and-output-inconsistencies.patch removed from -mm tree
Message-Id: <20240706185404.CF304C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: fix input and output inconsistencies
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-input-and-output-inconsistencies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Bang Li" <libang.li@antgroup.com>
Subject: mm/shmem: fix input and output inconsistencies
Date: Fri, 28 Jun 2024 11:23:27 +0800

Commit 19eaf44954df ("mm: thp: support allocation of anonymous multi-size
THP") added mTHP support for anonymous shmem.  We can configure different
policies through the multi-size THP sysfs interface for anonymous shmem.

But when we configure the "advise" policy of
/sys/kernel/mm/transparent_hugepage/hugepages-xxxkB/shmem_enabled, we
cannot write the "advise", but write the "madvise", which is unreasonable.
We should keep the output and input values consistent, which is more
convenient for users.

Link: https://lkml.kernel.org/r/20240628032327.16987-1-libang.li@antgroup.com
Fixes: 61a57f1b1da9 ("mm: shmem: add multi-size THP sysfs interface for anonymous shmem")
Signed-off-by: Bang Li <libang.li@antgroup.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-fix-input-and-output-inconsistencies
+++ a/mm/shmem.c
@@ -4983,7 +4983,7 @@ static ssize_t thpsize_shmem_enabled_sto
 		clear_bit(order, &huge_shmem_orders_madvise);
 		set_bit(order, &huge_shmem_orders_within_size);
 		spin_unlock(&huge_shmem_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
+	} else if (sysfs_streq(buf, "advise")) {
 		spin_lock(&huge_shmem_orders_lock);
 		clear_bit(order, &huge_shmem_orders_always);
 		clear_bit(order, &huge_shmem_orders_inherit);
_

Patches currently in -mm which might be from libang.li@antgroup.com are

mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

