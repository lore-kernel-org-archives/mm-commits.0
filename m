Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EB78633D
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 03:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577526; cv=none; b=gwbE7mczKH7pc3Kc5dD7eXwgKrZcJq70TC1CLr6bCNzJVQCfH5TRprQzqHullweDswJnrwTfjz8Qr0COEKzTt6TctVX+hnQ3Daj1SLPvMimULIqByTWwAn9mErFTyCYpg5W0ED45BfYwAjdFMAwTfDpg9n+OQpzNrqhm8BXW+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577526; c=relaxed/simple;
	bh=8Xboh7Nc9Bs1BsbJqqFQb5zWX5q0aOH4ObQK3KqUt+c=;
	h=Date:To:From:Subject:Message-Id; b=l5W9wjH9xTRXj4cRYCfmxrzvodsx9S+TAjs51O3GfbKIfzfp8sW/xnXSMEmYgNYcpxB6O5AiJxPhtfcDT6yzliuV2LLtLgPUjhQh4BsuzCi7U/My2yDBX/kOf7n6mxnXfPpao04fk9EswU58buzDJmjWZ0Z7fGU1hj6TbOUqGKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bbdyDhQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbdyDhQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71728C4CECD;
	Thu, 19 Dec 2024 03:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577525;
	bh=8Xboh7Nc9Bs1BsbJqqFQb5zWX5q0aOH4ObQK3KqUt+c=;
	h=Date:To:From:Subject:From;
	b=bbdyDhQI+ABdFxU1nJYD1PQkHMRw5qmpfn+DE82JUvCEAdmsk+eD2IKkc305gaG3G
	 Mxr9dwt53rfmBXgUENyuC9qvmVk2ZT0saZgYRxIy9H1WFN60F649orFtZv9ba6lqqC
	 y3opP9nu/D6qX+2KSGPySQCsLvscIo6RhAjDt23E=
Date: Wed, 18 Dec 2024 19:05:24 -0800
To: mm-commits@vger.kernel.org,oss@malat.biz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-add-rcu-annotation-to-pte_offset_map_lock.patch removed from -mm tree
Message-Id: <20241219030525.71728C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add RCU annotation to pte_offset_map(_lock)
has been removed from the -mm tree.  Its filename was
     mm-add-rcu-annotation-to-pte_offset_map_lock.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3010,7 +3010,15 @@ static inline void pagetable_pte_dtor(st
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
@@ -3023,7 +3031,8 @@ static inline pte_t *pte_offset_map_lock
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


