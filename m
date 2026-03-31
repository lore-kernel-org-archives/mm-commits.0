Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B047A40855
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774917824; cv=none; b=P376ihY8iHiJUzIE66vqtg044EnkbI8VwMvq04fTosngP7ODLDgQD1LaBWfjr39fRqPvlHBw5Z1T2e5WBkG+ROlmE/Ea88M06BUIeXuqkUsE9Yi3/qZ3RKpwOK8fNz/pNAoff0KXblpEKVq/mIGpWr9qqo22yCqxlcOcb8QYGrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774917824; c=relaxed/simple;
	bh=7tnxVpn7fjrA4ZwWsk3gMj16Yt8Xn8dVHq4jy8ge2zc=;
	h=Date:To:From:Subject:Message-Id; b=GED1Ht8mWloPDDo1bteqfkVzFUAzgqyUnuPkhklcM7hqrCgdmC/BP/xrhLEmtZvfnEbpIC435TUWY0mGBZZWCgqTwOuCEdGkNPbg6rAhDYmSSmrl4fJzZ44FRiroW5ZWQLJa+KQyyuCKQ/QCbGEokEtPbm3GbQtFE60/lzlYQIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1IB9/lW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1IB9/lW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE6C19423;
	Tue, 31 Mar 2026 00:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774917824;
	bh=7tnxVpn7fjrA4ZwWsk3gMj16Yt8Xn8dVHq4jy8ge2zc=;
	h=Date:To:From:Subject:From;
	b=1IB9/lW9zspddxDkI0q1ZbY814AKKPBS9NNxCnANgD7Y3qQDjhRmbOzCmXOn1YjDr
	 PJREP26nZK+kbM/BUjFTabNQvD0d8edNpWY5rL8mRY86XQYSh4KQCVBI3S3ZNAFYb2
	 pxIpj/VQ2K8dLBHAyGQaq1phFrqdFEaAlzDt5BIw=
Date: Mon, 30 Mar 2026 17:43:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch removed from -mm tree
Message-Id: <20260331004344.88FE6C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:07:21 +0000

A recent bug I analysed managed to, through a bug in the userfaultfd
implementation, reach an invalid point in the zap_huge_pmd() code where
the PMD was none of:

- A non-DAX, PFN or mixed map.
- The huge zero folio
- A present PMD entry
- A softleaf entry

The code at this point calls folio_test_anon() on a known-NULL folio.
Having logic like this explicitly NULL dereference in the code is hard to
understand, and makes debugging potentially more difficult.

Add an else branch to handle this case and WARN().

No functional change intended.

Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
Link: https://lkml.kernel.org/r/fcf1f6de84a2ace188b6bf103fa15dde695f1ed8.1774029655.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-handle-buggy-pmd-entry-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -2462,6 +2462,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+	} else {
+		WARN_ON_ONCE(true);
+		spin_unlock(ptl);
+		return true;
 	}
 
 	if (folio_test_anon(folio)) {
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

