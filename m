Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D07C1BDC3
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824175; cv=none; b=LJbnhAqz7r5I+VPmsInTcS1gqM46B1VWj5daLwiZYnMmFGN+iFwOQPrS7mMc3HAG8e3es1KTZK1auHdNeR2XKBsOqKkDGi21BBfhb5hCXLI2EIm4CnV7GHBwjKuc9pzhnks/jllD/xK44HqQuN83v89EFbZ7ykKqy/n7cBxjzUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824175; c=relaxed/simple;
	bh=d2lJBDgPcIxVCCyY/uQgrNuU58DIWb4P354kMqCvHv0=;
	h=Date:To:From:Subject:Message-Id; b=CH0/WELcdKeYtLXhyGcKA/RPnylKY7u9qkDCy57FMbY7CP4lgK9MxUXuqJQOEKOfaCOsx0iG4LU1bZALEpVBGOuVBbXAYAlZJuwqZgCb96QxL3uBlGkpOQ8nUKP+zqOo7r5TNL3uO4GGE1ckz/eb4My2SauFXnxaEaytpqSBuVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vHZQHobf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vHZQHobf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F22DC32782;
	Fri, 12 Jul 2024 22:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824174;
	bh=d2lJBDgPcIxVCCyY/uQgrNuU58DIWb4P354kMqCvHv0=;
	h=Date:To:From:Subject:From;
	b=vHZQHobf5t+I9jWIZzhRGF/pO139rMHGRHcuMDw9o2yLV7H+6pKMTkyzpkrDIJj9J
	 PPfrn4+JHYDHzmIS7GeQq5gI/teCt1IbzKWx8ht7Z7zrZK9ymzUCp683o8shYM8l1X
	 1rswdvcqd4Iw3sR08ihFKbF9f0w2vlQZEE7fgw3M=
Date: Fri, 12 Jul 2024 15:42:53 -0700
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,sj@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch removed from -mm tree
Message-Id: <20240712224254.7F22DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix.patch

This patch was dropped because it was folded into mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
Date: Fri Jul  5 02:15:29 PM PDT 2024

improve the CONFIG_MMU=n situation, per SeongJae

Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios-fix
+++ a/mm/gup.c
@@ -3859,9 +3859,9 @@ long memfd_pin_folios(struct file *memfd
 				    next_idx != folio_index(fbatch.folios[i]))
 					continue;
 
-				folio = try_grab_folio_fast(&fbatch.folios[i]->page,
-						       1, FOLL_PIN);
-				if (!folio) {
+				folio = page_folio(&fbatch.folios[i]->page);
+
+				if (try_grab_folio(folio, 1, FOLL_PIN)) {
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlbc-undo-errant-change.patch
mm-gup-introduce-memfd_pin_folios-for-pinning-memfd-folios.patch
mm-page_counter-move-calculating-protection-values-to-page_counter-fix.patch
mm-migrate-putback-split-folios-when-numa-hint-migration-fails-fix.patch

