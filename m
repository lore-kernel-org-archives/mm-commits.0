Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680853612D8
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 20:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769891547; cv=none; b=mkjQb7c5wXN4TlVPoi/wiLfyFWdZ4bFGGin62G8kFjN937JjH0jss32GTL5S4XS0KU3Hs+AJfiOcVu2oAqzZZqomp7kllNb7OW6BgrAtjWTw1KnJtWjaUWomDRnQJu8NlVFcWk13JNECHglAaRhQJeFqbw/QwDJx5XwZ3itjb0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769891547; c=relaxed/simple;
	bh=tJeCc03h9duFVbvhUpXlHNZGnOLH2vqMt9ra7kHD2WI=;
	h=Date:To:From:Subject:Message-Id; b=fxSdtisXB2O8gxBWr9cHkZlqYBBCikJpmommivfV8dvzaCNnNA5mmjsOBLr165HUAphDkcQ3nnPVAVEy+/Acm2AJT+GTAKoMkPQpW/CPqS35NCZoOz360g4w2e940A2Cd8IuXwUyGRaSYrXGJkFa45OTAArun1acS2Gm16Sl7Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I2mcb9kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I2mcb9kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3A3C4CEF1;
	Sat, 31 Jan 2026 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769891546;
	bh=tJeCc03h9duFVbvhUpXlHNZGnOLH2vqMt9ra7kHD2WI=;
	h=Date:To:From:Subject:From;
	b=I2mcb9kdpYxQfWebS5gxDTX3QKRTO5ysOEMmYlUCuRBB1ZKhDw2CV705nbJXKWDb1
	 tUKp1WgDNhRyPOg319iVo8id016KF6iF0paM1g1PiORAnXwoUSAG644dsfu1bmt8se
	 5NqHBkhnpn7Hny9tHHWkr8YpKhCDW/vTShN7DlPM=
Date: Sat, 31 Jan 2026 12:32:26 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,yi1.lai@linux.intel.com,rafael@kernel.org,nphamcs@gmail.com,kasong@tencent.com,kartikey406@gmail.com,hannes@cmpxchg.org,clm@meta.com,clm@fb.com,chrisl@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ryncsn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch added to mm-unstable branch
Message-Id: <20260131203226.CC3A3C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-cleanup-swap-entry-management-workflow-fix-2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch

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
From: Kairui Song <ryncsn@gmail.com>
Subject: mm-swap-cleanup-swap-entry-management-workflow-fix-2
Date: Sat, 31 Jan 2026 00:48:07 +0800

fix KSM copy pages for swapoff, per Chris

Link: https://lkml.kernel.org/r/aXxkANcET3l2Xu6J@KASONG-MC4
Signed-off-by: Kairui Song <ryncsn@gmail.com>
Cc: Chris Mason <clm@meta.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lai Yi <yi1.lai@linux.intel.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-cleanup-swap-entry-management-workflow-fix-2
+++ a/mm/swapfile.c
@@ -2305,7 +2305,7 @@ static int unuse_pte(struct vm_area_stru
 		new_pte = pte_mkuffd_wp(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(folio, page);
+	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from ryncsn@gmail.com are

mm-swap-cleanup-swap-entry-management-workflow-fix-2.patch

