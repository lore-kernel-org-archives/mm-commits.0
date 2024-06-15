Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AE226AED
	for <mm-commits@vger.kernel.org>; Sat, 15 Jun 2024 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718472472; cv=none; b=mWpCl6gyXQiGU8Js+ZzVpv+7LnAseKgBZyQdOVhCzo6ukZtHgKR6NXnWFYCVp5t760ShXEKuw7IZzzu6plalwnrEztTUws8NOZ15ag02OQM16D5QMtijX6yCtuWmYLL8XtRaJV5HNb7i5CsuuhuI0XUlVz5bnKO8Rmcsxr+nKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718472472; c=relaxed/simple;
	bh=bBQAAdQa90rnMWzJYa4bQoIdkZFVZs14gKLRwYluRo8=;
	h=Date:To:From:Subject:Message-Id; b=Ox+wAsoedNUnhxEpl5V/o9Ib9EXum5OXpMERNAiwaxLF6/JP5dgYD6o87lDSGbtHymkhnyd8t7kmfND2xkeJ0EvD+gpV3T8zYTxn2zS9aw/jMKa89Dawr843OML3u1sCgcmFTy1ooO6biRp+Mnv+49bMXioytyG1QJUSpE+euc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O9L+3a9B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O9L+3a9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892EBC116B1;
	Sat, 15 Jun 2024 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718472471;
	bh=bBQAAdQa90rnMWzJYa4bQoIdkZFVZs14gKLRwYluRo8=;
	h=Date:To:From:Subject:From;
	b=O9L+3a9B68Z7uGaWiZT9lsqwPP/fxN4Qb8qCsZKQ/QdFFBGJZ9kLRu8k1EW4eYJz+
	 pZ/VCQr3C00oVG2AYKLSUU4WfZtJBiVN6IaxeO6w1GTTAWmYiSxgiZVVjE3ioaG6Fz
	 PDvOSHcSksUQJsWQtrhnuCnNl0SL8DJzOz24yirc=
Date: Sat, 15 Jun 2024 10:27:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch added to mm-hotfixes-unstable branch
Message-Id: <20240615172751.892EBC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix getting incorrect lruvec when replacing a shmem folio
Date: Sat, 15 Jun 2024 11:49:54 +0800

remove less helpful comments, per Matthew

Link: https://lkml.kernel.org/r/ccad3fe1375b468ebca3227b6b729f3eaf9d8046.1718423197.git.baolin.wang@linux.alibaba.com
Fixes: 85ce2c517ade ("memcontrol: only transfer the memcg data for migration")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3
+++ a/mm/memcontrol.c
@@ -7745,8 +7745,7 @@ void __mem_cgroup_uncharge_folios(struct
  * @new: Replacement folio.
  *
  * Charge @new as a replacement folio for @old. @old will
- * be uncharged upon free. This is only used by the page cache
- * (in replace_page_cache_folio()).
+ * be uncharged upon free.
  *
  * Both folios must be locked, @new->mapping must be set up.
  */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio-v3.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

