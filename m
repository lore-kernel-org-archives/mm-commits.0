Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BC41E0DCB
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 20:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758487736; cv=none; b=QZQQ0PJub4+egtWMt/FnW/9UMpgo0d97cTueum1fxqGW8YQMvXwjkCJPnn26fVqrjQ5jdYHjYUiaTNvxtWEB6U8+lXV4i7Xjgp6BlCJoJkPII9r8J3EAJswaIGafr2eHvCAVgAp5Cqa4oe7SQcy6Mnko55gtsJ0RzAJhcFCjqGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758487736; c=relaxed/simple;
	bh=Y28vkqjyYyPA1w1pjHQxUuOGuvil4gveudgrz0UEvAw=;
	h=Date:To:From:Subject:Message-Id; b=F3pUQpzm5JVqqPZRXg/JCVDk0Mh7wfLpoTOa6snfhvn4u7aWtpBV3cTuBUmTwk2y6H2ua2eXdCNEn4q2YdoYONfZWViN7gx0JDZ3EQpWIkS8Mee3Sddru8KopPkBnQ0mwB2TJr6CBinzoJkdxqoZwEAwty8x37xr53JeWwRG+94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ElpUYz3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ElpUYz3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111C9C4CEE7;
	Sun, 21 Sep 2025 20:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758487736;
	bh=Y28vkqjyYyPA1w1pjHQxUuOGuvil4gveudgrz0UEvAw=;
	h=Date:To:From:Subject:From;
	b=ElpUYz3XaNV240i/doMlsGvjLGqDbHsI6AatI9lx2QLSX3Q0qYt0qMNhuObJPMSWH
	 NaQHRP+6201gBx5ThbmwXqbbNxgI/Pcm6PB80vt8sRFI+PQ4wZwvkhNQn3chZRSxhk
	 tXO087bxynh5WeGeZX56izCZrhoE1Chyl4Fq2dx4=
Date: Sun, 21 Sep 2025 13:48:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,usamaarif642@gmail.com,surenb@google.com,souravpanda@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,rientjes@google.com,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,hannes@cmpxchg.org,00107082@163.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch removed from -mm tree
Message-Id: <20250921204856.111C9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
has been removed from the -mm tree.  Its filename was
     alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix.patch

This patch was dropped because it was folded into alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch

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
include-linux-pgtableh-convert-arch_enter_lazy_mmu_mode-and-friends-to-static-inlines.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output.patch
alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix-fix.patch
mm-add-remap_pfn_range_prepare-remap_pfn_range_complete-fix.patch
mm-vmalloc-move-resched-point-into-alloc_vmap_area-fix.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
kho-add-support-for-preserving-vmalloc-allocations-checkpatch-fixes.patch

