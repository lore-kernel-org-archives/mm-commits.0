Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453D13CB2C9
	for <mm-commits@vger.kernel.org>; Wed, 18 Mar 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773858016; cv=none; b=GA/FlEIzAe1OCW9xKQsd0agz5Mn9qdk5MsjeVAKnsPvduLRodnt/9VW+eXI6XKBS/HMVApHWe1UQ2BEkKpYl3maej+ycSxnmUtetF072AzryMI3VbJCO9frBe/QPzT9gz1gWu6qyQVCIN78yUGREqVd6kZybvvCfdBGduLCidBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773858016; c=relaxed/simple;
	bh=fZlzTCH6Oo/ru/euJXSh9S30M2ztbAwWXnjhaoECvXE=;
	h=Date:To:From:Subject:Message-Id; b=Wmvom6Kp+9+XmV4pFtOjijOGkrrTmLVTVhjb1jvsqCiMwaq3Dv6uCP5y3VIhIxOis0cqFNNSGE4oPGJC/bRo396JoGoQgH6cHjec4ZX/qTWxUnehCYYuPUC/G1H0NbOZ1zL/f2SirznCLwpcI3f8cBnnQRegpgGPYMCcVQ8DfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fl+87n0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fl+87n0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9C3C19421;
	Wed, 18 Mar 2026 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773858015;
	bh=fZlzTCH6Oo/ru/euJXSh9S30M2ztbAwWXnjhaoECvXE=;
	h=Date:To:From:Subject:From;
	b=Fl+87n0+Ng9nKEoHau7jXUP50VfKoXpYGN+Qr8KWHGG+slSAN9hjpzTQ60lpuBdgx
	 QXy5npfWRUNWM/2qaPaxhLrresYIn4IWx/vSiZedXeDytwaZOSHI4mkqHw0AiLrebX
	 +vmPlzx7HizP6kfZQxcdzHdCtQUis/NmmxU6qsT4=
Date: Wed, 18 Mar 2026 11:20:15 -0700
To: mm-commits@vger.kernel.org,puranjay@kernel.org,ljs@kernel.org,david@kernel.org,broonie@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch added to mm-unstable branch
Message-Id: <20260318182015.BC9C3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rename-zap_page_range_single-to-zap_vma_range-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch

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

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch

