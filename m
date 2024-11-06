Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165C17BB08
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854717; cv=none; b=nVlh/RgZOm6Ij4FVOSHUQnxq2qkNnBiSoW3MLA8c0OzgDWGkIzKHqBxGfKb/qqYv0kMzsZXLDgzmebTMyAO0Adl5s50Gfz6XWQOGvvVbpbo9X9EU4AP+IcvEyl5wVhOafYdS2eM8AM2ewNpRLj3sHQlXuFKNu7J96ZBwrWVtv9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854717; c=relaxed/simple;
	bh=dwta5l4Bl3+uJ/4slERIh1lIALJwP8Umy5p/I7del9s=;
	h=Date:To:From:Subject:Message-Id; b=RxG0BGxO19Eg+GI+JCn7VWlBfcqBduqAmKFiM4tiGu9DO4uHEHiSJVLn0m2QliTfNhgSJlyiU5g9dNp6rL+LLfUL8WDBu/Qaz2KGsx27jpSMcG+2gBSFzeWtA7BNJcuHpaYpw+lMa50tabs6LkE9pLZkSR/EdpqJ+mKJjdsmu8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0tBhvo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0tBhvo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167CDC4CED1;
	Wed,  6 Nov 2024 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854717;
	bh=dwta5l4Bl3+uJ/4slERIh1lIALJwP8Umy5p/I7del9s=;
	h=Date:To:From:Subject:From;
	b=x0tBhvo2+9ZGN/X7u5AzTcaE44E3jGdEOAP80AejUIxi/nD7cwfQGiIqF2mbmSd2f
	 Z/3JjH4iAOlngEAZF2Z6VCfOvlRyF2aFNUp20WEbukUOuEMgcVdhiSQN89cRAHjHlc
	 3H3aryCHpqsba7bkTzH9hGb1fnFcPxImKM+bMdR0=
Date: Tue, 05 Nov 2024 16:58:36 -0800
To: mm-commits@vger.kernel.org,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-shrink-nrunqueued_dirty-counter-issue.patch removed from -mm tree
Message-Id: <20241106005837.167CDC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix shrink nr.unqueued_dirty counter issue
has been removed from the -mm tree.  Its filename was
     mm-fix-shrink-nrunqueued_dirty-counter-issue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: mm: fix shrink nr.unqueued_dirty counter issue
Date: Fri, 12 Jan 2024 09:23:52 +0800

It is needed to ensure sc->nr.unqueued_dirty > 0, which can avoid setting
PGDAT_DIRTY flag when sc->nr.unqueued_dirty and sc->nr.file_taken are both
zero.

Link: https://lkml.kernel.org/r/20240112012353.1387-1-justinjiang@vivo.com
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-fix-shrink-nrunqueued_dirty-counter-issue
+++ a/mm/vmscan.c
@@ -5990,7 +5990,8 @@ again:
 			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 		/* Allow kswapd to start writing pages during reclaim.*/
-		if (sc->nr.unqueued_dirty == sc->nr.file_taken)
+		if (sc->nr.unqueued_dirty &&
+			sc->nr.unqueued_dirty == sc->nr.file_taken)
 			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
_

Patches currently in -mm which might be from justinjiang@vivo.com are


