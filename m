Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF127291F
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739317273; cv=none; b=DqtVUFzEux8hUoH70bfvqOTuOsuIQ+CQnbog6bYiW1RR4ERi1G6/vQOn/IoLDKcueTctOLsaoNhrEuAEbk5i4NUcDi8QFN2Vm0urmdfglR32K6cBAK1NxPJF49z7pE3Xlk/7xvGkQaHtUhZ0wFDk/YP2ZR5uw7gdfI4lgUlURnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739317273; c=relaxed/simple;
	bh=lqGiIizdczi5C8Rf17aJv/RfJlC/8eoPhVFfrfgFx6c=;
	h=Date:To:From:Subject:Message-Id; b=ZZKtcYEl8TSiAEPdSzA9yymAfeI0afNkEOE09vMJJ+n5l7s6wsjavXt20ehI3wj/yAErJ1SYn+Epq+EKiH0/8s0DxXU0LCaoKxkBsoskDWWx5QJpKUokGHUTV0sKwecLwlpks4H/lmEtrhswNW1fB9MJsO41MMaex9p0IoNmXbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e0d7t1LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e0d7t1LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97092C4CEDD;
	Tue, 11 Feb 2025 23:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739317272;
	bh=lqGiIizdczi5C8Rf17aJv/RfJlC/8eoPhVFfrfgFx6c=;
	h=Date:To:From:Subject:From;
	b=e0d7t1LLk/zZ4lTu5Cx+0AWGUXWwj91pIIwzqpi+RuzZ86grPZuoWw+O10OFNcp/Q
	 8HXLOrv9HPh71wkRSUjggS1DNNVzXbK0JGBX6FMpDDLoA8QNdkYauJ1rp1z7ohTu5i
	 pVNPVt4lobztk+BispBYb+zPEYeoEK1P8Ch2dXBk=
Date: Tue, 11 Feb 2025 15:41:12 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch added to mm-unstable branch
Message-Id: <20250211234112.97092C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix
Date: Tue, 11 Feb 2025 09:33:04 +0100

define `folio' in nouveau_atomic_range_fault()

Link: https://lkml.kernel.org/r/48fd75b9-696e-402c-95bd-55f2f0e24dfc@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/nouveau_svm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/nouveau/nouveau_svm.c~mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix
+++ a/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -590,6 +590,7 @@ static int nouveau_atomic_range_fault(st
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
 	struct mm_struct *mm = svmm->notifier.mm;
+	struct folio *folio;
 	struct page *page;
 	unsigned long start = args->p.addr;
 	unsigned long notifier_seq;
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate_device-dont-add-folio-to-be-freed-to-lru-in-migrate_device_finalize.patch
mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive-fix.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch

