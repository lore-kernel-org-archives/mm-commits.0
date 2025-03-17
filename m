Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CBE215771
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188272; cv=none; b=pMBGrj2AHpAEDhTuIYjEZ0uom8AnSVzRVuO5meG1V3/i50yYSms/w6uuVSbWahzbkYlQ8W/1m2+fkRi6STguINx5iW9oEbzBpOLrBr8OXJYS1lhzQGpoPjQzj0PHeVXuDtTbaxqudJ1FiG8Ot1pfIjby5g4XkCBuk3GA5ksyXsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188272; c=relaxed/simple;
	bh=GgaShnRtJrYJlr8NHD2HKseuQZ/zLMTR8ocud9cbyPM=;
	h=Date:To:From:Subject:Message-Id; b=sRrwqptqGwzoLb5TUKXPiqp1NymrDAOZ/b7IudzvAX5S7dHk1bopDLzwXuL8zXtfP61ZbrQYEfkXqVBTmPhYgr1ezbDqzCHxG4EwheSzGLLBgycpT124KS0UrX2GNrQ1f32smZoDlHMVwikJnmyiHtgQST8DyQVGDjZk/2qYxwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nfS84y2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nfS84y2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B775C4CEEC;
	Mon, 17 Mar 2025 05:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188272;
	bh=GgaShnRtJrYJlr8NHD2HKseuQZ/zLMTR8ocud9cbyPM=;
	h=Date:To:From:Subject:From;
	b=nfS84y2RdCiVV4AZEnSQRSJgcB4v3vnonxwi/MU9XoEGWn2JdkScA1KqpMG+Uw0Y3
	 p8bfqNinwtEPeOIk9rsMvl2pK3+txVPJQ95Xks+ZIK5Cokpu+c5gZqxUg6hKq2Mney
	 XX01jpO8dq1nRqSV4vnxFXF3BNxFLTg7QXnai780=
Date: Sun, 16 Mar 2025 22:11:11 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-update-comment-on-rcu-freeing.patch removed from -mm tree
Message-Id: <20250317051112.6B775C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: update comment on RCU freeing
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-update-comment-on-rcu-freeing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/mmu_gather: update comment on RCU freeing
Date: Tue, 11 Feb 2025 13:00:23 +0000

Some recent discussion on LMKL [0] brought up some interesting and useful
additional context on RCU-freeing for pagetables.

Note down some extra info in here, in particular a) be concrete about the
reason why an arch might not have an IPI and b) add the interesting
paravirt details.

[0] https://lore.kernel.org/linux-kernel/20250206044346.3810242-2-riel@surriel.com/

Link: https://lkml.kernel.org/r/20250211-mmugather-comment-v1-1-1ac1e0c765d2@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/mmu_gather.c~mm-mmu_gather-update-comment-on-rcu-freeing
+++ a/mm/mmu_gather.c
@@ -246,8 +246,16 @@ static void __tlb_remove_table_free(stru
  * IRQs delays the completion of the TLB flush we can never observe an already
  * freed page.
  *
- * Architectures that do not have this (PPC) need to delay the freeing by some
- * other means, this is that means.
+ * Not all systems IPI every CPU for this purpose:
+ *
+ * - Some architectures have HW support for cross-CPU synchronisation of TLB
+ *   flushes, so there's no IPI at all.
+ *
+ * - Paravirt guests can do this TLB flushing in the hypervisor, or coordinate
+ *   with the hypervisor to defer flushing on preempted vCPUs.
+ *
+ * Such systems need to delay the freeing by some other means, this is that
+ * means.
  *
  * What we do is batch the freed directory pages (tables) and RCU free them.
  * We use the sched RCU variant, as that guarantees that IRQ/preempt disabling
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

