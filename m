Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F9676C73
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451104; cv=none; b=O8JYLKJ/02hAAZB+m1GYrdFpZ+IfFVJHCsR+I6lU9mPA9OpJow6+zv1hZewwVPaaF5HhFHNROQlCdiBrVHaReURZI6xafXXU+V5hNPhO6ZVM0LwzokrBCbxFEJb+MEEIN1vTq5HWFK/z0RCtNlwiitpGe7MpgeUosKDvpxnaBQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451104; c=relaxed/simple;
	bh=fSI1IMpBj7rps0sIPiu1w4KqOLFA9nccp06OpLW7KTU=;
	h=Date:To:From:Subject:Message-Id; b=Fanoy9B+gwuIHBOM5gm343avx1vRshjwbWG86PGY+XBNoJkEBArabyzFuxd3WpqRb8xMYYUYcPwBSG9V7ka8ySOzG3CzCL8yN9y8HawmkDkvGdsvFut7UO5kSAyK8ZDJASOE59y8p8BlfoMNa3/e1OJtzzRsmR8oKzaNHE0QG9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YZOcmCHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YZOcmCHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349E2C433C7;
	Tue, 20 Feb 2024 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708451104;
	bh=fSI1IMpBj7rps0sIPiu1w4KqOLFA9nccp06OpLW7KTU=;
	h=Date:To:From:Subject:From;
	b=YZOcmCHHdPQVMSW3TohL5PFs2Oud5QyZxxsgRIxUYQ/71ZAzL44tW6N5HKG74vzyx
	 8Um0qVyrSDRkMlpD1sz7BvrE57T3HySTMoKbcVH8IhdGCGfc3i0Skqh/YhSbyQ6Ndn
	 Rzfu/o2+D+IvgZt4NiWjehtJI16ZcuE2uVD3PYYY=
Date: Tue, 20 Feb 2024 09:45:03 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-add-support-for-0-order-folio-memory-compaction-fix.patch added to mm-unstable branch
Message-Id: <20240220174504.349E2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-compaction-add-support-for-0-order-folio-memory-compaction-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-add-support-for-0-order-folio-memory-compaction-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-add-support-for-0-order-folio-memory-compaction-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-add-support-for-0-order-folio-memory-compaction-fix
Date: Tue Feb 20 09:43:50 AM PST 2024

fix mismerge in compaction_alloc()

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-add-support-for-0-order-folio-memory-compaction-fix
+++ a/mm/compaction.c
@@ -1845,7 +1845,7 @@ static struct folio *compaction_alloc(st
 	if (order)
 		prep_compound_page(&dst->page, order);
 	cc->nr_freepages -= 1 << order;
-	cc->nr_migratepages--;
+	c->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
mm-compaction-add-support-for-0-order-folio-memory-compaction-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

