Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD02E8B9B
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394058; cv=none; b=k0DG9DJp4uTeID6ko05KBCjcQ5Ym6IjLiTfdVK9yW1XJ+SvVrstWNBDJZeiVI6X3bUYBL0hVdFF5I9S43NrNcsc0ekFDc9TyaZs/0TyOoPFmBvdk29BdjddRSDoMagYgWges570aH8OVF3mteZKJXQmVT3IUJeJzu2t5zLr8O6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394058; c=relaxed/simple;
	bh=kNbIs7rHNLjimykOiAAx1DNm6k2+wwSwvMcaysKrIx4=;
	h=Date:To:From:Subject:Message-Id; b=oDeHzrG0Gy5/CznaZkO13VxZYxu/iz0a9s54WPI91vgZiN7rX6/lgH9TcNsK7f4a5+/DReArO/M1HMSyiOk0IesqbGRXevLw5Z0douWWIKCkTOEhXsdg2Ug5hospL5aU4SNn7sz3MSfmhGRQLWCS8WDCEahPyvcAH7aBrHBpcic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=at7kVZuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="at7kVZuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA00DC19424;
	Tue, 24 Mar 2026 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774394057;
	bh=kNbIs7rHNLjimykOiAAx1DNm6k2+wwSwvMcaysKrIx4=;
	h=Date:To:From:Subject:From;
	b=at7kVZuK7YyErO/JGNRfbvId2px0ZmFoazKlFHb66Nb5UnhJ/iiYP3aCvbRstm+rb
	 6sCMk/DG7qWT59XDkdRyWO1+IF8aiDD4KoomBKHygTW1vYk9sEqwyuW0LLisuH1nMo
	 TgeVu0DuSyXdZ5XhcgBgi3pWkD+jFGIsU55PvuCU=
Date: Tue, 24 Mar 2026 16:14:17 -0700
To: mm-commits@vger.kernel.org,puranjay@kernel.org,ljs@kernel.org,david@kernel.org,broonie@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch removed from -mm tree
Message-Id: <20260324231417.AA00DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-rename-zap_page_range_single-to-zap_vma_range-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch

This patch was dropped because it was folded into mm-rename-zap_page_range_single-to-zap_vma_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rename-zap_page_range_single-to-zap_vma_range-fix
Date: Wed Mar 18 11:18:24 AM PDT 2026

fix rustfmtcheck

Reported-by: Mark Brown <broonie@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/android/binder/page_range.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder/page_range.rs~mm-rename-zap_page_range_single-to-zap_vma_range-fix
+++ a/drivers/android/binder/page_range.rs
@@ -762,7 +762,7 @@ unsafe extern "C" fn rust_shrink_free_pa
     if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
         if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
             let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
-        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
+            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
         }
     }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-rename-zap_page_range_single-to-zap_vma_range.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-switch-the-rmap-lock-held-option-off-in-compat-layer-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

