Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E381F192E
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777305608; cv=none; b=eUOH0haPszvvnBmiPVtafmBKh30PJ2Yn6dW0U34YomWEkfIgV73RNH0NtKB0HgkmJ047xW5x8yrUUrNZlO12UHZlW56hPK5i5Rv/XQoZO7vmOnLx6WoyA5Zo4NJJJzDN3NQkNukGI56aGRCQAbMzMBdr6g8xBXNqDnQix+CoiKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777305608; c=relaxed/simple;
	bh=cPxpBAfs1vo1IkFjrVKMGNc2EVqozJgmLTlk5WfL23Y=;
	h=Date:To:From:Subject:Message-Id; b=MvGVX5MFw2uCPrXfWH72YFtGL7UAAJnCcBhjhMIfE2UWAJLnoY/CvE7KabixvT8Zr+HBNUd/zhxxmeO8Sis6vkDDsD7tn1CP+FNvBkCjc9XMuSAPB7/i3Ihz8wjQQvB09MRVlJcaAyfTbbBbO3hrWRXrdzpn22O4AscOWnzTqxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KwxsAltq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KwxsAltq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536DAC19425;
	Mon, 27 Apr 2026 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777305608;
	bh=cPxpBAfs1vo1IkFjrVKMGNc2EVqozJgmLTlk5WfL23Y=;
	h=Date:To:From:Subject:From;
	b=KwxsAltqZX/F3AL5ySR2WsFVTZQ9ADqrXrIybOL3kXnkOENO55NcCLybCeEwrEOcY
	 mJT1yYEu7Ckdq73fq6xAFdSkcpXg4WIahSGZtYejZfmxxoqPps7xZgpYRfKSh4hpXn
	 hrfhLBD/HI0W6WD7azjxitRusMCwGXY3ASu7A5FQ=
Date: Mon, 27 Apr 2026 09:00:07 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch removed from -mm tree
Message-Id: <20260427160008.536DAC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
Date: Mon Apr 27 06:18:51 AM PDT 2026

s/page_mapped/folio_mapped/, as page_mapped is going away

Cc: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
+++ a/mm/memory-failure.c
@@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
 		cpu_relax();
 		return page_count(p) == 0 &&
 		       !PageLRU(p) &&
-		       !page_mapped(p) &&
+		       !folio_mapped(page_folio(p)) &&
 		       !page_folio(p)->mapping &&
 		       !is_free_buddy_page(p);
 	default:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch
proc-rewrite-next_tgid-fix.patch

