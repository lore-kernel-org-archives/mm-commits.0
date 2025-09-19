Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284F62765ED
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315037; cv=none; b=RR6ffOjvny5A3gl2J8qpHvi52D94hpaVMbU+b21Z4Uv75KB0e+09azBRTKtT22CEd1E8Ol6Q/sur9bmnmDnCBTWhaPA7qh/pkL4lOAtcn6Uh0Jc2tf4vPd6bY4ja8p6/NAELut5m/bdh34EN1HUAhSIhHPuCSK8ewvHkBvCsA5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315037; c=relaxed/simple;
	bh=3FLVOgYO8hYHld72TzwtAcY2yxdRDZx0iGa5kGE6kss=;
	h=Date:To:From:Subject:Message-Id; b=bt9kFcw7U0oxl8QLigVjJ8uPdm9zSTFHwD8Mk9ZKVZ0rp1a21xbqqS/xYrOFbJbEmtIctm2NFvG+/gisk6pTBsT5iPtJaLP0WiEKmlQabHywE/DJ0KPT2D6kZFCr36HY1hq0f5OC1rQnsJd2snbQ6vACdmTEyj9frXFwQuBanWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1yr15rU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1yr15rU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB5C4CEF0;
	Fri, 19 Sep 2025 20:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758315036;
	bh=3FLVOgYO8hYHld72TzwtAcY2yxdRDZx0iGa5kGE6kss=;
	h=Date:To:From:Subject:From;
	b=a1yr15rUuM4Ne15JDYApf/5cuZQBQL72HLsQ5O/7VJj/gC2YxbF5zGIB++JSJKkyu
	 VygCzwEXRlTQBAoCh45GxmWr1SvXLkz2JOBak5YILIdjHkrIcDxenVsgj0NU7PLcrX
	 1sJlHm5qkN1DF8bjE5BO4cSDxM9H54y3NwLD8+8k=
Date: Fri, 19 Sep 2025 13:50:36 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rdunlap@infradead.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch added to mm-unstable branch
Message-Id: <20250919205036.C7EB5C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch

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
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
Date: Fri Sep 19 01:47:57 PM PDT 2025

add newline to prevent docs warning, per Randy

Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1016,6 +1016,7 @@ For example if the counters are not accu
 
 Supported markers in v2:
 accurate:no
+
               Absolute values of the counters in this line are not accurate
               because of the failure to allocate memory to track some of the
               allocations made at this location.  Deltas in these counters are
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch

