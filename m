Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D219A5588B
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 20:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723580126; cv=none; b=tZcpMstvJapPjZNo/oEIKF75DksrPzx4fozj0MPQ8/VMFQ38iejCedVyAQ1kkVHt64edL4YacmI/glfCR2/+wGPrp82IjB8O/7g9YfoJQ8deQ8NIfQkCQileWFR7rwWTn4VBleyqEebYxe+1WICYmLc3BvQQ9YXu9o/0Yv5BX8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723580126; c=relaxed/simple;
	bh=vDx/E/1I9UJsBfLL7I4R/goJGmIGPDHd38ZxEPp7UEw=;
	h=Date:To:From:Subject:Message-Id; b=RSPlzxIq7ByoUpgCeFPrxYIT4VX5yCFR7tQTrJXw606ZPReYSP5c+OXGvWditKmduRnnZ0PMKtUABtw3YLjv+VEaxHPZtOzh2IkRPRwisUo0ivZK9J2ap1Z4KzwqwJk/dk4s1Fm8os5r3koHuOuYV+Ax7T8HgOpRsoNwCj64yxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9I7eCbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9I7eCbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBEEC32782;
	Tue, 13 Aug 2024 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723580126;
	bh=vDx/E/1I9UJsBfLL7I4R/goJGmIGPDHd38ZxEPp7UEw=;
	h=Date:To:From:Subject:From;
	b=X9I7eCbbq/g46H27lvXZdJlzAu86JtC5qGYYLbtkTjN4Dey+mSXV9Ft9t8WBDRwgu
	 rFE4ZI7lWarb+rhjcfYjfB+KzZcCY6QIAPIhX7Ah+MtRl0X9CemNYVZ7GGlOCYCQEa
	 zatTD5Idq4Tg1QX9lhtYcaqTN8N/ja7ywPYSfF60=
Date: Tue, 13 Aug 2024 13:15:25 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch added to mm-unstable branch
Message-Id: <20240813201526.3CBEEC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: take folio refcount after testing the LRU flag
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch

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
From: yangge <yangge1116@126.com>
Subject: mm/swap: take folio refcount after testing the LRU flag
Date: Tue, 13 Aug 2024 17:52:23 +0800

Whoever passes a folio to __folio_batch_add_and_move() must hold a
reference, otherwise something else would already be messed up.  If the
folio is referenced, it will not be freed elsewhere, so we can safely
clear the folio's lru flag.  As discussed with David in [1], we should
take the reference after testing the LRU flag, not before.

Link: https://lore.kernel.org/lkml/d41865b4-d6fa-49ba-890a-921eefad27dd@redhat.com/ [1]
Link: https://lkml.kernel.org/r/1723542743-32179-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-swap-take-folio-refcount-after-testing-the-lru-flag
+++ a/mm/swap.c
@@ -226,12 +226,10 @@ static void __folio_batch_add_and_move(s
 {
 	unsigned long flags;
 
-	folio_get(folio);
-
-	if (on_lru && !folio_test_clear_lru(folio)) {
-		folio_put(folio);
+	if (on_lru && !folio_test_clear_lru(folio))
 		return;
-	}
+
+	folio_get(folio);
 
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
_

Patches currently in -mm which might be from yangge1116@126.com are

mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch

