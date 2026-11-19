Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072028;
	b=JgKhijKvADxig7T4KmQBq6uurtoarCddy7ttTQ4Td+8tvTG+mKB9aLyXp5hcjx2+HOFs
	 5JLB6yq1pPoll6cLY+5hTccl6TYBKiEqcQMxK2oT7p+RRuByiaWtrL4u+m3dlNuwRGno2
	 HtNUpjyxaaUctQuN0/aXSeFUxPCvZIyGYkJlixVd74fcUEih3UUHo9p6N+FKq9O9fkubW
	 AktwekY+bR4fhdmgThRWlctcDMZchuOy316cvaJ3rQou+UpGHgwuXQn/tcEhsfJ50GLAs
	 VE57ZRLY6h8uapc6sAk/5C8FB8UeWTKQUcYxMVBn4vpNPkCo5uHqFTqFdZRjffvE93A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072028;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=13hS8W2+Z6mdh6GKupWfYRPu5Wkx8N8tKFPargyW5IA=;
	b=rS1eDW10PVobsYnX5gu95pKEjffro6aGcujDNHm0ItRwss3/jGHjBchSQA4i7dYvUywV
	 7oQvx+kiPzAwf8K0rs0Ec5EhffvWDrP4611okpn8qApACtiVTrGLs5eX+zCp3JQ21rd8v
	 z2Ov4VM/Mq02SMlpUTfxorjPDnL6AYIIqlMPjm6Zg8vdkFnGgY69pWcUdQd2UcELNgCHd
	 pk1EpgZ5Jw7KQ/xjp35OxQINU/dONM1qvVx1fd41UEmp31DwVq0HPpo+g5UfSA1LNg3f6
	 MOTNCiXY4wSkApP+anSm6wogqS7GLxp6EuBdmjLdSKMGYImMdFxkJZAogY4GdY1nr2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oyMURZls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC151606A320;
	Thu, 19 Nov 2026 07:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oyMURZls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684D41F000C4;
	Thu, 19 Nov 2026 07:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795072027;
	bh=13hS8W2+Z6mdh6GKupWfYRPu5Wkx8N8tKFPargyW5IA=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=oyMURZlsNRvnAiHDeA/W5HeZXPtZbtjNjyV1vbyWxBnX6DybwRmHFNAcuCaxSmZ7I
	 qLmGUsD470fw/lOj1n315vRL6wgbuHx25KpvTJUz21jUxYDffZLUW+54nG8lCvuTvS
	 FjyshR9j/EZN3TCAKldWhMgj6udEakhvtDKHeObI=
Date: Wed, 18 Nov 2026 23:07:07 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,
	willy@infradead.org,tz2294@columbia.edu,stable@vger.kernel.org,
	rppt@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,
	muchun.song@linux.dev,mike.kravetz@oracle.com,linmiaohe@huawei.com,
	kaitao.cheng@linux.dev,jane.chu@oracle.com,david@kernel.org,
	mt4022@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-2-98085750c145@columbia.edu>
References: <20261103-hugetlb-hwpoison-leak-v2-2-98085750c145@columbia.edu>
Subject: + mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio.patch added to mm-new branch
Message-Id: <20261119070707.684D41F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Mani Tofigh <mt4022@columbia.edu>
Subject: mm/hugetlb: clear the hugetlb flag before leaking a hwpoisoned folio
Date: Tue, 03 Nov 2026 16:00:50 -0500

If hugetlb_update_hwpoison() fails to allocate a raw_hwp_page, the folio
is marked raw_hwp_unreliable and __update_and_free_hugetlb_folio() leaks
it intentionally.  With hugetlb_free_vmemmap=on, it's leaked before the
hugetlb flag is cleared, since commit 32c877191e02 ("hugetlb: do not
clear hugetlb dtor until allocating vmemmap") doesn't remove the flag
until the vmemmap is restored.  The leaked folio is then a hugetlb folio
with refcount 0 and on no list (the same state as a hugetlb folio that
is being freed), but nothing is freeing it, and
dissolve_free_hugetlb_folio() keeps retrying on it.  Offlining its
memory block then never completes, even on SIGKILL, and other tasks
block on the memory hotplug lock:

  [    3.271255] Memory failure: 0x20007: recovery action for free huge page: Failed
  [   41.729695] INFO: task hugeoffline:77 blocked for more than 20 seconds.
  ...
  [   41.733014]  get_online_mems+0xc1/0xd0
  [   41.733026]  soft_offline_page+0xfd/0x9b0

alloc_and_dissolve_hugetlb_folio() loops on it the same way.  The
refcount is 0 since commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race
with speculative PFN walkers").  Before that these paths failed with
-EBUSY.

Check raw_hwp_unreliable after the hugetlb flag is cleared so that the
folio is leaked as a non-hugetlb folio, as without vmemmap
optimization.  unpoison_memory() keeps refusing to unpoison it.  With
the fix, offlining retries as it does for any page it can't isolate,
and stops on a signal.

Link: https://patch.msgid.link/20261103-hugetlb-hwpoison-leak-v2-2-98085750c145@columbia.edu
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: <stable@vger.kernel.org>

 mm/hugetlb.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio
+++ a/mm/hugetlb.c
@@ -1515,13 +1515,6 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
-	 * If we don't know which subpages are hwpoisoned, we can't free
-	 * the hugepage, so it's leaked intentionally.
-	 */
-	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
-		return;
-
-	/*
 	 * If folio is not vmemmap optimized (!clear_flag), then the folio
 	 * is no longer identified as a hugetlb page.  hugetlb_vmemmap_restore_folio
 	 * can only be passed hugetlb pages and will BUG otherwise.
@@ -1549,6 +1542,14 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
+	 * If we don't know which subpages are hwpoisoned, we can't free
+	 * the hugepage, so it's leaked intentionally, but only once it is
+	 * no longer a hugetlb folio.
+	 */
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+		return;
+
+	/*
 	 * Move PageHWPoison flag from head page to the raw error pages,
 	 * which makes any healthy subpages reusable.
 	 */
_

Patches currently in -mm which might be from mt4022@columbia.edu are

mm-swapfile-drop-a-large-unmapped-swap-in-folio-in-unuse_pte.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio.patch
mm-hugetlb-clear-the-hugetlb-flag-before-leaking-a-hwpoisoned-folio.patch

