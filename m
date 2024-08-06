Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF16D82863
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 21:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722980298; cv=none; b=PrXw7rg94KanyreRFKJBHWwjBQAS/0aquKbAMaVhDrmvRMNlfGEMb6+YDEZKIUnjHS+71L33pBHPr2fdz+EIUN82vWuYn4Q7UwuzWQKl1aiODXdVB/dOUWNfF9mcE3JmzJfj7htaZL2ZKKGPz/PFAsGkeMnlupi4R9KjLfF1Uzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722980298; c=relaxed/simple;
	bh=XqEfCLgDbRwoHM7hSnJdPU+x8wqGQ2wkmFGWpBx5FkM=;
	h=Date:To:From:Subject:Message-Id; b=HaCe5Q0TmQ1WwIpP1PkLs6Ye4MTa8wx/ejBiev0QfUyRoCwodIHBxCWYrW4AuJ5V/DaTUknnxHXtId/CbTLqME67pRauxPp9g8gzZOKt8vDgjLaAlE3NU2lqylxT+0NN6pcWMe4U5Z1gkI8D6zvHml7OEpqwQ4sZE2H4oc67bjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MonIuzk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MonIuzk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD20C32786;
	Tue,  6 Aug 2024 21:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722980298;
	bh=XqEfCLgDbRwoHM7hSnJdPU+x8wqGQ2wkmFGWpBx5FkM=;
	h=Date:To:From:Subject:From;
	b=MonIuzk4jMd+S9yrR362AmgWjvGmZ7HkiD5cl2zZ5sirKhGudxdgJ4FB0sISNvtSh
	 vr1s5VXp4AoyoW9MCXDWhtMBH1MxHsvN73xwdvPiQ6ySQ7HX2wyE40Og2UcBefmGW9
	 CMLVBEbXMBecMhjBF+5HQdf1qV8aIH/bT15mazOg=
Date: Tue, 06 Aug 2024 14:38:17 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,ryncsn@gmail.com,ryan.roberts@arm.com,kaleshsingh@google.com,hughd@google.com,chrisl@kernel.org,21cnbao@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch added to mm-unstable branch
Message-Id: <20240806213818.3FD20C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch

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
From: Barry Song <21cnbao@gmail.com>
Subject: mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
Date: Mon, 5 Aug 2024 13:53:24 +1200

small folios should have nr_pages == 1 but not nr_page == 0

Link: https://lkml.kernel.org/r/20240805015324.45134-1-21cnbao@gmail.com
Signed-off-by: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix
+++ a/mm/swapfile.c
@@ -224,7 +224,7 @@ static int __try_to_reclaim_swap(struct
 
 	spin_lock(&si->lock);
 	/* Only sinple page folio can be backed by zswap */
-	if (!nr_pages)
+	if (nr_pages == 1)
 		zswap_invalidate(entry);
 	swap_entry_range_free(si, entry, nr_pages);
 	spin_unlock(&si->lock);
_

Patches currently in -mm which might be from 21cnbao@gmail.com are

mm-swap-allow-cache-reclaim-to-skip-slot-cache-fix.patch

