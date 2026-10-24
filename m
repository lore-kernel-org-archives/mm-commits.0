Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832443;
	b=XWEAZEVM5eDRjupraSGaUxLuBgrfoo9waa1UqCH65OfuPmfTfYDkI9kiLRm2dA3kLhKX
	 z4JjgK7/nuA8NPZCOZDM4PV4lYpYwaxxm8CGYnlTvj53mHOwrgn5Rbjabh+vwfOr/Y9Pp
	 FPmqzGfHf6bfeJ5r4HFf6iUoyR0qwBgO4FFT8kGxb7By9SN0Dei6kYjyUtHkr2aBL5zuN
	 DAn/Saiv2QqZrVotg+dqp7ZSbXZp53/jbPbwuZR2Z3ZTW1nxBFJgNPjc+ssCLmqbhDMU2
	 z0xDFIYP18ofFtxlUCcNiS93GRC1Q8hBFrvxFOwDMyTeb2SocV/e6ORBCnHMAXbrngg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832443;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=szlq4JwD276wMjrc6JogiaGgv8LQMwcId/4/YCDBz+I=;
	b=g/lHHOWAXPMSWLROkcwIbC9BgaeDCh1NkIxfQtSG98UOSG0HOWzpuZQZOeQ90oCihYI7
	 1zSZa6vSTAPqP7Ra2NfY7bggio6GgYTdDkL9M09dxz0wtRpQvK5kqiqcrgoSLi/lzvjWk
	 1wcQ++AQGce0TnvAHgoviFWPYrnKpA6MkvqDEjUoKDJAL+sTbfqYGYcZ3A46CDU/aGKT9
	 RvOLEV7KuIRzy3hCCeLAtXEln4yc+3bpYLbUGSk4V/a7Q7lNN1yamEgjZMWonFHWbTXVx
	 DtJpdL1zqBtwUhwscQaauwkVRp/tMIdAYixsSMvplYfP7DTOwsxSP+ZTa4lAFlKI5rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nMYJpv6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BE7606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nMYJpv6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5721F01825;
	Sat, 24 Oct 2026 09:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832442;
	bh=szlq4JwD276wMjrc6JogiaGgv8LQMwcId/4/YCDBz+I=;
	h=Date:To:From:Subject;
	b=nMYJpv6CgYTjlqHUu/vz8tE6BXHJsdU7wB08RN5EV2zVoRNLReyHUn7VkKEIfR3SN
	 S5Vg0mVlDTMM5nhxqEuaq35I0pX7whhsqIn+nTBlqdYWVsIDfHLQEfa+8oHn5hHbvl
	 EvKRM2GUS0D9il/FHS4NQyTwh/BheX/VxjfD3bTg=
Date: Sat, 24 Oct 2026 02:00:42 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,ren.tamura.oss@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch removed from -mm tree
Message-Id: <20261024090042.8D5721F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: tools/cgroup: sum shrinker object counts across NUMA nodes
has been removed from the -mm tree.  Its filename was
     tools-cgroup-sum-shrinker-object-counts-across-numa-nodes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


