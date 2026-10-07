Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E431F9B9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334360; cv=none; b=sDrawEG0DnU8NQT4xdOv0srGXflzx4SIzsBv0/SvelpCmWbOvyqywg1FYM/SQpzWUtQKZX/UkuPHkd30gNcYZkfl4cnRIEGpMsKs73nP8uAtAFxXVhNLGLCBXveCYE1im5FGpCxi3ZG/2pBfdWR3reobYbcsO8jCE7XcsUArIUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334360; c=relaxed/simple;
	bh=C+YgT6qjuCZWuwOG8MnoLCZjchowXhFarvEqfyZu9fc=;
	h=Date:To:From:Subject:Message-Id; b=hoThzr4MImmoOYbve00aR1U4GsYBB1rFHcVWKe+tlwwzrNFojn44TRBa7BPUzodCuNKrHo9esKRPkbOu4QvZ5Sai7PT13al1MYUAPMFNIXkYzquta7swu/GzIAacpuyV6NkucYYfMKUOr1hB+h+BhZ50WYpIMRRcggVtFXO7YD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gVLnmRd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gVLnmRd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB9F1F0089C;
	Wed,  7 Oct 2026 00:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334358;
	bh=Ak74qluIUnI7zEhIhx+fzSpU8WSZEuXvrMeDzi3nis8=;
	h=Date:To:From:Subject;
	b=gVLnmRd6BFCr9hNLJ+7l+Wi09gSwZBnE6UhwBxTBb/0GP2RZXQyCIA+fLfXmKH9rO
	 ndopRpXBAsgOK4N4TICjrhuTrukTNAD8sEBo4HXomn2qtaTdiYmx4zLDxnSVIGNcyV
	 VhR5oRifotNWT3wfRGElRqdd+dbsJ/Xle606u7p4=
Date: Tue, 06 Oct 2026 17:52:38 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@linux.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch removed from -mm tree
Message-Id: <20261007005238.9EB9F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu: remove unnecessary initialization in pcpu_build_alloc_info()
has been removed from the -mm tree.  Its filename was
     percpu-remove-unnecessary-initialization-in-pcpu_build_alloc_info.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

mm-swapops-remove-unused-is_hwpoison_entry.patch
bootconfig-remove-redundant-assignment-in-xbc_parse_array.patch
init-mainc-remove-unreachable-check-in-obsolete_checksetup.patch

