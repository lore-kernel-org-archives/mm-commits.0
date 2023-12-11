Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C023B8
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vs30h4M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394A0C433C7;
	Mon, 11 Dec 2023 00:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256046;
	bh=EYzPr8Hbf4qg5mXzONBnRm3yVY+nqqE7sEmhci8EdAc=;
	h=Date:To:From:Subject:From;
	b=Vs30h4M+UZHUbw1bNFNoJSTxBhEET2VbhUsqIAYnyV+WMAP3O3orZDPHDnFYE6DK8
	 gytLD1uVW5ldK2xr/n0I3pEfj7q3Vc6wKpP4rW6AP9dELQr4cMiMBldooszJVXJ3X7
	 TIZdxXMMnZnsyF4IXR01uz0uaBC/qLIzuNyda+vs=
Date: Sun, 10 Dec 2023 16:54:05 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,duminjie@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-increase-usage-of-folio_next_index-helper.patch removed from -mm tree
Message-Id: <20231211005406.394A0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/filemap: increase usage of folio_next_index() helper
has been removed from the -mm tree.  Its filename was
     mm-filemap-increase-usage-of-folio_next_index-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Minjie Du <duminjie@vivo.com>
Subject: mm/filemap: increase usage of folio_next_index() helper
Date: Tue, 7 Nov 2023 10:46:34 +0800

Simplify code pattern of 'folio->index + folio_nr_pages(folio)' by using
the existing helper folio_next_index() in filemap_get_folios_contig().

Link: https://lkml.kernel.org/r/20231107024635.4512-1-duminjie@vivo.com
Signed-off-by: Minjie Du <duminjie@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-increase-usage-of-folio_next_index-helper
+++ a/mm/filemap.c
@@ -2173,7 +2173,7 @@ update_start:
 
 	if (nr) {
 		folio = fbatch->folios[nr - 1];
-		*start = folio->index + folio_nr_pages(folio);
+		*start = folio_next_index(folio);
 	}
 out:
 	rcu_read_unlock();
_

Patches currently in -mm which might be from duminjie@vivo.com are


