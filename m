Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9C25D1E6
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758473659; cv=none; b=PnaeLpniikJzHOqAlMdgBDBUE+Xqlx0sfm1r9yNgLOf2xx6i4dEVOUqTOiesEx/RS08JUcY5ZOdBvdUqqQ86ZLKhyNY/agP5Dc3aexf8LzeskvYcUMg6TLaOcmLmWyKWjgmzLbh0XBMkq1MGpNqZeahTeAhzY3unF3LhVPfP2EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758473659; c=relaxed/simple;
	bh=CeCth3O1Cz4iM9o5Ww+xYF9xuU/Udw81Cquf72zBk1k=;
	h=Date:To:From:Subject:Message-Id; b=ultVPuwr3kvQA2jDhts60de/ZNhs4rv6boz+ROYkLT7hmmgxLEGG8SIDmYgR8RlXRSn7dr2t/0umcKzeSt7Nzo+D+dZmnijgh5hWzVMBA/j5Y+KYOX9YwkOiKrOVKo4aOK45k5tiLn1DJRIzdkYd9YuRoSKqUuRUEZ72q9RS3I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tOe61Mlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tOe61Mlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F91BC4CEE7;
	Sun, 21 Sep 2025 16:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758473659;
	bh=CeCth3O1Cz4iM9o5Ww+xYF9xuU/Udw81Cquf72zBk1k=;
	h=Date:To:From:Subject:From;
	b=tOe61MlfoFImKgj8Ye3VZR8+x4FwBOPvMeSSZ52Y4R2fvxb1dW8yqX5PEvQkabFpT
	 SxTOWKwwPvxbkRDFoPA0JZ3kVUmrtj7gkPAi+n4OjvZ13VHAAV4sVUUEapJt4CvTtR
	 i3DJ1j58/dC8Bfo8yiiINIBCW4VQtgFp46WsQHXc=
Date: Sun, 21 Sep 2025 09:54:18 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch added to mm-nonmm-unstable branch
Message-Id: <20250921165419.1F91BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
Date: Sun Sep 21 09:52:59 AM PDT 2025

ERROR: code indent should use tabs where possible
#38: FILE: include/linux/kexec_handover.h:44:
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);$

WARNING: please, no spaces at the start of a line
#38: FILE: include/linux/kexec_handover.h:44:
+        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);$

ERROR: code indent should use tabs where possible
#39: FILE: include/linux/kexec_handover.h:45:
+        unsigned int total_pages;$

WARNING: please, no spaces at the start of a line
#39: FILE: include/linux/kexec_handover.h:45:
+        unsigned int total_pages;$

ERROR: code indent should use tabs where possible
#40: FILE: include/linux/kexec_handover.h:46:
+        unsigned short flags;$

WARNING: please, no spaces at the start of a line
#40: FILE: include/linux/kexec_handover.h:46:
+        unsigned short flags;$

ERROR: code indent should use tabs where possible
#41: FILE: include/linux/kexec_handover.h:47:
+        unsigned short order;$

WARNING: please, no spaces at the start of a line
#41: FILE: include/linux/kexec_handover.h:47:
+        unsigned short order;$

total: 4 errors, 4 warnings, 350 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/kho-add-support-for-preserving-vmalloc-allocations.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/kexec_handover.h~kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes
+++ a/include/linux/kexec_handover.h
@@ -41,10 +41,10 @@ struct kho_serialization;
 
 struct kho_vmalloc_chunk;
 struct kho_vmalloc {
-        DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
-        unsigned int total_pages;
-        unsigned short flags;
-        unsigned short order;
+	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
+	unsigned int total_pages;
+	unsigned short flags;
+	unsigned short order;
 };
 
 #ifdef CONFIG_KEXEC_HANDOVER
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
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

