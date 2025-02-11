Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFDA27293C
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739315265; cv=none; b=EkQwTpnQ7q/xAouFQcCVYKdrMMRf6F4hzvnBtVLY85a9jBy4cc8Ol0uqYQkNRVVVkzQQwUxzbrdrUnQ1kPJb9g8XHHf6j1GDl4x/GGNo8eg7BySOwoRyuyWynLoIpl7MjO12ZPOtyq4+eBh0yeFQBZhWaIy4STedlVZKbvYPjcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739315265; c=relaxed/simple;
	bh=gAvGa4yYQxl2ZhSpIxXiXxK8euuYDalzVYyd9odNYKQ=;
	h=Date:To:From:Subject:Message-Id; b=Plwc2fdA0r1u5udiQ9OEVaH2GFX5OyehPyKwf3UYp9zcv3+iinrtKTHlDPr0fHM39X7Ok8DpJfjBW8OgkPZlJFw3/h3UT88Oa9dxuypvFl7nGztO1xeU0GYkod5Oh0J0FdtQLkNjdiQ/FyfPyy/CoMoxRe7U17g+5PeyKBiuaoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a0lwhEbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a0lwhEbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4481C4CEDD;
	Tue, 11 Feb 2025 23:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739315264;
	bh=gAvGa4yYQxl2ZhSpIxXiXxK8euuYDalzVYyd9odNYKQ=;
	h=Date:To:From:Subject:From;
	b=a0lwhEbQGRWh/od6fZvgaUxXukYJf87HpIxmQOIMEumgNQsCsqwLwHS4cSKseTKMx
	 L1tXVomr7h15EuZi4o1f6sgodD104ql+WCRkUb4zR7Sz2b5TytbqrBzluszUpQqZ5b
	 6hV2+Tz0oiffMcxW8C4mmoM7txjY1fheZfgrtyek=
Date: Tue, 11 Feb 2025 15:07:44 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-update-comment-on-rcu-freeing.patch added to mm-unstable branch
Message-Id: <20250211230744.A4481C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: update comment on RCU freeing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmu_gather-update-comment-on-rcu-freeing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-update-comment-on-rcu-freeing.patch

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

mm-mmu_gather-update-comment-on-rcu-freeing.patch

