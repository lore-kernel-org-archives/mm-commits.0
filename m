Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5901E487;
	Tue, 14 May 2024 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715710917; cv=none; b=mzDRjx+x0Vy5AinLHwFwS19kwbpn1xime3rz913EHGrrBM4nFuBholi2vUqHUBTOorXQH0qgH1JQG7JfHL2C+A6bytPDpO4x/YgCOM8u78Z+hpNC248pDerinAd3uru/glOPsfvmOJ7RZKg4wYly8FMrQGXbe0UkeFsCqoSCwjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715710917; c=relaxed/simple;
	bh=vmd1Wbet79qrAMDzsTnla96BFxR2SLaCABhrFHuvXL8=;
	h=Date:To:From:Subject:Message-Id; b=jqgfL3L5njJhl+BuOcXEkbk4NW6SVNcSgKonzInhhs3P/6s9Cx++inBcah66uzfBBRD8W4B11m9u/+CMAWbegTvsaZe2T51J9FGI4qegxqwekp+ULTF3zl/sKBrl52X3PUz+YvDOhp3ao1DfxIX2EkIaL44lTY7RH5yrYX2++Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bLdSarrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bLdSarrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB6CC2BD10;
	Tue, 14 May 2024 18:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715710917;
	bh=vmd1Wbet79qrAMDzsTnla96BFxR2SLaCABhrFHuvXL8=;
	h=Date:To:From:Subject:From;
	b=bLdSarrLZZRjbC4VPmdHl5OPdvrsxky0ZMw2LYyAYAxnyx5ntJslgXwLAP/4NxF4w
	 vvo5OX6kIqGWCvW+o1WUJC4SUlBiWt8Un5I2WueKejAiXrNp+r6bYyAckSyYeBhUlL
	 kN9j8f/JIyAOaipGvNM2eNKXXnlx6oA6iRNsYYXI=
Date: Tue, 14 May 2024 11:21:56 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,stable@vger.kernel.org,shy828301@gmail.com,nao.horiguchi@gmail.com,david@redhat.com,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-mark-huge_zero_page-reserved.patch added to mm-hotfixes-unstable branch
Message-Id: <20240514182156.EAB6CC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: mark huge_zero_page reserved
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-mark-huge_zero_page-reserved.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-mark-huge_zero_page-reserved.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
@@ -208,6 +208,7 @@ retry:
 		__free_pages(zero_page, compound_order(zero_page));
 		goto retry;
 	}
+	__SetPageReserved(zero_page);
 	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
 
 	/* We take additional reference here. It will be put back by shrinker */
@@ -260,6 +261,7 @@ static unsigned long shrink_huge_zero_pa
 		struct page *zero_page = xchg(&huge_zero_page, NULL);
 		BUG_ON(zero_page == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
+		__ClearPageReserved(zero_page);
 		__free_pages(zero_page, compound_order(zero_page));
 		return HPAGE_PMD_NR;
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-mark-huge_zero_page-reserved.patch

