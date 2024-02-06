Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B11B942
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 21:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707253360; cv=none; b=j32s7E0cv4VNdj+ygg1QS+BkEuBI1aAlBTgfYUuFdAlVTJPh9VB8tDkp63f7WDufPZQgL+RKp9Ly6AhY9tIDzodYCK/ga6VV7ZX6SkKzKjjCUNUnMVMR2ghMYEoRXyr33dBdRxdzUQG733ATbIi9LSQqSdQssQux5Dpgapt+Q4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707253360; c=relaxed/simple;
	bh=7PCJqUZoSHnP6OCWLRWL0eYO6f31YRSc5sn/DLJrTO8=;
	h=Date:To:From:Subject:Message-Id; b=OOvOYnICH4Qr006/glcMNcr1VtyiKObpeevJxCjQmz3OR3gdQQGM1y0DGQEqIb5/xK+wZU50t6S8IA/OmsLsSw18j1XFUSSO3O2+R0yi80trlNFI25FQVjbdvo3LegHeMXjPX2uhaofhkD1SlfVXLRoYJ6MZouaoxb+UPjq28qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sehLNLQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sehLNLQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB91AC433C7;
	Tue,  6 Feb 2024 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707253359;
	bh=7PCJqUZoSHnP6OCWLRWL0eYO6f31YRSc5sn/DLJrTO8=;
	h=Date:To:From:Subject:From;
	b=sehLNLQdlMSs82w5g4/4UbCucIIdeuSun2WIAs4NZMNVXz/I5BWiExWVLTIMAHZH4
	 x1Q+3NBLbulDV4VwrbqEwD9lNYZx0Cg+rnXHaykDbBYDDGOvN5IulDF6ZJkfg0W+0v
	 mLFonFWCnydmPVXxfAtaRzWZwU6+HagfY+Os/EKY=
Date: Tue, 06 Feb 2024 13:02:39 -0800
To: mm-commits@vger.kernel.org,john@groves.net,hch@infradead.org,dan.j.williams@intel.com,John@Groves.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memremaph-correct-an-error-in-a-comment.patch added to mm-unstable branch
Message-Id: <20240206210239.BB91AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memremap.h: correct an error in a comment
has been added to the -mm mm-unstable branch.  Its filename is
     memremaph-correct-an-error-in-a-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memremaph-correct-an-error-in-a-comment.patch

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
From: John Groves <John@Groves.net>
Subject: memremap.h: correct an error in a comment
Date: Mon, 5 Feb 2024 18:57:37 -0600

It tried to send me off to memory_hotplug.h for an enum that is a few
lines above...

Link: https://lkml.kernel.org/r/dba0f5f01162d6fa16e4da2a9fede7f97080e92d.1707179960.git.john@groves.net
Signed-off-by: John Groves <john@groves.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memremap.h~memremaph-correct-an-error-in-a-comment
+++ a/include/linux/memremap.h
@@ -109,7 +109,7 @@ struct dev_pagemap_ops {
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @done: completion for @ref
- * @type: memory type: see MEMORY_* in memory_hotplug.h
+ * @type: memory type: see MEMORY_* above in memremap.h
  * @flags: PGMAP_* flags to specify defailed behavior
  * @vmemmap_shift: structural definition of how the vmemmap page metadata
  *      is populated, specifically the metadata page order.
_

Patches currently in -mm which might be from John@Groves.net are

memremaph-correct-an-error-in-a-comment.patch

