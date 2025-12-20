Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444D54C92
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 03:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766201306; cv=none; b=c84kIJUI5OU4+lyTzsCcEdDzd2CxQUVecbKfNOe9Vdxts7jN9p0N7GckjAOpB7mNYMjXAchTDWKgk9p1T12NpN5yBbWkL1pJtAzOsWqzmx/6BEkZtqWBSm53C3jyXDuZOIX35Hg+fEb0m174WGlp1ZpSbBM+lL+50WHyqJ1fK6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766201306; c=relaxed/simple;
	bh=sisUkT6/GEdmctdX7okM+Qce+Db50J7NUNppk8MJpoo=;
	h=Date:To:From:Subject:Message-Id; b=PIDskuq8HJhXEX2xz57yGsuoe5bZll5nw5x1xSUBXD7BCDhpzTGWFe1mDmpKtGd8otLWd16fxIrjHqUVaS9kaOCH1nWqAx3/y0YQx5J6JplQMk4TLouXNyZ/C+381qIZVMTNo7Aahlo7pHkeHo5W732pKtIIBzAKAPtV2dAK0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jf1TntQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jf1TntQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF14AC4CEF5;
	Sat, 20 Dec 2025 03:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766201305;
	bh=sisUkT6/GEdmctdX7okM+Qce+Db50J7NUNppk8MJpoo=;
	h=Date:To:From:Subject:From;
	b=Jf1TntQN3ybcvKIW++XEkw55roBPVAMfUReV7msNANa5KRFtakW52O0ryuKbZ/zvx
	 KM7BA/+Br1uS35V0o+fc/79LWdmpl2AFR+jv9vRfaWJTSlxWqmsfnOkYlAlt4ualxa
	 X+p21WwzGHb1hYV5NQis5VdnhnHFQ5vgbBykrcaM=
Date: Fri, 19 Dec 2025 19:28:24 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,a909204013@gmail.com,niuwl1@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch removed from -mm tree
Message-Id: <20251220032825.AF14AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
has been removed from the -mm tree.  Its filename was
     mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: WanLi Niu <niuwl1@chinatelecom.cn>
Subject: mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
Date: Mon, 8 Dec 2025 17:26:27 +0800

pcpu_build_alloc_info() only needs the initial upa as the starting point
for the downward search.  Storing it in max_upa and reusing it adds no
value.  Iterate from upa directly to remove the redundant local variable
without changing behavior, improving readability.

Link: https://lkml.kernel.org/r/20251208092627.5603-1-niuwl1@chinatelecom.cn
Signed-off-by: WanLi Niu <niuwl1@chinatelecom.cn>
Co-developed-by: hlleng <a909204013@gmail.com>
Signed-off-by: hlleng <a909204013@gmail.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/mm/percpu.c~mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info
+++ a/mm/percpu.c
@@ -2800,7 +2800,7 @@ static struct pcpu_alloc_info * __init _
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, best_upa;	/* units_per_alloc */
+	int upa, best_upa;	/* units_per_alloc */
 	int last_allocs, group, unit;
 	unsigned int cpu, tcpu;
 	struct pcpu_alloc_info *ai;
@@ -2817,7 +2817,7 @@ static struct pcpu_alloc_info * __init _
 	dyn_size = size_sum - static_size - reserved_size;
 
 	/*
-	 * Determine min_unit_size, alloc_size and max_upa such that
+	 * Determine min_unit_size, alloc_size such that
 	 * alloc_size is multiple of atom_size and is the smallest
 	 * which can accommodate 4k aligned segments which are equal to
 	 * or larger than min_unit_size.
@@ -2829,7 +2829,6 @@ static struct pcpu_alloc_info * __init _
 	upa = alloc_size / min_unit_size;
 	while (alloc_size % upa || (offset_in_page(alloc_size / upa)))
 		upa--;
-	max_upa = upa;
 
 	cpumask_copy(&mask, cpu_possible_mask);
 
@@ -2860,7 +2859,7 @@ static struct pcpu_alloc_info * __init _
 	 */
 	last_allocs = INT_MAX;
 	best_upa = 0;
-	for (upa = max_upa; upa; upa--) {
+	for (; upa; upa--) {
 		int allocs = 0, wasted = 0;
 
 		if (alloc_size % upa || (offset_in_page(alloc_size / upa)))
_

Patches currently in -mm which might be from niuwl1@chinatelecom.cn are


