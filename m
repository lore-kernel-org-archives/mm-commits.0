Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832460;
	b=n1eCxfBSvtivh21bGj8IYGMvcEmVBSdhD3AGK64+Q6qEYC2waGamk8y96Wlg3zSNiTAj
	 4Qqw3CXhjzbwvL0Zl4dN9Y52eWRrZsVQkI20vi5J34mDdOVVDK2CXVx6/+3rj2wcF6GKS
	 Q7G95M+uweWFjLemzs4ITrs0IHAG/EHIZ/afuHNuQ3blBZ4nFOtFwTgY+D43rGlGIYjJb
	 x7AOsvr69u9nIHCjjBTv3l4RG4ZSqsbgx5Ja858PqACxx/kfy5UwVXd6veNHTBo79WvId
	 hdeawbFgn10kQ/MoMlKoMX7tUHGsLlozt5PXNyu7Sfr2HYLSCX0mjEdGLq8qU4yfkfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832460;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iCH2h0+xrXcDEgiAF8jxq8uMPmqKTz6UduxHaxCecfE=;
	b=dIEeM5lqDKBWdKX0+HH7Jdf4njyn+KPo5qeq66p3Rk0FbkltkKTJ6SiGQBo8BvlVe/is
	 pwm2txJq7YB0YYaDbx3SfOYXctQiFqTiqxXXHHtZkt7kr9Y7fsRY8+B8MqZmcp06sPiZe
	 Ll7pWhGKnbUwDgNOhDX0fOyi0XdT6KNFqmP4ugddyPNH8uhW5RWmpur/IVLwmLGU7W9PW
	 Rh25k4z9qlfb1tQstzZOg8M813FUOX5iMbIJPfnqxc87oMVllDbxMiI/H4SD2HNbDnDwX
	 kmhKkSd3Tc+Mgxb1MerHcl/Z2m/NH/8bCDCSjh3sL5OEqLII1aEi1pL2RYKRwb8KPKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PzboaTx1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E3606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PzboaTx1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868E21F01825;
	Sat, 24 Oct 2026 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832459;
	bh=iCH2h0+xrXcDEgiAF8jxq8uMPmqKTz6UduxHaxCecfE=;
	h=Date:To:From:Subject;
	b=PzboaTx1V5OjZikCQYW6en/VHcLVOHkZsSp7DHDZ1WGd1sYtB3powoqqNiOobJlPw
	 RoI/3QFSx05tk6LFGP6I+7ARA0Cya5ERNQxEwDKikPRTaV5j+qwbv3PKINmtBjX3LP
	 lRRXJ6J/giYSQosM+t017IzzMiHvEqhwZFR0vXKo=
Date: Sat, 24 Oct 2026 02:00:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch removed from -mm tree
Message-Id: <20261024090059.868E21F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon: use damon_get_monitor_folio() for hugetlb entries
has been removed from the -mm tree.  Its filename was
     mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/damon: use damon_get_monitor_folio() for hugetlb entries
Date: Mon,  5 Oct 2026 23:52:06 -0700

Hugetlb folio acquisition is open-coded in three places:
  - damon_hugetlb_mkold()
  - damon_young_hugetlb_entry()
  - damon_va_probe_hugetlb_entry()

DAMON already has damon_get_monitor_folio(), which paddr uses to get
monitored LRU and hugetlb folios and to filter them through
damon_folio_acceptable().  These paths bypass that check.

Use that helper in these paths too, so that DAMON acquires hugetlb folios
and applies its acceptance policy in one place.

No functional change intended.  All callers reach these paths with a
present hugetlb PTE under the page table lock, so the folio is always a
mapped hugetlb folio and the helper always returns it.

Link: https://lore.kernel.org/20261006065209.41507-3-sj@kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
---

 mm/damon/ops-common.c |    6 ++++--
 mm/damon/vaddr.c      |   10 ++++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries
+++ a/mm/damon/ops-common.c
@@ -140,9 +140,11 @@ void damon_hugetlb_mkold(pte_t *pte, str
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(mm, addr, pte);
-	struct folio *folio = pfn_folio(pte_pfn(entry));
+	struct folio *folio;
 
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		return;
 
 	referenced = damon_hugetlb_ptep_mkold(pte, mm, vma, addr, &entry);
 	if (mmu_notifier_clear_young(mm, addr,
--- a/mm/damon/vaddr.c~mm-damon-use-damon_get_monitor_folio-for-hugetlb-entries
+++ a/mm/damon/vaddr.c
@@ -411,8 +411,9 @@ static int damon_young_hugetlb_entry(pte
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
@@ -660,8 +661,9 @@ static int damon_va_probe_hugetlb_entry(
 	if (!pte_present(entry))
 		goto out;
 
-	folio = pfn_folio(pte_pfn(entry));
-	folio_get(folio);
+	folio = damon_get_monitor_folio(pte_pfn(entry));
+	if (!folio)
+		goto out;
 	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
 			walk->vma->vm_mm);
 	folio_put(folio);
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-page_alloc-let-the-highest-memory-node-recover-from-hopeless-state.patch

