Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A35745C0C
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 23:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826923; cv=none; b=Fh8eZfI04rXVehM8TRU3/L3fJRsnFSVbqxlsSaw8EjdCKPZLvPinONHhYGFU+BZczpeOPj6/sVXL+12GYhsatYeqQSZ/z5wnTlXNY6BsNH4UPken+lGnouEwRjsYLbxtUsNP3zvdJOrLolEpdWkZPEkDqv+6nFrqHoO7fRz5Sqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826923; c=relaxed/simple;
	bh=mwxmhQYH8nET5UR7sIByLBhXDBEhGJM7xbo4dduEe1w=;
	h=Date:To:From:Subject:Message-Id; b=fa/NwhXBIPqFAltUXw08pdGiN+srZBZSZvUNlW3lYlltFaQF08bwQemQk58l+4Z50jZZ3rMHogk+x/S4eWDJyboWKaA5Dxd/JA/I+FaS2wp7pZfBJCyXCo8Zs5adnquGUpwxuy+MDODPTmbpLHX28BG1GViUrNEwczm4OpFjTxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H8lnzrfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H8lnzrfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8127EC113CC;
	Mon, 22 Apr 2024 23:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713826922;
	bh=mwxmhQYH8nET5UR7sIByLBhXDBEhGJM7xbo4dduEe1w=;
	h=Date:To:From:Subject:From;
	b=H8lnzrfdaSz4Tx/bpLxKPPcK31PmdpU06ZBvU6pwG+GEak29o3gyvDDY957i/t+yd
	 jrp/mE2VprG0X2th2e4zvBFb8NoimVJLZQZsD3pSBmzn8yVEJdM0im7nQzXgthRZTx
	 25x1DQbmJXRWy7/ThbZsCdnPFmXfI8I5wDjhyeJI=
Date: Mon, 22 Apr 2024 16:02:01 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,shikemeng@huaweicloud.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch added to mm-unstable branch
Message-Id: <20240422230202.8127EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch

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
Subject: writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix
Date: Mon Apr 22 03:45:50 PM PDT 2024

fix build

mm/backing-dev.c: In function 'cgwb_debug_stats_show':
mm/backing-dev.c:195:25: error: unused variable 'stats' [-Werror=unused-variable]
  195 |         struct wb_stats stats;
      |                         ^~~~~

Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/backing-dev.c~writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix
+++ a/mm/backing-dev.c
@@ -192,7 +192,6 @@ static int cgwb_debug_stats_show(struct
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	struct bdi_writeback *wb;
-	struct wb_stats stats;
 
 	global_dirty_limits(&background_thresh, &dirty_thresh);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
writeback-support-retrieving-per-group-debug-writeback-stats-of-bdi-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch
binfmt_elf_fdpic-fix-proc-pid-auxv-checkpatch-fixes.patch

