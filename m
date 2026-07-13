Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93834EEFD
	for <mm-commits@vger.kernel.org>; Mon, 13 Jul 2026 20:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783973814; cv=none; b=UDleY66uJZUbT7QX7UoJ0RZfrXnMccs6fCmsGncGIWH1aChJmaOU8RYqKB0JYCNEnSQR0B3+Xbip6A/SjAye+WL5SCPq6XfOju6O2BNuaVUF8akqtqQvNqJtsoI3fJqg8YqJfHshad4sKCPiM/iCL0nVbuxjoYWdSuTOBn9ppXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783973814; c=relaxed/simple;
	bh=fF+EzZHtSNEsBbeCwYUC25OxAL1Fk+PWD0pi3SnLStM=;
	h=Date:To:From:Subject:Message-Id; b=NqdO9D7DouM6a8hzOT3N/RElkwfTvF2+sgTbrIUIS1Bwi6MFDkhbS8SN8Z0k5ZiBlnHX0p/e/zUdWdLTGvTmIPVMeM+inTGXLMZ42qacH5evStNTl6+DzZdaOmYiwTiQLyaikKh/WYb/E0med2aoXBU9Wf6rA9sGTZbvA81r2rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cIoVMF+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cIoVMF+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483F71F000E9;
	Mon, 13 Jul 2026 20:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783973812;
	bh=rhYkqKeeP6tJqRh9ekd6YPk2m/4DVEeakc8vAjV1eWI=;
	h=Date:To:From:Subject;
	b=cIoVMF+3A+WQP0oUF95rjI0GpFkoI+V/eMSnaUBojmNDQ+EhmFb386OLChkJqPKEh
	 Rk4JNb5rXclY5AaggOrvGDW0tF/1lBIzZOCKXT/NyF9fpv2h4Xi5UVgk9/6gKeF9bS
	 lG+7VWNT1IWHRhhF5NofvtliJ4CxYAQDz9geTtRY=
Date: Mon, 13 Jul 2026 13:16:51 -0700
To: mm-commits@vger.kernel.org,youngjun.park@lge.com,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,hch@lst.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-count_swpout_vm_event.patch added to mm-new branch
Message-Id: <20260713201652.483F71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: remove count_swpout_vm_event
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-remove-count_swpout_vm_event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-count_swpout_vm_event.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swap: remove count_swpout_vm_event
Date: Mon, 13 Jul 2026 11:33:41 +0200

There is only one caller left, so merge it into that.

Link: https://lore.kernel.org/20260713093350.2154226-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

--- a/mm/page_io.c~mm-swap-remove-count_swpout_vm_event
+++ a/mm/page_io.c
@@ -254,19 +254,6 @@ out_unlock:
 	return ret;
 }
 
-static inline void count_swpout_vm_event(struct folio *folio)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio))) {
-		count_memcg_folio_events(folio, THP_SWPOUT, 1);
-		count_vm_event(THP_SWPOUT);
-	}
-#endif
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
-	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
-}
-
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
 {
@@ -397,7 +384,16 @@ void __swap_writepage(struct swap_io_ctx
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	count_swpout_vm_event(folio);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
+		count_vm_event(THP_SWPOUT);
+	}
+#endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	swap_add_folio(ctx, folio, WRITE);
_

Patches currently in -mm which might be from hch@lst.de are

mm-remove-wb_writeout_inc.patch
shmem-provide-a-shmem_write_folio-wrapper.patch
mm-swap-introduce-struct-swap_io_ctx.patch
mm-swap-also-use-struct-swap_iocb-for-block-i-o.patch
mm-swap-remove-count_swpout_vm_event.patch
mm-swap-use-swap_ops-to-register-swap-devices-methods.patch
mm-swap-remove-swp_fs_ops.patch
mm-vmstat-add-nrswpinout-counters.patch

