Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B512B3C00
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733793596; cv=none; b=AvHpN3owAtm7x03kOAzQKKaz6+t8uz/z4fFNBijexF4QD5L/S71duliFqI9hKQy0uqs860P9YjkiTP1W36Z2KA0QtJzwAEispNLYeXD8YWbnUlf6Z/ZvTpoDatojC7ZH9uWbXFSvw+xKTJUbkekJn6ZsqEfQlQNCtYIsTUA/9II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733793596; c=relaxed/simple;
	bh=ZeXcS9UL4Ro2VNe9cvUqg4cTf+FntwpcyCuu3Sn4ltg=;
	h=Date:To:From:Subject:Message-Id; b=hisk4lX7crzPhaa18jp8o9NlnsQxsOGcBwU2Ad1Mvo+37JDjn38B+g9nebseFVkbGI1PnYTzWEDZ8FhI/XWwHYTSjtyBMnHSFMiVD4S3TsiHzv55QUwLsaw66wa4ziotO97k5fQscZ6NzDnbaBwNSlj6ycJL3tn1h9qoaSb5qJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xk5bMj4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xk5bMj4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3707AC4CED1;
	Tue, 10 Dec 2024 01:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733793596;
	bh=ZeXcS9UL4Ro2VNe9cvUqg4cTf+FntwpcyCuu3Sn4ltg=;
	h=Date:To:From:Subject:From;
	b=Xk5bMj4tGIZlCYpfeIqimfP84LtvyGW2K240TXNMQB4GHFik6wD32HvK3RQsqGfNe
	 CU6xaEcPq2KBIPP4+GO6efESgJ3jjs1GCnwbquuCNhdFzRf05nOGX+k/6q4zDQSi4C
	 LlphuZss+IoVRlckmguk1j5fjqqCYikVdYctyrsE=
Date: Mon, 09 Dec 2024 17:19:55 -0800
To: mm-commits@vger.kernel.org,oss@malat.biz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-rcu-annotation-to-pte_offset_map_lock.patch added to mm-hotfixes-unstable branch
Message-Id: <20241210011956.3707AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add RCU annotation to pte_offset_map(_lock)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-add-rcu-annotation-to-pte_offset_map_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-rcu-annotation-to-pte_offset_map_lock.patch

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
From: Petr Malat <oss@malat.biz>
Subject: mm: add RCU annotation to pte_offset_map(_lock)
Date: Tue, 10 Dec 2024 01:06:04 +0100

RCU lock is taken by ___pte_offset_map() unless it returns NULL.  Add this
information to its inline callers to avoid sparse warning about context
imbalance in pte_unmap().

Link: https://lkml.kernel.org/r/20241210000604.700710-1-oss@malat.biz
Signed-off-by: Petr Malat <oss@malat.biz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |   13 +++++++++++--
 mm/pgtable-generic.c |    2 +-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-add-rcu-annotation-to-pte_offset_map_lock
+++ a/include/linux/mm.h
@@ -3011,7 +3011,15 @@ static inline void pagetable_pte_dtor(st
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
-pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
+pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
+static inline pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr,
+			pmd_t *pmdvalp)
+{
+	pte_t *pte;
+
+	__cond_lock(RCU, pte = ___pte_offset_map(pmd, addr, pmdvalp));
+	return pte;
+}
 static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 {
 	return __pte_offset_map(pmd, addr, NULL);
@@ -3024,7 +3032,8 @@ static inline pte_t *pte_offset_map_lock
 {
 	pte_t *pte;
 
-	__cond_lock(*ptlp, pte = __pte_offset_map_lock(mm, pmd, addr, ptlp));
+	__cond_lock(RCU, __cond_lock(*ptlp,
+			pte = __pte_offset_map_lock(mm, pmd, addr, ptlp)));
 	return pte;
 }
 
--- a/mm/pgtable-generic.c~mm-add-rcu-annotation-to-pte_offset_map_lock
+++ a/mm/pgtable-generic.c
@@ -279,7 +279,7 @@ static unsigned long pmdp_get_lockless_s
 static void pmdp_get_lockless_end(unsigned long irqflags) { }
 #endif
 
-pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
+pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 {
 	unsigned long irqflags;
 	pmd_t pmdval;
_

Patches currently in -mm which might be from oss@malat.biz are

mm-add-rcu-annotation-to-pte_offset_map_lock.patch

