Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D622468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gjqCHloE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3A8C433C8;
	Mon, 11 Dec 2023 00:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256121;
	bh=yVyve6BHrWenoKwfIXvo2rVDsjKPf0RexYOjvGwinWU=;
	h=Date:To:From:Subject:From;
	b=gjqCHloEmm8QZpUcNY84fumPABE7x4csqyKILE2ALW134tpVJL1QSxdYDxNyr7Szi
	 mJzFkrnVdvJ8B/xyr5w1jc611roH41iKzfpsFa+2M1mVVTgbfJLYTrZYWtSJ44Z9W1
	 hkqDj8rPOg6/mJYIs6/sqblAqgZnruDVEERcDhW8=
Date: Sun, 10 Dec 2023 16:55:20 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,fancer.lancer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch removed from -mm tree
Message-Id: <20231211005520.EB3A8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: append newline to the unavailable ranges log-message
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm/mm_init.c: append newline to the unavailable ranges log-message
Date: Wed, 22 Nov 2023 21:24:04 +0300

Based on the init_unavailable_range() method and it's callee semantics no
multi-line info messages are intended to be printed to the console.  Thus
append the '\n' symbol to the respective info string.

Link: https://lkml.kernel.org/r/20231122182419.30633-7-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message
+++ a/mm/mm_init.c
@@ -827,7 +827,7 @@ static void __init init_unavailable_rang
 	}
 
 	if (pgcnt)
-		pr_info("On node %d, zone %s: %lld pages in unavailable ranges",
+		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
 }
 
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are


