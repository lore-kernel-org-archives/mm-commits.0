Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727001519B2
	for <mm-commits@vger.kernel.org>; Sun, 23 Feb 2025 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740281998; cv=none; b=AGZKR1ccq+258tqJPaWUns0Zx8RETJAwndVK/zI63hPgi0JcKNCbLw3tKNKWJ39su4xAD92sLkHIQ6YyTmfmxcr9+2bv7uOPQd22qet3IjpHxJENk/wBuFRcUthzbhLQc0Tt/X8x10oba8G0q/oOXIAxD5TqO9Xi6xyBVtBkeCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740281998; c=relaxed/simple;
	bh=Zt1GU3KaHvgEXtcBWBjP1146vk/wmt0sb0DchbMhiX4=;
	h=Date:To:From:Subject:Message-Id; b=fDLYLYlRu3vfM4rtEUHplnkC19ynsG4wIqR5HfMz0al+i2IZkDkFgpiSS3v2vHO/orTzA8UAsN8uVgFSnmGicbcEGwQsfZRWKlK5mqmy7vdoHJVhDYi69rD9/kOsLJ643rA5txrg0WCYR8T4nOxIj10GYk/IN8rPeq15lDIV8kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f6ch3HZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f6ch3HZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D498EC4CEDD;
	Sun, 23 Feb 2025 03:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740281997;
	bh=Zt1GU3KaHvgEXtcBWBjP1146vk/wmt0sb0DchbMhiX4=;
	h=Date:To:From:Subject:From;
	b=f6ch3HZVWtPukryjuqbScMIOWMEHVV7OhkwBwel9Qqw63ehPesmZkY6hM+dmOlwax
	 EKwoWZtLeAnJwTQ0oAIb9IIE41HcjZSY3Fy9XGaYZOYNWLzwiHnZ1jkhaciB2Uphf8
	 D8yavAb6Rs9ZA4+2S6OjSTFVDqF809Ev8vg40xzI=
Date: Sat, 22 Feb 2025 19:39:57 -0800
To: mm-commits@vger.kernel.org,jgg@ziepe.ca,david@redhat.com,dan.j.williams@intel.com,apopple@nvidia.com,balbirs@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-compound-zone-device-pages-fix-fix.patch added to mm-unstable branch
Message-Id: <20250223033957.D498EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-allow-compound-zone-device-pages-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-compound-zone-device-pages-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-compound-zone-device-pages-fix-fix.patch

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
Subject: mm-allow-compound-zone-device-pages-fix-fix
Date: Fri, 21 Feb 2025 12:27:49 +1100

 - Add {} around the if statement as per coding style
 - Add Reviewed-by/Acked-by tags

Link: https://lkml.kernel.org/r/20250219231337.364133-1-balbirs@nvidia.com
Link: https://lkml.kernel.org/r/20250221012749.506513-1-balbirs@nvidia.com
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate_device.c~mm-allow-compound-zone-device-pages-fix-fix
+++ a/mm/migrate_device.c
@@ -154,9 +154,9 @@ again:
 			}
 			page = vm_normal_page(migrate->vma, addr, pte);
 			if (page && !is_zone_device_page(page) &&
-			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM))
+			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 				goto next;
-			else if (page && is_device_coherent_page(page)) {
+			} else if (page && is_device_coherent_page(page)) {
 				pgmap = page_pgmap(page);
 
 				if (!(migrate->flags &
_

Patches currently in -mm which might be from balbirs@nvidia.com are

mm-allow-compound-zone-device-pages-fix.patch
mm-allow-compound-zone-device-pages-fix-fix.patch

