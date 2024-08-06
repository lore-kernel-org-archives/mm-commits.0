Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF4157487
	for <mm-commits@vger.kernel.org>; Tue,  6 Aug 2024 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722978481; cv=none; b=BReGGs6M0OnQl18p6HcG0OkzbaLvld4Aagg3Iubgg8k3sNBDbkEWDWUjrgP5iSsQjbct0QymKanWGWErAglWr9S7qAQK5PYnsJOHvi3PfyZxgTfh58WMRuor0bHpGNLZ0kARAJra+tUbORCkdA7nuSZoErp55vbp6wU6iwDY3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722978481; c=relaxed/simple;
	bh=+SB4Q9vyimJPgAd3TB5TubI8Uf1wlgOEMd86QdI6WaY=;
	h=Date:To:From:Subject:Message-Id; b=qlKuYS4BvjMg3LxnsQR9/of8DIUvQ/RHIXYcz7Edum4xtWf2WgC9SL45oOjxEw7hAOOa1ZewjgjZh+Lt8pBxBXB98KYVis+lkcvNfLFp7w1E8b1dNqiRasRVzhzqqqRWLFExcODMZvYmdm5uhTQiQmoCBdb3NTHaOPbZ2+yVckY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HWjnMY5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HWjnMY5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEACC32786;
	Tue,  6 Aug 2024 21:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722978481;
	bh=+SB4Q9vyimJPgAd3TB5TubI8Uf1wlgOEMd86QdI6WaY=;
	h=Date:To:From:Subject:From;
	b=HWjnMY5rus0jc4o8l73Zh+Z5rp5+hu0/J3npOQn4JlOR4eFjl2Glcf0WANWmTfnqp
	 S5bM4XtTcg48Nc7vfZyVyzGBZiOjuUPb0AWyJyOlT2VOEUi2CXfJV7a5KjFYwFKIZh
	 4YIIaUztFMvZLZjc+S8iX99/34LcZE6nt3jWad94=
Date: Tue, 06 Aug 2024 14:08:00 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,yuzhao@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-remove-boilerplate-fix.patch added to mm-unstable branch
Message-Id: <20240806210801.4EEACC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-swap-remove-boilerplate-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-remove-boilerplate-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-remove-boilerplate-fix.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mm-swap-remove-boilerplate-fix
Date: Sun, 4 Aug 2024 15:36:31 -0600

handle zero-length local_lock_t

Link: https://lkml.kernel.org/r/Zq_0X04WsqgUnz30@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-remove-boilerplate-fix
+++ a/mm/swap.c
@@ -254,7 +254,7 @@ static void __folio_batch_add_and_move(s
 		folio,										\
 		op,										\
 		on_lru,										\
-		offsetof(struct cpu_fbatches, op) > offsetof(struct cpu_fbatches, lock_irq)	\
+		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
 	)
 
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-hugetlb_vmemmap-dont-synchronize_rcu-without-hvo.patch
mm-swap-reduce-indentation-level.patch
mm-swap-rename-cpu_fbatches-activate.patch
mm-swap-fold-lru_rotate-into-cpu_fbatches.patch
mm-swap-remove-remaining-_fn-suffix.patch
mm-swap-remove-boilerplate.patch
mm-swap-remove-boilerplate-fix.patch

