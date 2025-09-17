Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D548E3C38
	for <mm-commits@vger.kernel.org>; Wed, 17 Sep 2025 00:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758070609; cv=none; b=ZvamvYZHbD8iqjasuNoVb406eCYepAbkd8NZFdY2ANDubsmGBnv0619foArbWk3HRJ1jRlA0PpF9Efb6u7Ys8Abs0+Ksvf+XYe1qVZVGbubbnP925dDWErEe0lg1SI7kRPaQedYzjOcpZEMWepXi/2dME4kLl1VJxZKjz2ZwuLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758070609; c=relaxed/simple;
	bh=E5ZKpRY/1YcnjTG9pBDFVjKtML45KTgZBROL0VJl4jE=;
	h=Date:To:From:Subject:Message-Id; b=Yj2fjrTbfC64b3mU587+YWpJwFK1XbO9r1iVNkzTykO/Xrc9xBO5YU8p4EMy4SkG3ZdKeh9ejQ2vy6XWY1NZ025Lphi5hdu+Q81PxHsPoCQNIy/t68pdcube3Lux0uY4/wu7ETaB0pHmChPXSaozw12458yAGwvGoQRhn423IwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vgZfgqec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vgZfgqec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B2BC4CEEB;
	Wed, 17 Sep 2025 00:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758070609;
	bh=E5ZKpRY/1YcnjTG9pBDFVjKtML45KTgZBROL0VJl4jE=;
	h=Date:To:From:Subject:From;
	b=vgZfgqecrTuy+vOxzGs8PZp+7nPmC+21UDVvWgHJS74zVhM+75dimsFw78/c9BIhU
	 zS6DuxHPcHBUekH0rMzAODz5oUW+Q+yWLvfZMmgRUJuAT5IBslHW6VRTg1p4Q/ASVX
	 qxagwa3Txsj038S3VzE6bUsZYvwKx1icp/180A/8=
Date: Tue, 16 Sep 2025 17:56:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch added to mm-new branch
Message-Id: <20250917005649.47B2BC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
Date: Tue Sep 16 05:53:33 PM PDT 2025

simplification per Usama, reflow text

Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1016,11 +1016,11 @@ For example if the counters are not accu
 
 Supported markers in v2:
 accurate:no
-              Absolute values of the counters in this line are not
-              accurate because of the failure to allocate storage required
-              to track some of the allocations made at this location.
-              Deltas in these counters are accurate, therefore counters
-              can be used to track allocation size and count changes.
+              Absolute values of the counters in this line are not accurate
+              because of the failure to allocate memory to track some of the
+              allocations made at this location.  Deltas in these counters are
+              accurate, therefore counters can be used to track allocation size
+              and count changes.
 
 Example output.
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch

