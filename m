Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAED3C4567
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777465592; cv=none; b=rtutRKxePHhrSJaMRDwMJSf3IlmgnN/vyPdYpRDNAqbX5FWw6bgANqtH3NG5YygkZNIcUo60BlRus/NWUJlrZdNkvEpThp+oLriEUP/EInUFl8FKyDqhZVz+ojnljvKJmGmz4VRBRqTT5ikvizIIJ2ICfcDyXkY3/oKtSa87xuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777465592; c=relaxed/simple;
	bh=i7a6emSYPBVYWt5+2s0a6rJsm5nSKt0GQ+rtyAtgKQA=;
	h=Date:To:From:Subject:Message-Id; b=Kbo/fweXnbNbREadhBg+RM2wNVtv9ZC47Xro+CiL6WVxH9NEl3R7HIawlbHzn7mwzf4QdNRgQD/ScQv3qCTcvNtOz7G5qJ3DaEFLUNGyR+YZ5opXljPgUGJUN2NWc/VnKVt71zKXC87NIh/GIaZU26t8YWRypb6IxOcgEIEQeng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rYyg9uy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rYyg9uy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D991AC2BCC4;
	Wed, 29 Apr 2026 12:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777465591;
	bh=i7a6emSYPBVYWt5+2s0a6rJsm5nSKt0GQ+rtyAtgKQA=;
	h=Date:To:From:Subject:From;
	b=rYyg9uy70uy2bZM3uscmwsFSN85CkzI1P/2tCVQw9awfMAdYN2lyC6Is7x1ApRgGk
	 SiZIDCLU95jKJ8zsGlw5oVqi/PbRCTu/2pK+uW6lMJbuyR9fVxJNmwmAn+CKY+Zuxu
	 hk1rtyPHxxZEQrg0Ihk20JTuKASrJjEqCsRv9K/w=
Date: Wed, 29 Apr 2026 05:26:31 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch added to mm-new branch
Message-Id: <20260429122631.D991AC2BCC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm/memcontrol: hoist pstatc_pcpu assignment out of CPU loop
Date: Wed, 29 Apr 2026 16:42:16 +0800

In mem_cgroup_alloc(), the assignment of pstatc_pcpu is invariant with
respect to the for_each_possible_cpu() loop: both the 'parent' pointer and
'parent->vmstats_percpu' remain constant throughout all iterations.

The original code redundantly re-evaluated the 'if (parent)' condition and
reassigned pstatc_pcpu on every CPU iteration, then repeated the same
ternary check 'parent ?  pstatc_pcpu : NULL' when storing into
statc->parent_pcpu.

Move the single conditional assignment of pstatc_pcpu to before the loop,
resolving both the loop-invariant placement issue and the duplicated null
check.  On systems with a large number of possible CPUs, this eliminates
repeated branch evaluation with no functional change.

No functional change intended.

Link: https://lore.kernel.org/20260429084216.186238-1-hui.zhu@linux.dev
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop
+++ a/mm/memcontrol.c
@@ -4002,11 +4002,10 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg1_alloc_events(memcg))
 		goto fail;
 
+	pstatc_pcpu = parent ? parent->vmstats_percpu : NULL;
 	for_each_possible_cpu(cpu) {
-		if (parent)
-			pstatc_pcpu = parent->vmstats_percpu;
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
-		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
+		statc->parent_pcpu = pstatc_pcpu;
 		statc->vmstats = memcg->vmstats;
 	}
 
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-memcontrol-hoist-pstatc_pcpu-assignment-out-of-cpu-loop.patch

