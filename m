Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514A216458
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848861; cv=none; b=QmTX7z8dsK0UL5gzmqfthjudL3TLpmGUrXeZSDHkXGyuVRmpSpZv9tf5YDxVA6QGBTdvM94hiV4X58gV7JbMSfgJqWSQDDnuWx5CrcP37xdzKSqWsMHJB/piEEBXiOPRrwhOF3MhG9Ta//cFIcauKywKAztwQDgP+vpdztpoCIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848861; c=relaxed/simple;
	bh=I/9ZVeWLc+dpjX4toSv+EYtuSXhfFKz+OpRY1N42pKQ=;
	h=Date:To:From:Subject:Message-Id; b=g+RmLyU1fkM2HIBe/Z6dH5a8dub56oE+mB8aCKcMckoa9rR91QsOL8gvxuLuWnpgTYwWQVoI8B++8o1M3u1N5GHPpnI7/vy43NZSSAXxRG3BRtCY84xgas73UdLY0SiN0R80njUAtIn24xck1VaYWtSGNYOOBglzDA0r0ZJSiRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RKscwv6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RKscwv6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14763C4CECF;
	Tue,  5 Nov 2024 23:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730848861;
	bh=I/9ZVeWLc+dpjX4toSv+EYtuSXhfFKz+OpRY1N42pKQ=;
	h=Date:To:From:Subject:From;
	b=RKscwv6hw/5SMNQp4SxCacXw/imkNYD1UzrRDrJlEwbdXYdmGUelw+3qKVF8luSlb
	 qqPdH3vyFaUr0Y/nbaCAvQXTKtU3mR0rqYGeOVMugAcxcB9D05Y3lfrlXqW1TQmT09
	 PVIi/rhDOVwZBMFflahxoVOgnWilmUEwIThxzkZ0=
Date: Tue, 05 Nov 2024 15:21:00 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241105232101.14763C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
Date: Tue, 5 Nov 2024 13:31:01 -0800

whitespace tweak, per David

Link: https://lkml.kernel.org/r/131cf9c8-ebc0-4cbb-b722-22fa8527bf3c@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix
+++ a/mm/gup.c
@@ -2435,8 +2435,8 @@ check_and_migrate_movable_pages_or_folio
 	LIST_HEAD(movable_folio_list);
 	unsigned long collected;
 
-	collected =
-		collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
+	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
+						       pofs);
 	if (!collected)
 		return 0;
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch
mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch
kaslr-rename-physmem_end-and-physmem_end-to-direct_map_physmem_end.patch

