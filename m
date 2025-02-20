Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC3257D
	for <mm-commits@vger.kernel.org>; Thu, 20 Feb 2025 00:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740009624; cv=none; b=PKF9LSObMvg0T+OENwLz+VVSBoMuBQYktMlc4MCoSC2YZv5fzWlu7C3iPYmpdXSiWbMvvuuzBLvZIwB1WjCU9QViRYePigI6c35FecnLlPPGJfYg600YX6OyPm8SxKMKr2AAIuGrtmiaoIEi2Vd3s0mWdvSXhO8GmnHALpn1zCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740009624; c=relaxed/simple;
	bh=kMtSXOThtSIH0/lNsPm5ZuI8fDFCJFDIpcauKLXa+Ic=;
	h=Date:To:From:Subject:Message-Id; b=hlrP8tspBUfbaDyjIC4Mt501wofLqC1sP/vyi+euxLrZKZToJXRZU3u+5VNS4R4qVvIqSptoRzDXnudvGGPTS9NpWsg9x+Hacvxt68v1qZ6TXP3o/7g3T68sOMIwtSdnEoYEEn3QPG5HVlsErjZycSTAxNTr6A6DghX7xK8xe1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WPew/5oD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WPew/5oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F461C4CED1;
	Thu, 20 Feb 2025 00:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740009623;
	bh=kMtSXOThtSIH0/lNsPm5ZuI8fDFCJFDIpcauKLXa+Ic=;
	h=Date:To:From:Subject:From;
	b=WPew/5oDCQNosIHmRTvyqel5EbqR/n7beJJlzzF+7p5/CLhm4jSu40mAbd/lm+wGg
	 o89HWrR9gTiuqQFABULbKDYKXHZnyZQDqz+vgkXVWnaxxQVwU4oQah+NTohIvFmH1n
	 YZJ1VXwIL6h8bQgI7TFwVYCt9+BrDr/zK/uT722g=
Date: Wed, 19 Feb 2025 16:00:22 -0800
To: mm-commits@vger.kernel.org,jgg@ziepe.ca,david@redhat.com,dan.j.williams@intel.com,apopple@nvidia.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-compound-zone-device-pages-fix.patch added to mm-unstable branch
Message-Id: <20250220000023.3F461C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: do not access pgmap for non zone device pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-compound-zone-device-pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-compound-zone-device-pages-fix.patch

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
From: Balbir Singh <balbirs@nvidia.com>
Subject: mm/migrate_device: do not access pgmap for non zone device pages
Date: Thu, 20 Feb 2025 10:13:37 +1100

page_pgmap() is referenced before checking if the page is a zone device
page and this triggers the warning in page_pgmap().  Refactor the code to
use the helper function after relevant checks.

Link: https://lkml.kernel.org/r/20250219231337.364133-1-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/migrate_device.c~mm-allow-compound-zone-device-pages-fix
+++ a/mm/migrate_device.c
@@ -153,14 +153,17 @@ again:
 				goto next;
 			}
 			page = vm_normal_page(migrate->vma, addr, pte);
-			pgmap = page_pgmap(page);
 			if (page && !is_zone_device_page(page) &&
 			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
 				goto next;
-			else if (page && is_device_coherent_page(page) &&
-			    (!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-			     pgmap->owner != migrate->pgmap_owner))
-				goto next;
+			else if (page && is_device_coherent_page(page)) {
+				pgmap = page_pgmap(page);
+
+				if (!(migrate->flags &
+					MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+					pgmap->owner != migrate->pgmap_owner)
+					goto next;
+			}
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-allow-compound-zone-device-pages-fix.patch

