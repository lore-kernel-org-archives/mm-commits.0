Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2B27442
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 23:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712964084; cv=none; b=rrjJdMZeYFrx5csXxQ8+zpLzXkk+zFa0vza1SlUL6HuJAnxXIr3n2Mdub3FqrrtqDEJJRgMSDRbyzZZrnJj7bnqgi3rd8IR592ggsFIH6BfTxT9zc9u+N3V8UNLGyvHFoegh4TCgKWCmLwbLmofH5oqCBa16imFbFes6m9Tl44Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712964084; c=relaxed/simple;
	bh=A8SKvsqswyQq6pgniimqgFXHGHfPunDoDez9+xGINeY=;
	h=Date:To:From:Subject:Message-Id; b=pDsuUxvNEQQhGxy6dAhOR/xFP6jx8YTnfs0ViAH8zS+A4IYGLkySVtI6SpTQDk0d0N9980Cr+w7eGVM1lTfqij5+pOyX8PU9G+BO056xBfWzUwwReLcSAJPG7yNt4REP/5xKO3Q5l6m6iAy6OHf2t6S7z8nrxi4Hj4tROCPJI+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PBl3JgBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PBl3JgBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA70C113CC;
	Fri, 12 Apr 2024 23:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712964083;
	bh=A8SKvsqswyQq6pgniimqgFXHGHfPunDoDez9+xGINeY=;
	h=Date:To:From:Subject:From;
	b=PBl3JgBqOAvuLOgZwkeVct4k766yPR/kAvt8VVqU7MbDB38zDYOl4OLPH3eSRJvZy
	 zDjaqvB+wl5Js2C9QaNuFGFhyum0gw2WInpOru3uweohaNJk2NgRBSwMsIK3RwW4di
	 792aqP1AzRsXGOpoQpuZfCXHeDJXJyRBHzwwuYIA=
Date: Fri, 12 Apr 2024 16:21:22 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240412232123.9AA70C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix
Date: Fri Apr 12 04:18:11 PM PDT 2024

reflow block comment

Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix
+++ a/mm/memory-failure.c
@@ -155,14 +155,16 @@ static int __page_handle_poison(struct p
 	int ret;
 
 	/*
-	 * zone_pcp_disable() can't be used here. It will hold pcp_batch_high_lock and
-	 * dissolve_free_huge_page() might hold cpu_hotplug_lock via static_key_slow_dec()
-	 * when hugetlb vmemmap optimization is enabled. This will break current lock
-	 * dependency chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic approach because
-	 * we made sure that those pages cannot end up in any PCP list. Draining PCP lists
-	 * expels those pages to the buddy system, but nothing guarantees that those pages
-	 * do not get back to a PCP queue if we need to refill those.
+	 * zone_pcp_disable() can't be used here. It will
+	 * hold pcp_batch_high_lock and dissolve_free_huge_page() might hold
+	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
+	 * optimization is enabled. This will break current lock dependency
+	 * chain and leads to deadlock.
+	 * Disabling pcp before dissolving the page was a deterministic
+	 * approach because we made sure that those pages cannot end up in any
+	 * PCP list. Draining PCP lists expels those pages to the buddy system,
+	 * but nothing guarantees that those pages do not get back to a PCP
+	 * queue if we need to refill those.
 	 */
 	ret = dissolve_free_huge_page(page);
 	if (!ret) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch
selftests-harness-remove-use-of-line_max-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

