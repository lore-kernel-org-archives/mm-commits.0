Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6075320A14
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334360; cv=none; b=c9S2N95yJXUaUO7BAdQN8j9+Oql/+yiXcEdxwueIemSGtB8LP66ZUPVLjeaRaNzlKEMxoC0zKSO5hNHnE2T8w6tlzLvnH/Jh+5hF5OUm/Y82fdGCIoxY9c8TnkrM8YD/DGJAZtsJ/YN3dYdqgWSRYfiVUcwv/rUVzIhK1pBGkDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334360; c=relaxed/simple;
	bh=R9lRqrWm/3107S7ILFS7HiEOjkgee6wyJn+8G4O9T2g=;
	h=Date:To:From:Subject:Message-Id; b=GJDm3rxzNqZQhdf9ylw8/eJxWqgPC/q+w10blP1IFrCOII95V0VL4Yr+2zejwMD2KrIdefLCDQVXap/I4IyLhyO4gOP4GIH9rI5jWlLRJviiws8Oo/LVpWn/wUSL5nmD4n2Nh3h2PYz6kRbSchk+/lpIV264rfXzn9SbjOqoDYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPxgNpUn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPxgNpUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1F91F0089B;
	Wed,  7 Oct 2026 00:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334359;
	bh=NZ0g31/4LKcpsfxFl6cyDkoevt0/k+N8KZD73d5FEZQ=;
	h=Date:To:From:Subject;
	b=FPxgNpUn9eCypzQbqeTaL4bzozFeEBwvOykOyBGbh2nlQHWFX/qfiqPXG6TglGYeU
	 gstrYU7dHAupLH4z2s+jkn1iHl2jsrRLx5ZgCNbUXC4L+IrqMQd7rJeXsMVSQ+MKEy
	 I1J8yNWJPZmrJsLO/6wBuYB/985/PJ3cp3tj6nsc=
Date: Tue, 06 Oct 2026 17:52:39 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch removed from -mm tree
Message-Id: <20261007005239.AD1F91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
has been removed from the -mm tree.  Its filename was
     percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: percpu: remove unnecessary cpumask_clear() in pcpu_build_alloc_info()
Date: Wed, 2 Sep 2026 01:53:03 +0900

pcpu_build_alloc_info() clears mask and unconditionally sets it to
cpu_possible_mask.  Nothing uses it in between, so cpumask_clear() has no
effect.

Remove unnecessary cpumask_clear().

No functional change.

Link: https://lore.kernel.org/20260901165307.1026248-4-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---

 mm/percpu.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/percpu.c~percpu-remove-unnecessary-cpumask_clear-in-pcpu_build_alloc_info
+++ a/mm/percpu.c
@@ -2828,7 +2828,6 @@ static struct pcpu_alloc_info * __init _
 	/* this function may be called multiple times */
 	memset(group_map, 0, sizeof(group_map));
 	memset(group_cnt, 0, sizeof(group_cnt));
-	cpumask_clear(&mask);
 
 	/* calculate size_sum and ensure dyn_size is enough for early alloc */
 	size_sum = PFN_ALIGN(static_size + reserved_size +
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

