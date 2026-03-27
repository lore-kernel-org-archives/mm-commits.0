Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053F8279DC9
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 05:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774590668; cv=none; b=LaiS0BXv3MYTSRuk6AzEFJ0i+RhklS9YcnTNFFzURLMfwCtUH01xOGN8OyaJf6ae58SxbUdhQbUJz3yblvCoZWVaEtxUZ5IrHZc/TFe4BrCQbR1vZu0Znf56++9Q9/GZ5xJJn4UNIblVXjpeFStIl63M+tLsoLK4nO6ho4HaU0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774590668; c=relaxed/simple;
	bh=upCIZGkDfMmOLD3rqR4LdlPxC4K9VbF1YmFdgT2s5/E=;
	h=Date:To:From:Subject:Message-Id; b=Aj60/hSqprILqByOvS4WMZba3hvXe3EQeBzu/WDoUC4dIeAWTPv/tgYQ0emoDVFbjkJve9b42qn1OL7nUl0/3DW9RUyzPqobMcnxP5BkxI6HK4GWKPD3aLtgIYo96zUe0M13VffpXzNkgM0mI7EHfKuJaQMocD3wl55bD5veM+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkUZjil4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkUZjil4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3A4C19423;
	Fri, 27 Mar 2026 05:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774590667;
	bh=upCIZGkDfMmOLD3rqR4LdlPxC4K9VbF1YmFdgT2s5/E=;
	h=Date:To:From:Subject:From;
	b=TkUZjil43daYygDvjlqbwNDtNyTEns+mpSPbdhvV2wo8S4QhPr88qXOWkungsqbB5
	 YC7a1x6QetW9B/UcoAkucHFvQhlncT72Sm2G7SRhjWbM1hwd1a2TBMPrJ53300vjT/
	 nwhk3P+cpSPnjgaF3YYMlydB52UKwLDjISBbeMZM=
Date: Thu, 26 Mar 2026 22:51:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch removed from -mm tree
Message-Id: <20260327055107.BD3A4C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix
has been removed from the -mm tree.  Its filename was
     mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch

This patch was dropped because it was folded into mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix
Date: Tue Mar 24 07:31:31 AM PDT 2026

fix comment typo, per Vlastimil

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/util.c~mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix
+++ a/mm/util.c
@@ -1215,7 +1215,7 @@ int compat_vma_mmap(struct file *file, s
 	if (err)
 		return err;
 
-	/* being invoked from .mmmap means we don't have to enforce this. */
+	/* being invoked from .mmap means we don't have to enforce this. */
 	action->hide_from_rmap_until_complete = false;
 
 	set_vma_from_desc(vma, &desc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-switch-the-rmap-lock-held-option-off-in-compat-layer.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-skip-uffd-wp-mremap-if-uffd-write-protect-is-unsupported-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

