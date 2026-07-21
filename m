Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BBB4582DA;
	Tue, 21 Jul 2026 23:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784677127; cv=none; b=C5IzF0IpEK7BAitzBOD8k8QBksTJspkUUEwH4FX6DPs2yDYBOga8Pags+Egm1+yISfcZu/vYUB8hRR0DsGHhw+3BSAZSl8q798mbKPUJsLnQ5+LPSfR5z39GymfaOKNnN7Cp4VWah26R9PJQG8lgAtahL/EKnciaZR0rypDpCd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784677127; c=relaxed/simple;
	bh=6p4DVv1nCKQGm+rLBgIuziykvlEKnPy5O2p9byCSM8s=;
	h=Date:To:From:Subject:Message-Id; b=J3mTzPUd55I1ru1k6RMy+biEJUSAD3wgM/r4kbHZMqc0EvBCqhNaFpwSVm4+vrG9lRvRnUjnWVou3jQJbEA+i/+wGsvnuu9BXspjtym5fPFMK3ja8ulUfjkFyVF3qPLEqJ4ohb7bZmC6ZrtQSiXf3XBm4yu/rcLembjKE6E2OIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=maD3QeR4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="maD3QeR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CA91F000E9;
	Tue, 21 Jul 2026 23:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784677125;
	bh=m8w57RtJitOPs7i/Uk/pCMHgxykpBphj8frCU5BE2Vw=;
	h=Date:To:From:Subject;
	b=maD3QeR4d16iISdI9qH2s9+665o8en6/KvvsaAijvcURT8rOSFfc+HPNVYzRoT7El
	 cKoFC0qrZ9ujsvMX30EsJ6GrzBNClPUuurTUm71BbIfwHCYrnHGa/WniOK+hZ2cnAg
	 QIR6BIc4DEcyfgB81rabGknsJYlN4OP0CdfIvvOI=
Date: Tue, 21 Jul 2026 16:38:45 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,oleg.deomi@gmail.com,bsingharora@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-taskstatsc-parse-fix-buffer-allocation-size.patch added to mm-nonmm-unstable branch
Message-Id: <20260721233845.C0CA91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel/taskstats.c:parse(): fix buffer allocation size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-taskstatsc-parse-fix-buffer-allocation-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-taskstatsc-parse-fix-buffer-allocation-size.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kernel/taskstats.c:parse(): fix buffer allocation size
Date: Tue Jul 21 04:30:41 PM PDT 2026

parse() is failing to allow for the nla_strscpy()'s null termination of
the cpumask string.  This can result in the cpumask string being
truncated.

This can result in an inappropriate -EINVAL failure or in reporting for an
incorrect span of CPUs.

Fixes: f9fd8914c1ac ("[PATCH] per-task delay accounting taskstats interface: control exit data through cpumasks")
Reported-by: Oleg Deomi <oleg.deomi@gmail.com>
Closes: https://lore.kernel.org/CAByWkfZ6b1=3H9pwkz-dDQOs9cZaF-HYQ6b9Yb0=Hq2r1Vv_Pw@mail.gmail.com
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~kernel-taskstatsc-parse-fix-buffer-allocation-size
+++ a/kernel/taskstats.c
@@ -368,7 +368,7 @@ static int parse(struct nlattr *na, stru
 		return -E2BIG;
 	if (len < 1)
 		return -EINVAL;
-	data = kmalloc(len, GFP_KERNEL);
+	data = kmalloc(len + 1, GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 	nla_strscpy(data, na, len);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic-fix.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-vma-add-and-use-vma__pgoff-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch
kernel-taskstatsc-parse-fix-buffer-allocation-size.patch

