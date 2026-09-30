Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E9E511E80
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 21:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805283; cv=none; b=kzQnZ1tev8xh99+ddnTPJrVgf8ZhjXyNZVjCWHHQnkTylQMI3SozcOsBqRpD3gy5Wdj3ImUREWkMWQG/D8MIYJh9kXDE+uSenEAJ0dSqOEoofE2m8wV2kcV9ApW/IMUlUJWXV5cDgbijU6N63pZgeKExJ2e/HjQTzCPTaGvLtDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805283; c=relaxed/simple;
	bh=4KT75EUQ3FQ67NXzYxtpTJ6ytPHTgd3ILNZ4h9MSDP4=;
	h=Date:To:From:Subject:Message-Id; b=mOu+5cF1dHTKgVGHxx6pC43BKfC1Kgx2HM59l4/4y5MK2WOF3Tsjnf+U8N/6r0pmy5jpmj1f6XVSyKzipXVb9xCMuYDEDY4h0HTpyJnnMUMXvhxE9XNfcpMFD8MNwL4HQryrXNRra8jQuWwfF+xNfumpMnOVbpZu5/PzmM2cHbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xim3SKm9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xim3SKm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F281F000FF;
	Wed, 30 Sep 2026 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790805281;
	bh=WvF7V/D5IYQbl5b8GrAqBlBgLpEgyrB20tJ/d7QPYQY=;
	h=Date:To:From:Subject;
	b=Xim3SKm9NUaqyHzx+2iPAJiXzzKXs3dtEqGXi3IcOBB2b5uwJhRKzhNtDQq/a4AUX
	 pRBD7PQg5FO4nlttmOzbwg7kIOMSP5Tl48DWPimLw8M2lTxDi+T+is3oBVip8FbiQG
	 G790ut/OKWbvaqPGGJTQWekaU5zyNTq5lWIJIh8Y=
Date: Wed, 30 Sep 2026 14:54:40 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,ren.tamura.oss@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch added to mm-new branch
Message-Id: <20260930215441.70F281F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/cgroup: sum shrinker object counts across NUMA nodes
has been added to the -mm mm-new branch.  Its filename is
     tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch

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
From: Ren Tamura <ren.tamura.oss@gmail.com>
Subject: tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 30 Sep 2026 15:03:17 +0900

Each row of a memcg-aware shrinker's debugfs count file contains the
cgroup ID followed by one object count per NUMA node.  memcg_shrinker.py
uses only the first count when sorting and displaying entries.

This undercounts objects on NUMA systems.  An entry with counts of 0 and
23 is treated as zero and omitted from the output, even though its total
is 23.

Sum all count fields after the cgroup ID so that the displayed totals and
sort order account for every node.  Single-node input retains the same
result.

Link: https://lore.kernel.org/179074810112.139422.9274126921568167859@gmail.com
Fixes: d261ea23533b ("tools: add memcg_shrinker.py")
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 tools/cgroup/memcg_shrinker.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/cgroup/memcg_shrinker.py~tools-cgroup-sum-shrinker-object-counts-across-numa-nodes
+++ a/tools/cgroup/memcg_shrinker.py
@@ -31,7 +31,7 @@ def scan_shrinkers(shrinker_debugfs):
                     items = line.split(' ')
                     ino = int(items[0])
                     # (count, shrinker, memcg ino)
-                    shrinkers.append((int(items[1]), shrinker, ino))
+                    shrinkers.append((sum(map(int, items[1:])), shrinker, ino))
     return shrinkers
 
 
_

Patches currently in -mm which might be from ren.tamura.oss@gmail.com are

tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch

