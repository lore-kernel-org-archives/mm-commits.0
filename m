Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00D85B201
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307030; cv=none; b=M31MNlFpG6CFWnal+k/Kz0FffA31APetAYfSts2Fb7heSIzAbzlliraMhk3lQG97hBm9rUqcxkLBHX3ni+ebpagxj5zhkbT/nVU1wZVkSKaKrh7ejDMkR9RChG7Q2yBqOkclFZsHqFsZb1LdRqqxq8zqV2YfmyrKnW9+9qsFqfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307030; c=relaxed/simple;
	bh=O+PD1klmuB3YSUn0aBIIHikC9RlenXu0uaxOo2bomtk=;
	h=Date:To:From:Subject:Message-Id; b=Q0yOHwyLpvTOnvVwF36T3Ip1Wk8+zFMyIJq1qTfqU1NVqaji+kcp41Z4WeGwC7Dq8sh/Qn+Loia5XLx3DhMUGHNrvCsVuQCHFYeBx0ZqGv8lZPi1oh1/uxqt8FaUN2J6G/813tDinHwZBRp+c/r7kyysoPJQDt9X9+ertuoSO9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Kc9sdAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Kc9sdAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2EEBC113CE;
	Tue, 16 Apr 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307029;
	bh=O+PD1klmuB3YSUn0aBIIHikC9RlenXu0uaxOo2bomtk=;
	h=Date:To:From:Subject:From;
	b=2Kc9sdATjUU88JQm3hHurV30j+nTUJvBvrEQwZglsuZ0D4uMkoyc9ecUE81qnzNkh
	 IK7sJv9XCu4cDtssAJFfAG5oiT7JlRw2wdaswnrL+FKNaOhZQ8U145VFsvUJNauCkZ
	 +j4VfS6CgEI0QBm21/DjeIWDb75LoAbFENzhrIvc=
Date: Tue, 16 Apr 2024 15:37:09 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch removed from -mm tree
Message-Id: <20240416223709.B2EEBC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled-v2-fix.patch

This patch was dropped because it was folded into mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch

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

mm-memory-failure-fix-deadlock-when-hugetlb_optimize_vmemmap-is-enabled.patch
bootconfig-use-memblock_free_late-to-free-xbc-memory-to-buddy-fix.patch
selftests-harness-remove-use-of-line_max-fix.patch
selftests-harness-remove-use-of-line_max-fix-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
mm-hugetlb-rename-dissolve_free_huge_pages-to-dissolve_free_hugetlb_folios-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

