Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD502641E8;
	Tue, 11 Mar 2025 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741718459; cv=none; b=eFPTnVBRzXLShCrwZ6J8AEI8Rv3H3fGmL4GSWOqHZirKngUqEtPmF6i3MnhwknCA1OnvsouQYmSJt/ENzXnwFM+5hYsuzD9ui7bMJW7fMu4oSl3I1uzCIEyJIB6edGfOwZ5J+VjmIGgfdob5dvn5WI4wnE0F0NMKTUO0hlDRkEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741718459; c=relaxed/simple;
	bh=TzxZ+i6NQnpZdwJkoPbcEwK/vARPBS4bw1LzaNG4Cfg=;
	h=Date:To:From:Subject:Message-Id; b=ntr8OTT0uJLBZQpY4pCUujeYikdJ+6GId5JIV04fclRvgNyP+LVaI4o06KAK8WtGv8tk0X6tm2QeAw+bgaZH8WZq80RkH93bRIOngquWszcsCLp3247TAkb4irmCnaLbLUeOEghA//1BCHKONsgC9+ftv6q+c2OrJ+01YOXJGXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IwizMPXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IwizMPXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3C9C4CEEA;
	Tue, 11 Mar 2025 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741718458;
	bh=TzxZ+i6NQnpZdwJkoPbcEwK/vARPBS4bw1LzaNG4Cfg=;
	h=Date:To:From:Subject:From;
	b=IwizMPXq8Zh5OoXRtZ3Q3GGsYK5EYfdLz/EFttmEyE5txEmCeKyDM1wlci32Bgr8y
	 lxxGByXD8xs1Bi/cJrpC9Jxu7J0nFgHJmrdREWVzt/kYlffxf/mlSR1vpLD8OyTHDk
	 oou6Rlm3tQrxFk8eo5o3irGnk3JmE5C168ZmcVBI=
Date: Tue, 11 Mar 2025 11:40:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,thomas.lendacky@amd.com,stable@vger.kernel.org,rppt@kernel.org,rick.p.edgecombe@intel.com,mgorman@techsingularity.net,farrah.chen@intel.com,david@redhat.com,ashish.kalra@amd.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch added to mm-hotfixes-unstable branch
Message-Id: <20250311184058.6E3C9C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: fix memory accept before watermarks gets initialized
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc: fix memory accept before watermarks gets initialized
Date: Mon, 10 Mar 2025 10:28:55 +0200

Watermarks are initialized during the postcore initcall.  Until then, all
watermarks are set to zero.  This causes cond_accept_memory() to
incorrectly skip memory acceptance because a watermark of 0 is always met.

This can lead to a premature OOM on boot.

To ensure progress, accept one MAX_ORDER page if the watermark is zero.

Link: https://lkml.kernel.org/r/20250310082855.2587122-1-kirill.shutemov@linux.intel.com
Fixes: dcdfdd40fa82 ("mm: Add support for unaccepted memory")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Reported-by: Farrah Chen <farrah.chen@intel.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>	[6.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized
+++ a/mm/page_alloc.c
@@ -7004,7 +7004,7 @@ static inline bool has_unaccepted_memory
 
 static bool cond_accept_memory(struct zone *zone, unsigned int order)
 {
-	long to_accept;
+	long to_accept, wmark;
 	bool ret = false;
 
 	if (!has_unaccepted_memory())
@@ -7013,8 +7013,18 @@ static bool cond_accept_memory(struct zo
 	if (list_empty(&zone->unaccepted_pages))
 		return false;
 
+	wmark = promo_wmark_pages(zone);
+
+	/*
+	 * Watermarks have not been initialized yet.
+	 *
+	 * Accepting one MAX_ORDER page to ensure progress.
+	 */
+	if (!wmark)
+		return try_to_accept_memory_one(zone);
+
 	/* How much to accept to get to promo watermark? */
-	to_accept = promo_wmark_pages(zone) -
+	to_accept = wmark -
 		    (zone_page_state(zone, NR_FREE_PAGES) -
 		    __zone_watermark_unusable_free(zone, order, 0) -
 		    zone_page_state(zone, NR_UNACCEPTED));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-page_alloc-fix-memory-accept-before-watermarks-gets-initialized.patch

