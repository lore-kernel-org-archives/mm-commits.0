Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EF63CBE7E
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068085; cv=none; b=c/zDL3BYkJK2pjurPYaREGEABLz1sPgN6FpQPonYt8nSojqW2HaW84w7NikQf49oxQPyT+T38GxB/zKTaodajYSaXOMD/zZKjOtN89YCd4UGeIdfVWFT7JscV38WT3PqlRtwkz+CEmUNr0JeXjFkqT5F8xM+vj38Jo4UPmW4q8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068085; c=relaxed/simple;
	bh=9kGShLVQaA4ZyBqM8Tg2KzPhHLeuNhtwhSME+7XqHiY=;
	h=Date:To:From:Subject:Message-Id; b=jalpXOIKPh0EpCVoouAagLqDXBbR/TCYkQgGz9SwBcpYInKbWSj1ag+FE+iSF7nl9jaihPh/C5mwyyKgu4ubK4eShXb38uAX2LzGx7liEeIxS5Z3Vn7mmRaOJ/PauVsEB9T7EVrtX7pztiU45ZGkH3mSdd69AXqkQGSVcgXCtZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2nnN3SU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2nnN3SU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FC11F00A3A;
	Fri,  7 Aug 2026 02:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068082;
	bh=6QSGwu/eAN1yb9j2u5sUavbQZ7pgfvPum1L2aqVeIWw=;
	h=Date:To:From:Subject;
	b=X2nnN3SUcnPXrPaT0w1wHt185C6mS8ef9xSiB7spFGVETIZqsGtzb1iYfIwhg6/P/
	 iPaUO8buxuvvIwHV1IdmhP0SVojA7ZCVxTaAkYViy0ykAKFdIg9ZABAB+1x4mpBO8Z
	 Jkzwmtqv8X9pKyOnrIn3RxVyT6mRnbTAN8E3PQfA=
Date: Thu, 06 Aug 2026 19:01:22 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,sj@kernel.org,rdunlap@infradead.org,ljs@kernel.org,david@kernel.org,corbet@lwn.net,manuelebner@mailbox.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-fix-braces.patch removed from -mm tree
Message-Id: <20260807020122.96FC11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs/mm: fix braces
has been removed from the -mm tree.  Its filename was
     docs-mm-fix-braces.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Manuel Ebner <manuelebner@mailbox.org>
Subject: docs/mm: fix braces
Date: Mon, 29 Jun 2026 18:11:56 +0200

Correct typos in mm documentation by balancing parentheses.

Link: https://lore.kernel.org/20260629161156.90213-2-manuelebner@mailbox.org
Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Vishal Moola <vishal.moola@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/hmm.rst           |    2 +-
 Documentation/mm/process_addrs.rst |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/hmm.rst~docs-mm-fix-braces
+++ a/Documentation/mm/hmm.rst
@@ -349,7 +349,7 @@ between device driver specific code and
    system memory and device private memory.
 
    One of the first steps migrate_vma_setup() does is to invalidate other
-   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
+   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
    ``mmu_notifier_invalidate_range_end()`` calls around the page table
    walks to fill in the ``args->src`` array with PFNs to be migrated.
    The ``invalidate_range_start()`` callback is passed a
--- a/Documentation/mm/process_addrs.rst~docs-mm-fix-braces
+++ a/Documentation/mm/process_addrs.rst
@@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!
 
 Since it is assumed that all such steps have been taken, page table entries are
 cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
-:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
+:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
 
 .. note:: It is possible for leaf page tables to be torn down independent of
           the page tables above it as is done by
_

Patches currently in -mm which might be from manuelebner@mailbox.org are


