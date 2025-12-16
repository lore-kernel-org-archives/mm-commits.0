Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A460272E54
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 20:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765917723; cv=none; b=fSbo2Gl137QpFoMzMOCFgKNron0LG8xC2kXlCualNqUoUE4YzFTeNpz1YqyKu3RgsvVQMT9q6wg/ZnhmqYD7sKLJzsbckr7crZ5KDbhQz3wQ/O4LoKrIKhpBMXoBSlo/wh2h2tOwVCO8nsLoEWPy7KaswepOqJ6yWMjY/Gq+65s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765917723; c=relaxed/simple;
	bh=0shF0MIdUNEYtZw5nv0xT7lDsbfqhZrvsmk2IeKlnQk=;
	h=Date:To:From:Subject:Message-Id; b=dGUktvD6E+x2YUPeWxDEEt1QBXMCLQiXtBxr3Vf0fS62HsmaP+FH7wOSDbUezRmXAduir8BQqg5V/Y8HtbFjfzzkJCOxupG0GPmjKQ7rLBm0cdJsUZ2e46CYfdztigwzVwBOGmEm5Lwud/IQD6n0h3svNHVO3WkGVQAW9/ZfpoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rLyqGtiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rLyqGtiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C33C4CEFB;
	Tue, 16 Dec 2025 20:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765917721;
	bh=0shF0MIdUNEYtZw5nv0xT7lDsbfqhZrvsmk2IeKlnQk=;
	h=Date:To:From:Subject:From;
	b=rLyqGtivGYhgTwPP9N3idnV2raxg3wKgvfiCvXCqf0o7tkojwFsiZ29HERgebrTuC
	 uoUGfTsWjN4P+gKAd7SXoVFd0nnHkMwquhqxD10Zvo34sO7ZADOu8ceeMW8GfZA9gZ
	 HwV7n7Zg7/Do/xU9UTIQ/Kipmcn/ljHTY0fAhiYw=
Date: Tue, 16 Dec 2025 12:42:00 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,a909204013@gmail.com,niuwl1@chinatelecom.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch added to mm-new branch
Message-Id: <20251216204201.A8C33C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-percpu-drop-unused-max_upa-in-pcpu_build_alloc_info.patch

