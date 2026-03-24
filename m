Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0363C5477E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 14:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774362741; cv=none; b=Z0+Q6DJ/lESoDyUpT9sQwDwb+zwyZMkjx0hMfhlLXimr/CuvB7Ee3hky4esPMCzxU9KDgnHmMA/OgUsDxDVL116u+/ebBrRQwaHlm92Qn5syS4q0PATXgjwdXtXckI9yMMsZvj/6TF0CN19is8xmiyMnW9Rj7xEs48Ei+yETVFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774362741; c=relaxed/simple;
	bh=wjOhBO4ynKU3Y3gYedeg9VtIW0H72R/OHIYombSxOyY=;
	h=Date:To:From:Subject:Message-Id; b=hMZzIksZOzsmd8uB+QoBZHtXO35/88uOq97B+Qd/8PrGJ7wMzDWrY4OA/tj8mQmdZze27XwsI3iAxMEPVr7Vyyx23urv4hBFx1mb+qUeI0aEk+p/LA65rx4Qv/PHU4oLWTwlpMSe5aqwU0btdJhuwtrYaDWtkk1O2OjQcsyex5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XXjsUENQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XXjsUENQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B12C19424;
	Tue, 24 Mar 2026 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774362740;
	bh=wjOhBO4ynKU3Y3gYedeg9VtIW0H72R/OHIYombSxOyY=;
	h=Date:To:From:Subject:From;
	b=XXjsUENQBcbuZtkVSJsuzAs3VNyRyS5f3YlZ0oDXrrEio3dVYDg7EWnuOyIgqemAl
	 8njckSz1x1B0K0TbSAgyD+uhDc2E/FVjWl7S16jSERZlWC4ar6422c+12DbJktAVSr
	 OrEPXoEeUf7MOWbvWs2CbqBk3rZu+D4IsOia8EuA=
Date: Tue, 24 Mar 2026 07:32:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch added to mm-unstable branch
Message-Id: <20260324143220.86B12C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

