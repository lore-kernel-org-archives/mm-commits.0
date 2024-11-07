Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D521C173
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 21:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013529; cv=none; b=cFKWiAYoy/iItLa6UKEAlPQfJ8Ag4Wzl6HxdpsNDzeGr2ZEVBXmxgsALvpwpsCoj/1iLJ8mRy2oNns+eW381y6e1QLvpz/LUBmLYckPBM7NO7nlnOXwzH8i1x1ko8wV1ZXROF73JpH4JY+Qw4rO2VCmSbjxUnQesBJ/K/uOrsOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013529; c=relaxed/simple;
	bh=sDpk6K0o8DpqTvhmz3Rg90p1kkEkCE17J/HYQRcOfdo=;
	h=Date:To:From:Subject:Message-Id; b=WPp3XCu9mPiaAzFzlmplp9xS1vd6dxL2GbHNmMc/6nCIPVoau8ORkBYpDesV+P6i3EjrPiDLEUGnXGx/VvSr6UBLSHyBLOht6MrXE7EisMZiSTvJrIjg2BoFI6hKdhQL5B57eXo/3ImARSgfAlImyYZXNHbTZRKy9p/ecHntMcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aB/PqBY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aB/PqBY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1188CC4CECC;
	Thu,  7 Nov 2024 21:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731013529;
	bh=sDpk6K0o8DpqTvhmz3Rg90p1kkEkCE17J/HYQRcOfdo=;
	h=Date:To:From:Subject:From;
	b=aB/PqBY1pkjaYxbVR4BGzjY/wHln83UNqgybEJ1E57VNsLnOMXEInSqUXCFkfCVGZ
	 ApPto8D6E9TMum/muLPc9XZ0NORL+7GE6k0Ob9X+W1ucKOxTv6S7WrUa5kSDwmYz4H
	 lH3J8MpWbTBfQ8xLt3zNr4NFPjuY27fBMSP/fJZU=
Date: Thu, 07 Nov 2024 13:05:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vivek.kasireddy@intel.com,peterx@redhat.com,osalvador@suse.de,kraxel@redhat.com,junxiao.chang@intel.com,jgg@nvidia.com,hughd@google.com,hch@infradead.org,dongwon.kim@intel.com,david@redhat.com,daniel.vetter@ffwll.ch,arnd@arndb.de,airlied@redhat.com,jhubbard@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20241107210529.1188CC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch

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
Subject: mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
Date: Wed, 6 Nov 2024 20:20:05 -0800

bypass pofs_get_folio(), per Oscar

Link: https://lkml.kernel.org/r/c1587c7f-9155-45be-bd62-1e36c0dd6923@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dongwon Kim <dongwon.kim@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Junxiao Chang <junxiao.chang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2
+++ a/mm/gup.c
@@ -2399,7 +2399,7 @@ migrate_longterm_unpinnable_folios(struc
 		 * calling folio_isolate_lru() which takes a reference so the
 		 * folio won't be freed if it's migrating.
 		 */
-		unpin_folio(pofs_get_folio(pofs, i));
+		unpin_folio(folio);
 		pofs_clear_entry(pofs, i);
 	}
 
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases.patch
mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix.patch
mm-gup-avoid-an-unnecessary-allocation-call-for-foll_longterm-cases-fix-2.patch

