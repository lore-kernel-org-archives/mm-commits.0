Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA442DF6F4
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960410; cv=none; b=l1bCdKYOTFFIYn6J2aCdX1lwzU/fKsedEW60vSHUUiEkfS/kQyy62taEQdRIfptx5ALlCb1WUqH7eDwSMWZV3XaOGmElHG1w7IBGlZROHuUjYgwZOQPy1FldzPTkLePWty365d9mp9K5ukw0JI913X1bW6UqsWWXItXy1AmKOFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960410; c=relaxed/simple;
	bh=POH3/DoImC0VkoNYSjQhMZVMKw3BtUArl+YaMbwVDQQ=;
	h=Date:To:From:Subject:Message-Id; b=iO5qpnHv3YgeJyTVkt2Xy3LvYqEK8yyBVWB3tq7ROEtAyqWY4cBRHzduiJlbYNk7zftOWRpeg1GNLgUctEaafymgKQqdC7Cc+mojDLLxJnmLpu3rcvN1WDzPuzDS9j+aBhPmZbLU5XtSpWDqgqrtHY/ovscOfReVXpgHGoZsQk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sT8GjVYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sT8GjVYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6BEC16AAE;
	Wed, 21 Jan 2026 01:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960409;
	bh=POH3/DoImC0VkoNYSjQhMZVMKw3BtUArl+YaMbwVDQQ=;
	h=Date:To:From:Subject:From;
	b=sT8GjVYKOTtq5qyDptZyGBMhGTUZoHw8VA0hkD6ftCpS7qwAn2qUfF1rwrrIK6nrW
	 ofOihuvofccwVSjse40xE3lbRszS/ZvyVPrCjtiTyRpMDEPMoZxsGtgaIHat4wwLVf
	 jVr08VyiU5b6FLbBJJilHgcNYRw1IrbCZjSBrwIw=
Date: Tue, 20 Jan 2026 17:53:29 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-fix-minor-spelling-mistakes-in-comments-fix.patch removed from -mm tree
Message-Id: <20260121015329.AE6BEC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-fix-minor-spelling-mistakes-in-comments-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-minor-spelling-mistakes-in-comments-fix.patch

This patch was dropped because it was folded into mm-fix-minor-spelling-mistakes-in-comments.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-minor-spelling-mistakes-in-comments-fix
Date: Sat Dec 20 11:51:12 AM PST 2025

also fix comment grammar, per SeongJae

Cc: Kevin Lourenco <klourencodev@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-fix-minor-spelling-mistakes-in-comments-fix
+++ a/mm/vma.c
@@ -2951,10 +2951,10 @@ retry:
 		return -ENOMEM;
 
 	/*
-	 * Adjust for the gap first so it doesn't interfere with the
-	 * later alignment. The first step is the minimum needed to
-	 * fulfill the start gap, the next steps is the minimum to align
-	 * that. It is the minimum needed to fulfill both.
+	 * Adjust for the gap first so it doesn't interfere with the later
+	 * alignment. The first step is the minimum needed to fulfill the start
+	 * gap, the next step is the minimum to align that. It is the minimum
+	 * needed to fulfill both.
 	 */
 	gap = vma_iter_addr(&vmi) + info->start_gap;
 	gap += (info->align_offset - gap) & info->align_mask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-fix-minor-spelling-mistakes-in-comments.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

