Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF08F1A3165
	for <mm-commits@vger.kernel.org>; Sat, 21 Mar 2026 02:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774060056; cv=none; b=cwjw3DI8saC7azxMUY3lM8G+C7rCjV1UFU5z5gN1TUNLwRkERUqjDZyAJU2Uqqiw34CCR69SLIsEHIw2CMYB4nngIiRvRD0TH4jWmPlyOfqaEsBWYAc2RBuBZTNEpbBXX4/Eaqk6F/Iv8+3TyCQ+uiyxxLBaopr8ZxeZ7WrLtYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774060056; c=relaxed/simple;
	bh=RHYwRmcMpw7CoWreOZqh2YKjzwhewb9cKUtKWST49NU=;
	h=Date:To:From:Subject:Message-Id; b=k9I5DcwyqksmNPGLlwPgl7UWzhfSYxS+3GMYXyTd9lL1qpFofG34JanBWkxMOyZL7wezOuwg29fzyf4v+7+NubHE2WaQrAMwcOXCqK/z6rKUYP5scXWjQfWMNzUWweyLjSWBLkb+p6pY99JEAswWD88ZMxsIMRgP4MVU0a1s1qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hkk/KyX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hkk/KyX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5767EC4CEF7;
	Sat, 21 Mar 2026 02:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774060056;
	bh=RHYwRmcMpw7CoWreOZqh2YKjzwhewb9cKUtKWST49NU=;
	h=Date:To:From:Subject:From;
	b=Hkk/KyX34mUAbH/zSLH/juVIdK8ejZAmcDKDqP/xhIwnuv1ZIUz2vccq8n+GiEDhS
	 yNTEvtnQfpDukS0P4erLhqz/ea6DR+40tMFN1CNNsD+ye35SBm9SUTwiDZKo6YsGFX
	 Wc6SnDschxLNC3b3/A0hQkAvqA/4jOpDk/mVa2rI=
Date: Fri, 20 Mar 2026 19:27:35 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-mmap_action_simple_ioremap-fix.patch added to mm-unstable branch
Message-Id: <20260321022736.5767EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-add-mmap_action_simple_ioremap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-mmap_action_simple_ioremap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-mmap_action_simple_ioremap-fix.patch

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
Subject: mm-add-mmap_action_simple_ioremap-fix
Date: Fri Mar 20 07:26:50 PM PDT 2026

fix warning

mm/util.c: In function 'mmap_action_complete':
mm/util.c:1520:9: warning: enumeration value 'MMAP_MAP_KERNEL_PAGES' not handled in switch [-Wswitch]
 1520 |         switch (action->type) {
      |         ^~~~~~

Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/util.c~mm-add-mmap_action_simple_ioremap-fix
+++ a/mm/util.c
@@ -1465,6 +1465,7 @@ int mmap_action_complete(struct vm_area_
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 	case MMAP_SIMPLE_IO_REMAP:
+	casr MMAP_MAP_KERNEL_PAGES:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
 
 		err = -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zap_page_range_single-to-zap_vma_range-fix.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-add-mmap_action_simple_ioremap-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch
decode_stacktrace-decode-caller-address-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch
a.patch
a-fix.patch

