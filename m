Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB012FF66C
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 19:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505156; cv=none; b=o5vTpjhnpY+Wx4XPltEPFl1P6icvym+jdP192ABQMaxMIiMwHCyEvSy1x2MDcdpkj+xwa8rutzNjO+Dzeww0GnUprL3nZjQyc+DN0iC3KaOx7yKjUT5ywqE8NwKF2J+c44Q2Qg4HQr9+fG0bvZ6OSPBGdwG/QytEDoGP5qwWVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505156; c=relaxed/simple;
	bh=+C6vz5VlM3QFdIgRLHAZBVIsRskLIx8fRK97zebSF7Y=;
	h=Date:To:From:Subject:Message-Id; b=L2RcIF9nOIWHkWlI7Oc9P8+NA6StR3zwFviPFpyHAw1qSstmie7qwnAmSPpArKqk9rKcA1iMypb9WLsieumVkKUcs1c+TeMarI7dIfRBCl2oEEXr2WeefKcZrsDCqIAhk1qvpSCNUjbSgqbtmD1AJreEwiUTEgCX3O4jcOwKSdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Auh786qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Auh786qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D21BC16AAE;
	Thu, 15 Jan 2026 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768505155;
	bh=+C6vz5VlM3QFdIgRLHAZBVIsRskLIx8fRK97zebSF7Y=;
	h=Date:To:From:Subject:From;
	b=Auh786qfEOtDYFeqmD7GEyybLm7qlPD//vmZoY0xNZZ5sSX67n+j+EHIopNfDAloj
	 cPGmSKlHP9w5VfJy3PlFonYRDD3IeUVWHoyOHoHWmhSDoI/TvjSYvmO0uzZxxWPvBh
	 J1hCJ7KerP5T39pVsLpFLetOr7VJi6kABpPZ9g34=
Date: Thu, 15 Jan 2026 11:25:54 -0800
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,joshua.hahnjy@gmail.com,david@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch added to mm-new branch
Message-Id: <20260115192555.2D21BC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-enforce-brace-style-checkpatch-fixes
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm-hugetlb-enforce-brace-style-checkpatch-fixes
Date: Thu Jan 15 11:25:21 AM PST 2026

WARNING: suspect code indent for conditional statements (16, 25)
#63: FILE: mm/hugetlb.c:2678:
+		} else {
[...]
 			 vma_end_reservation(h, vma, address);

total: 0 errors, 1 warnings, 58 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-hugetlb-enforce-brace-style.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Hildenbrand <david@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-enforce-brace-style-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -2679,8 +2679,7 @@ void restore_reserve_on_error(struct hst
 			/*
 			 * No reservation present, do nothing
 			 */
-			 vma_end_reservation(h, vma, address);
-
+			vma_end_reservation(h, vma, address);
 		}
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-enforce-brace-style-checkpatch-fixes.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

