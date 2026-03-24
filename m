Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1435F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388475; cv=none; b=DFry/NnsVL1x07s2TKKVvdluhs8kR/lGO1lUI1GCkqspaAEZdqdkXFcrnGNoKzLtQTo6yu93kaSs+jOmLApjwPGnbzdh8m5ExM+bk5Hb5E6u82O/BQVbYiBdvyLytfx01GRrjZbqVmyiu/VehK81gdikr8w/SrCFW+Ds1oXt/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388475; c=relaxed/simple;
	bh=0+qIF2Gj4NTq6w+XoMkrv093Xmb0dKBp4MxOIIRWabc=;
	h=Date:To:From:Subject:Message-Id; b=Nr81kCjceJ0974uc6vO5H9esV6Fht8SbTfPwJR4rkhi66DGG87NodonGOy5GzRFIyHMdDXhe8AedtdW7ac6apMNDwczxvN5c4B3goL71E+DME8Rm9O2XI784AqbumWEzen91b4HWfFWRdpQpfvMg8hg54eVMLjHhgJmavyydgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nnyJ6WIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nnyJ6WIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735E8C19424;
	Tue, 24 Mar 2026 21:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388475;
	bh=0+qIF2Gj4NTq6w+XoMkrv093Xmb0dKBp4MxOIIRWabc=;
	h=Date:To:From:Subject:From;
	b=nnyJ6WIf7r0iQwiqFCNjdqnzLwB5dlBxWjOiJVPhYlYW/W5ANpptqzkELmySOepXl
	 RsAllnpSl1IlSC1Pt3wMixJSmfGvrX6qyBYFqynfN42NXd9bKwbMQILJMHKH/yGjPp
	 wmYbQhTJIEZlSxLbes4B9esij0emBEzLGp5b3nu4=
Date: Tue, 24 Mar 2026 14:41:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,qin.yuA@h3c.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch removed from -mm tree
Message-Id: <20260324214115.735E8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: remove redudnant mmu notifier call in pmdp mkold
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: qinyu <qin.yuA@h3c.com>
Subject: mm/damon/ops-common: remove redudnant mmu notifier call in pmdp mkold
Date: Tue, 3 Feb 2026 17:54:00 +0800

Currently, mmu_notifier_clear_young() is called immediately after
pmdp_clear_young_notify(), which already calls mmu_notifier_clear_young()
internally.  This results in a redundant notifier call.

Replace pmdp_clear_young_notify() with the non-notify variant to avoid the
duplicate call and make the pmdp path consistent with the corresponding
ptep_mkold() code.

Link: https://lkml.kernel.org/r/20260203095400.2465255-1-qin.yuA@h3c.com
Signed-off-by: qinyu <qin.yuA@h3c.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/ops-common.c~mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold
+++ a/mm/damon/ops-common.c
@@ -90,7 +90,7 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 		return;
 
 	if (likely(pmd_present(pmdval)))
-		young |= pmdp_clear_young_notify(vma, addr, pmd);
+		young |= pmdp_test_and_clear_young(vma, addr, pmd);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE);
 	if (young)
 		folio_set_young(folio);
_

Patches currently in -mm which might be from qin.yuA@h3c.com are


