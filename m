Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468B633BBCD
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788299693; cv=none; b=MY9DcTEopDmrlztDLb2RpOpAlB4skOh/dfYyv91g43IwVTTR3tR+SfQeoC6ZtViP3AxjpCSrvoBYJ0jOUy8Kb5AbbbiPcuxSU4ktcTWrHaBFcHwpnuJeD8CIVWiYUUNrjtjZhQ9aqTHD5Nm/pdgyzIskS9VyaFvPxqHfxQGB1m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788299693; c=relaxed/simple;
	bh=sgV/FjssYutpJFDNCgnlGo0NqXAAyWs4ZxvHFZK1yTA=;
	h=Date:To:From:Subject:Message-Id; b=STDdCkCvnSUFFDdVnl0NSpyG8QjbWIJWqdPTbZfHsoNCCNiKxkYFt6W/l0iSni+fiw6rW4d2z7jZY78PPth8WRT6RIxFMtG5hmnsPAuVkJbM1xggME3FUW3tpTacW0iOaC2ATUISX1O/YFuIY7ppUYS7kzlB06KrNzHqWL26Z/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzeyTyFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzeyTyFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D891F000E9;
	Tue,  1 Sep 2026 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788299691;
	bh=sVo2RAHxLqnywWJEmibxFREnybBs1V1E0D9gyFxMv+A=;
	h=Date:To:From:Subject;
	b=fzeyTyFHAKvTqFwPQzaTIhWopsD0otgCcILOsuriSkVh6Jhn1L/ZH+bsXxS0PFloS
	 p9LyLF2TllPNyo0kzwHRefN23D4Dowfyx+NT/0M5fuFUROsttGsZKJWRS4f24v+w6J
	 H/2/ZnXVAiJ75m7uQhCWposyQL57Wss1JeJYYldw=
Date: Tue, 01 Sep 2026 14:54:51 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch added to mm-new branch
Message-Id: <20260901215451.C8D891F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: remove unnecessary initialization in pcpu_build_alloc_info()
has been added to the -mm mm-new branch.  Its filename is
     percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: remove unnecessary initialization in pcpu_build_alloc_info()
Date: Wed, 2 Sep 2026 01:53:02 +0900

pcpu_build_alloc_info() initializes nr_groups to 1 and unconditionally
sets it to the number of groups.  Nothing uses it in between, so the
initialization has no effect.

Remove unnecessary initialization.

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-3-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info
+++ a/mm/percpu.c
@@ -2817,7 +2817,7 @@ static struct pcpu_alloc_info * __init _
 	static int group_cnt[NR_CPUS] __initdata;
 	static struct cpumask mask __initdata;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int nr_groups = 1, nr_units = 0;
+	int nr_groups, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, best_upa;	/* units_per_alloc */
 	int last_allocs, group, unit;
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

percpu-fix-the-comment-about-which-sizes-share-a-slot.patch
percpu-remove-redundant-assignments-to-bits.patch
percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch
percpu-remove-unnecessary-return-in-pcpu_populate_pte.patch

