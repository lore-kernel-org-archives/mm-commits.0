Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373DE15B54C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738110125; cv=none; b=CLsFG75tXGijBU2fgd+h8Jf7QwT+NfKBiRIUyoJfuGXTVh94Apx6jlQ8IymgHB7ymvuRH7X0GB4tX826tvrSZcJ4g/j8xiEyzQCZZ3anlBb3eO1lJYT/4qJtrwIIiNwu7RbrqyLPjzj6mZ/Kd3d3JbCnKnk8z/q/iZ1iHyCBhRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738110125; c=relaxed/simple;
	bh=Fd9Co3j8n5vInMazfKarWzo1Zb7870n9FdXOuGbJWa4=;
	h=Date:To:From:Subject:Message-Id; b=aa5J24qFwzZ+crJSDf6Qw7iQ9/5As5pZtZWbIm5Z1mHffUhnxdefYfitAiENRJrj78Ajxi+JdUVhls+y1c64fiCPMif1F+zjAgfDlYbhA6Xg20xKazMJjIL5gc2+qIpcgEIxwNMfu+xTmFnOPyLuZDdllf6rhorQigvkXM24lxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J3XlxMTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J3XlxMTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4196C4CEE6;
	Wed, 29 Jan 2025 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738110125;
	bh=Fd9Co3j8n5vInMazfKarWzo1Zb7870n9FdXOuGbJWa4=;
	h=Date:To:From:Subject:From;
	b=J3XlxMTUirwPHWj7mMGHHBCbNi5qXOq/7fcThFyQnGakn46Xo4/ndufp7OL3yh88y
	 1FpHo2tLBRzgdFIhBgK/Tm2+mmlpmKdecklZAZa5EXUkPENlQedn+WJafmz35fLWrz
	 tfanAzVKSYJQYEDFd/33lm+HyUSDqD3c87Ks9vPg=
Date: Tue, 28 Jan 2025 16:22:04 -0800
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,sooraj20636@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch removed from -mm tree
Message-Id: <20250129002204.E4196C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm: prevent infinite loop in hmm_range_fault during EBUSY retries
has been removed from the -mm tree.  Its filename was
     mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: sooraj <sooraj20636@gmail.com>
Subject: mm/hmm: prevent infinite loop in hmm_range_fault during EBUSY retries
Date: Tue, 28 Jan 2025 01:34:22 -0500

When hmm_vma_walk_test() skips a VMA (e.g., unsupported VM_IO/PFNMAP
range), it must update hmm_vma_walk->last to the end of the skipped VMA. 
Failing to do so causes hmm_range_fault() to restart from the same address
during -EBUSY retries, reprocessing the skipped VMA indefinitely.  This
results in an infinite loop if the VMA remains non-processable.

Update hmm_vma_walk->last to the VMA's end address in hmm_vma_walk_test()
when skipping the range.  This ensures subsequent iterations resume
correctly after the skipped VMA, preventing infinite retry loops.

Link: https://lkml.kernel.org/r/20250128063422.7604-1-sooraj20636@gmail.com
Signed-off-by: sooraj <sooraj20636@gmail.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hmm.c~mm-hmm-prevent-infinite-loop-in-hmm_range_fault-during-ebusy-retries
+++ a/mm/hmm.c
@@ -547,6 +547,8 @@ static int hmm_vma_walk_test(unsigned lo
 
 	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
 
+	/* Update last to the end of the skipped VMA to prevent reprocessing */
+	hmm_vma_walk->last = end;
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
 }
_

Patches currently in -mm which might be from sooraj20636@gmail.com are


