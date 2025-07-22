Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788234A2D
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753215238; cv=none; b=F3bkPK12oUa0XcThDJiLbZ8r49oNmVhysfLNihuEXCyKPAFQIEBBSSAwvy+LLnA8B9qnOuQgDoc+QP4v19LE0GibRVXYMfq+AQlxCYEiM5U0hivh3/Zg/jLcV1HjVeXdieHS/9NVeC//+b71gwK82/915uq51PxnyaGVVQ3YeNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753215238; c=relaxed/simple;
	bh=n4ajkAqOBIHQzyi2y0aQC60lvk4//3JEsP+IOt0qspA=;
	h=Date:To:From:Subject:Message-Id; b=gGISX7yPx3u4Kutj/hznsalCNtwTrJGlCa+0ZNBeR1CSR1gBBGp2q5UayH0eTGA9BwKIq7qGEr7ZmGy1VfLMZVqyCG8Sg7TtZc9bFq8I5RbHb5+Hb7gB+FXYh8duOXU4WH2sY6HIB3B5vvU/lDhRuay3xkd/gh7CRuK0N8xoCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F8IiTeLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F8IiTeLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8FBC4CEEB;
	Tue, 22 Jul 2025 20:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753215238;
	bh=n4ajkAqOBIHQzyi2y0aQC60lvk4//3JEsP+IOt0qspA=;
	h=Date:To:From:Subject:From;
	b=F8IiTeLDt8ZRL/R/PlUx/0Qx5VMEo81JjO0OCfsWx3ofU/DHDVXTYCX+9edDD7DNM
	 eNfSuCfzgHCFR7EYP1HWZ1+GFwVBQMhVTT/t6fO/Pr1RSh1t4eBqfogna66krhomQ+
	 St9wZXFBzuw/VJzQzHDawzEwd13DCMxJrclnzknU=
Date: Tue, 22 Jul 2025 13:13:57 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-missing-zsmalloc-file.patch added to mm-unstable branch
Message-Id: <20250722201358.3A8FBC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add missing zsmalloc file
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-missing-zsmalloc-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-missing-zsmalloc-file.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: MAINTAINERS: add missing zsmalloc file
Date: Tue, 22 Jul 2025 19:18:27 +0100

The mm/zpdesc.h file is only included by mm/zsmalloc.c so the zsmalloc
section seems the most appropriate place for this file.

Link: https://lkml.kernel.org/r/20250722181827.156035-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-missing-zsmalloc-file
+++ a/MAINTAINERS
@@ -27465,6 +27465,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/mm/zsmalloc.rst
 F:	include/linux/zsmalloc.h
+F:	mm/zpdesc.h
 F:	mm/zsmalloc.c
 
 ZSTD
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-check-remap-conditions-earlier-fix.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
tools-testing-selftests-add-mremap-shrink-test-for-multiple-vmas.patch
tools-testing-selftests-test-mremap_dontunmap-on-multiple-vma-move.patch
tools-testing-selftests-explicitly-test-split-multi-vma-mremap-move.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting.patch
docs-update-thp-documentation-to-clarify-sysfs-never-setting-fix.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch

