Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB066A8DB
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718220834; cv=none; b=oinXeiLClRjDog5HP9arMkqskwaATBq7JJUflrKliO8Ggz1BE1m4ouzq8hW1D9ojOGHkk2j5kt21biLMISY29KDyZ0ZAnXu199FCXit/mJtZqyhgTyvvvZLvZUuI/iL5TMCIPzj7ZoEz4kuM0SkVxkwNLaWk+zvAvEbu/9t6FBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718220834; c=relaxed/simple;
	bh=fHxJsLYP92/boK8qPq4vxZRfldydgmzCeSlEvx0lcpQ=;
	h=Date:To:From:Subject:Message-Id; b=EHquvneJoAgEwI7+OjWcfu3vstrolrDcTj0J0KVeX/JUtAYIFqCVOdhtTjEGWiVjBrhJOaFtjxpI1F8diQCLaO1ECljpnwgrJBBRvwr3UKg6xuDZx1UWtc58VxqnNTC0d/1y6ihwmse44+v5nP4xLQJupS4yofVtDZz748DaARo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sgbJVbTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sgbJVbTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43846C116B1;
	Wed, 12 Jun 2024 19:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718220834;
	bh=fHxJsLYP92/boK8qPq4vxZRfldydgmzCeSlEvx0lcpQ=;
	h=Date:To:From:Subject:From;
	b=sgbJVbTI0ONsXheuqgMd93KPPImlRUDt/ENLdTU0/fnm+kNlL0/YDer3lnYr3jCsu
	 8MzPddGvIbvkMOtQGX96a2cC+SwWCrI4j/3eOLA5a2Jyg+yOIOtbd8F/LugtbsyG2A
	 +tPFLZyf1l+CMfcLJlFUHuMa4srs/CnjpRBGeHVU=
Date: Wed, 12 Jun 2024 12:33:53 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-meminit_context-to-__free_pages_core-fix-3.patch added to mm-unstable branch
Message-Id: <20240612193354.43846C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix-3
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-meminit_context-to-__free_pages_core-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-meminit_context-to-__free_pages_core-fix-3.patch

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
Subject: mm-pass-meminit_context-to-__free_pages_core-fix-3
Date: Wed, 12 Jun 2024 20:31:07 +0200

add the parameter name also in the declaration

Link: https://lkml.kernel.org/r/ca575956-f0dd-4fb9-a307-6b7621681ed9@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-pass-meminit_context-to-__free_pages_core-fix-3
+++ a/mm/internal.h
@@ -605,7 +605,7 @@ extern void __putback_isolated_page(stru
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
-		enum meminit_context);
+		enum meminit_context context);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones.patch
mm-highmem-reimplement-totalhigh_pages-by-walking-zones-fix.patch
mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

