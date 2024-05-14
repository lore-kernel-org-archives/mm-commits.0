Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF19181BB3;
	Tue, 14 May 2024 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715724118; cv=none; b=pEZckDfFc1D7Dur9CrXeRlO263Yq9iY/0iHemRfc1hBfagfJ7ZNHk2nUXmA02R4sZdCSQM8JyBeDk2I626JVmpwmPFysWNEe9zieC/qkXLdlI57Kti68X+pAt4YLvu7NHmH2Enzcm4AOqaMU/l4w2MZS/z7zpwDYO82VmNH0Kt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715724118; c=relaxed/simple;
	bh=qdhxkqdLch7dDgLozqH/+44poIfKsEPpJpqcOAAZxOc=;
	h=Date:To:From:Subject:Message-Id; b=Z8+5U6ZxnPzkQADui9Lhv8+J99d/fnC59EPv0Vmq3Z54hXfYxh14ssqKOu648LF+WI0GxKBCZQ+K3yWPzTgPzVkjXiQCVux8+QeiCvPOLYW44XVsWL+HPKe5L7+P4PrOM0MdDqVFJN/kBunRwHngI2hsNwUXUvQhcZNDnT6G9pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UkTeMHS1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UkTeMHS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A8EC32786;
	Tue, 14 May 2024 22:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715724118;
	bh=qdhxkqdLch7dDgLozqH/+44poIfKsEPpJpqcOAAZxOc=;
	h=Date:To:From:Subject:From;
	b=UkTeMHS15BTRjVr2o34QCBAzxmYHhWg0Mxi+g0ciCxFZ62sMNXScMkQEwFFhAqr99
	 Jhcdnd+drB8hLFlOF+Wv+xHPYjfoMsd30mChhouP/arQP3vmpp3gRFQcD65aJWU8lc
	 8dSB8u2bUf/H1zHXF3LWvpEuz88v5sdANpmLCPjk=
Date: Tue, 14 May 2024 15:01:57 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,willy@infradead.org,stable@vger.kernel.org,shy828301@gmail.com,nao.horiguchi@gmail.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-huge_memory-mark-huge_zero_page-reserved.patch removed from -mm tree
Message-Id: <20240514220158.56A8EC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: mark huge_zero_page reserved
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-mark-huge_zero_page-reserved.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory: mark huge_zero_page reserved
Date: Sat, 11 May 2024 11:54:35 +0800

When I did memory failure tests recently, below panic occurs:

 kernel BUG at include/linux/mm.h:1135!
 invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 9 PID: 137 Comm: kswapd1 Not tainted 6.9.0-rc4-00491-gd5ce28f156fe-dirty #14
 RIP: 0010:shrink_huge_zero_page_scan+0x168/0x1a0
 RSP: 0018:ffff9933c6c57bd0 EFLAGS: 00000246
 RAX: 000000000000003e RBX: 0000000000000000 RCX: ffff88f61fc5c9c8
 RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff88f61fc5c9c0
 RBP: ffffcd7c446b0000 R08: ffffffff9a9405f0 R09: 0000000000005492
 R10: 00000000000030ea R11: ffffffff9a9405f0 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff88e703c4ac00
 FS:  0000000000000000(0000) GS:ffff88f61fc40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055f4da6e9878 CR3: 0000000c71048000 CR4: 00000000000006f0
 Call Trace:
  <TASK>
  do_shrink_slab+0x14f/0x6a0
  shrink_slab+0xca/0x8c0
  shrink_node+0x2d0/0x7d0
  balance_pgdat+0x33a/0x720
  kswapd+0x1f3/0x410
  kthread+0xd5/0x100
  ret_from_fork+0x2f/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 Modules linked in: mce_inject hwpoison_inject
 ---[ end trace 0000000000000000 ]---
 RIP: 0010:shrink_huge_zero_page_scan+0x168/0x1a0
 RSP: 0018:ffff9933c6c57bd0 EFLAGS: 00000246
 RAX: 000000000000003e RBX: 0000000000000000 RCX: ffff88f61fc5c9c8
 RDX: 0000000000000000 RSI: 0000000000000027 RDI: ffff88f61fc5c9c0
 RBP: ffffcd7c446b0000 R08: ffffffff9a9405f0 R09: 0000000000005492
 R10: 00000000000030ea R11: ffffffff9a9405f0 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff88e703c4ac00
 FS:  0000000000000000(0000) GS:ffff88f61fc40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055f4da6e9878 CR3: 0000000c71048000 CR4: 00000000000006f0

The root cause is that HWPoison flag will be set for huge_zero_page
without increasing the page refcnt. But then unpoison_memory() will
decrease the page refcnt unexpectly as it appears like a successfully
hwpoisoned page leading to VM_BUG_ON_PAGE(page_ref_count(page) == 0)
when releasing huge_zero_page.

Fix this issue by marking huge_zero_page reserved. So unpoison_memory()
will skip this page. This will make it consistent with ZERO_PAGE case too.

Link: https://lkml.kernel.org/r/20240511035435.1477004-1-linmiaohe@huawei.com
Fixes: 478d134e9506 ("mm/huge_memory: do not overkill when splitting huge_zero_page")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-mark-huge_zero_page-reserved
+++ a/mm/huge_memory.c
@@ -212,6 +212,7 @@ retry:
 		folio_put(zero_folio);
 		goto retry;
 	}
+	__SetPageReserved(zero_page);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
@@ -264,6 +265,7 @@ static unsigned long shrink_huge_zero_pa
 		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
 		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		__ClearPageReserved(zero_page);
 		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


