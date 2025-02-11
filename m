Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD27267735
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739312377; cv=none; b=eVmkfx3J5r/gfNQ9ZFYtnWK+YvE7wO+TqSya3SDhgGgJuOREu857SANpAVnfmHrw7Rg/MVwPDfzQ0wXpyeELLOjucDy3s9jEYCllqB8/nPKMtC5Mnnnw2WuG9cnlMsoddsNtdtiCZlOO/vK8BD9Aqgol9vbwcacPcFGV27/Nk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739312377; c=relaxed/simple;
	bh=avjDlaH5AnAPsqRKUfnjCxSD5kPG+mbbU2mr8m4vzX4=;
	h=Date:To:From:Subject:Message-Id; b=AkhXJRqF2QLrTdgxSMgVbF9Xq81CZCxmQ9cnFN0QzEnqbaoQfMwBZyRk//Giv4xokCmOjPSli3n12t2WmAxsi8Rnngh7dFjyvLR/Edwk/ZNchjeEzfSQx0VMlwYKOjE8i0vjn4ZSOwy+broTzGqzk7LU9FuyFI+K60x3d/zvIYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lhuL1lXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lhuL1lXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45FCC4CEDD;
	Tue, 11 Feb 2025 22:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739312376;
	bh=avjDlaH5AnAPsqRKUfnjCxSD5kPG+mbbU2mr8m4vzX4=;
	h=Date:To:From:Subject:From;
	b=lhuL1lXdVoEQ4koXDWez4p5mYzUeh3OKgI5rnqyu2fVnMoRjL8KR1Ah7jYnUZQD1v
	 dBPrJ0mA5ul1KFiGjdOzVM3+KOFJPUV4LWAnFhv+clOzXe8GeBrhXq807h3GoilvON
	 JIi6b8zTkvJnuHhlnHmG756LNtjxFqTKw/ghRN6Q=
Date: Tue, 11 Feb 2025 14:19:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,nathan@kernel.org,intelfx@intelfx.name,david.laight@aculab.com,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch added to mm-unstable branch
Message-Id: <20250211221936.B45FCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmstat: revert "fix a W=1 clang compiler warning"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch

This patch will later appear in the mm-unstable branch at
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
From: Bart Van Assche <bvanassche@acm.org>
Subject: mm/vmstat: revert "fix a W=1 clang compiler warning"
Date: Tue, 11 Feb 2025 12:59:11 -0800

Commit 75b5ab134bb5 enabled -Wenum-enum-conversion in W=1 builds.  Commit
30c2de0a267c ("mm/vmstat: fix a W=1 clang compiler warning") fixed a
-Wenum-enum-conversion warning.  Commit 8f6629c004b1 removed the
-Wenum-enum-conversion option again from W=1 builds.  Since the W=1
compiler warning fix is no longer necessary, revert it.

Link: https://lkml.kernel.org/r/20250211205911.1707684-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ivan Shapovalov <intelfx@intelfx.name>
Cc: David Laight <david.laight@aculab.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/vmstat.h~mm-vmstat-revert-fix-a-w=1-clang-compiler-warning
+++ a/include/linux/vmstat.h
@@ -515,7 +515,7 @@ static inline const char *node_stat_name
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
_

Patches currently in -mm which might be from bvanassche@acm.org are

procfs-fix-a-locking-bug-in-a-vmcore_add_device_dump-error-path.patch
mm-vmstat-revert-fix-a-w=1-clang-compiler-warning.patch

