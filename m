Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2CA2D7DF3
	for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2025 21:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812532; cv=none; b=LzVbX66wTu0ethHmKHUr73Sv/rOLBD76W/aydkptP+rIHspQ5zhTHmi1CviuWHCojiVZ94IiX3yIzFir8opzIFtz0Bn8mLU4q4fjW6Oq94v7a3vzqZTZLpjaazuwc0coL4CcSEaHAHTiE5agKzTYKeIvWD6kzeFesaQs/al3BYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812532; c=relaxed/simple;
	bh=Riv7JPazSBvC+xQEh0jU+Tuizoz/z4DQxHEm0o7DwD0=;
	h=Date:To:From:Subject:Message-Id; b=pxRcpmpZbaGJqZJxdv7LlN7h3AcwZfFpcEZkomNkdRWAf811LjMeLDLdwxaXpvn/7yjEWow7NvwQj9Mf1ntaQW4qXMru3rGgjnFivfCAE6FHi2dfkgqGbjH8D4wF0FQ5zBU1Aq/w4CbpQ9lp9wCM+nRZ2cU+Oth9v/yGqfwh4+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KRWMpCXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KRWMpCXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB18C4CEEB;
	Thu, 21 Aug 2025 21:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755812531;
	bh=Riv7JPazSBvC+xQEh0jU+Tuizoz/z4DQxHEm0o7DwD0=;
	h=Date:To:From:Subject:From;
	b=KRWMpCXozwiFtsequhX0lQn85a/UCbDzSD5EP+MDwjdEhfMrBt08I+t10vT/C833/
	 sHD/kTuos+SrFkotbYo+g+4hWc8R7Dr6bMCChaKcYw5mEYDO+zIk3LlQtiscckNl2k
	 zp8/xkntm1D0SXDplyj+G0+9Au5UrmkJkjAXseXY=
Date: Thu, 21 Aug 2025 14:42:10 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch added to mm-unstable branch
Message-Id: <20250821214211.7AB18C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: mark zswap_stored_incompressible_pages as static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/zswap: mark zswap_stored_incompressible_pages as static
Date: Thu, 21 Aug 2025 09:10:57 -0700

Only zswap.c uses zswap_stored_incompressible_pages, but it is not marked
as static.  This incurs a sparse warning that reported by kernel teset
robot.  Mark it as a static variable to eliminate the warning.

Link: https://lkml.kernel.org/r/20250821161750.78192-1-sj@kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508211706.DnJPQQMn-lkp@intel.com/
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-store-page_size-compression-failed-page-as-is-fix
+++ a/mm/zswap.c
@@ -45,7 +45,7 @@
 /* The number of pages currently stored in zswap */
 atomic_long_t zswap_stored_pages = ATOMIC_LONG_INIT(0);
 /* The number of incompressible pages currently stored in zswap */
-atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t zswap_stored_incompressible_pages = ATOMIC_LONG_INIT(0);
 
 /*
  * The statistics below are not protected from concurrent access for
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch

