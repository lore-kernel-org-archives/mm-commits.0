Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73753C9895
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 00:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785804539; cv=none; b=gZZTJiUHFrEtddPpAr8xIyYP1GYPjWk3D/hORwsXeWsrP3D4IYcQN7FRyfh9fzgD809kmbzxOSvxLOtgKLnOqqIHHUcMtFetRnuDjd6N25f1e3qJpJBWhVDDrb+A0S4DGlX9yg4jiGT0NvNPRptxZLzLT6V+d5K7x0lXOJVd7lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785804539; c=relaxed/simple;
	bh=MCNi8WyMrnYRAl3ixSRUMOy5AzHEMuilPH7dCGGwjsE=;
	h=Date:To:From:Subject:Message-Id; b=T16lURjZJ3eRLNOwsEZNovr2MOyazlcxK5+kIirsDeq/rnTRFfgXe8jm43c9uHGRSl95ACx0LnJM9q0tTXHn9y7+1eOYyjI+xMPXwt6DMsdIszzL0+mVYZZBGYcbJt/jgGMIsplMkcZPdTKkHrXxVcln4Rsfv6rpWSvrsLg2YEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+CxKtJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+CxKtJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452031F000E9;
	Tue,  4 Aug 2026 00:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785804537;
	bh=RjZPflqB/lsPH8S2IFUfQF9SQyip+9r7eIeqtxMl0qc=;
	h=Date:To:From:Subject;
	b=l+CxKtJMBnYos2dkxRDqYuT2i1cBTAPG44gnXCyATMfCp6agB4tx+i1omwC929as5
	 +PPnSj99n8ByO0kecZwN70DMBFVrKHBk1PjtpEP3PCDGDGK4vMS888gqcyQRHDNtcP
	 inscewsPYTu43nOVUqvzrRnL73YOSJdAkY2EE+Xc=
Date: Mon, 03 Aug 2026 17:48:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shijianlin11@foxmail.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch added to mm-unstable branch
Message-Id: <20260804004857.452031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch

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
Subject: mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
Date: Mon Aug  3 05:44:48 PM PDT 2026

use ARRAY_SIZE to dimension ratio[]

Cc: Brendan Jackman <jackmanb@google.com>
Cc: Jianlin Shi <shijianlin11@foxmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6926,7 +6926,7 @@ static int lowmem_reserve_ratio_sysctl_h
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
 	struct ctl_table tmp = *table;
-	int ratio[MAX_NR_ZONES];
+	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
 	int rc;
 
 	if (!write)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

