Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562EA3B28D
	for <mm-commits@vger.kernel.org>; Thu, 14 May 2026 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719230; cv=none; b=UBHxKcTfW+a++vbVbh+GhYjNFdm6VRxGcqSWHeU1fUOIbKwVpHHoXUdJ1ZAqnHrVhpiVEwEW220LSeF940YbhOlBq4+NE91JAfQRJu8IesLmLCH9CDncMfY6nkoxGarpc9Ta1xvqhSgG/Z0mLMGp2wTGGOQujjaQKwdUYh0utug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719230; c=relaxed/simple;
	bh=TAMhiaVhBpyJo9m8Vq2CGrBiEZqfstxrzcWkhaz1CKs=;
	h=Date:To:From:Subject:Message-Id; b=qy1Zlcbt/frtvQoZEAdZhGNfZVZzmyG9aDi7wJTICVH8F4PdmmFGaopqFJyNmijLiEGAYWzG7JZnC/FUCAd48OPpfilWl4Wet4Kbss05z7Dss5ex7PdPbrjIBIo9vLJpGqzW43uQMb3JWnmmaPX0gdjr0aMvObK0CLT6REpLbEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eX4Cen46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eX4Cen46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7131C19425;
	Thu, 14 May 2026 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778719230;
	bh=TAMhiaVhBpyJo9m8Vq2CGrBiEZqfstxrzcWkhaz1CKs=;
	h=Date:To:From:Subject:From;
	b=eX4Cen46Ii0UnW1loa85lEcR/KKC9STbe2MvejzqVymwZsbg4HTFfJY3FMEQqQLKm
	 cPeMumhBNYdDsdD6eYgCxN6+lQo/bN0TLC76Ty151is+5cF6YVzOjGm6YvF03iK6d+
	 CZ/wA71HQmg3yNQBgVX6YzAoW7Ow/Ld18/WNoMK4=
Date: Wed, 13 May 2026 17:40:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,kbingham@kernel.org,jan.kiszka@siemens.com,hsj0512@snu.ac.kr,harry@kernel.org,hao.li@linux.dev,florian.fainelli@broadcom.com,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch removed from -mm tree
Message-Id: <20260514004029.E7131C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/gdb: slab: update field names of struct kmem_cache
has been removed from the -mm tree.  Its filename was
     scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Illia Ostapyshyn <illia@yshyn.com>
Subject: scripts/gdb: slab: update field names of struct kmem_cache
Date: Mon, 27 Apr 2026 16:24:48 +0200

The commit 5ba6bc27b1f9 ("slab: decouple pointer to barn from
kmem_cache_node") reorganized the struct kmem_cache to factor out the
per-node fields to the new struct kmem_cache_per_node_ptrs.  This causes
the gdb scripts for lx-slabinfo and lx-slabtrace fail as they still
reference the old structure.

Adjust the gdb scripts to match the current state of struct kmem_cache.

Link: https://lore.kernel.org/20260427142448.666117-3-illia@yshyn.com
Fixes: 5ba6bc27b1f9 ("slab: decouple pointer to barn from kmem_cache_node")
Signed-off-by: Illia Ostapyshyn <illia@yshyn.com>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/slab.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/slab.py~scripts-gdb-slab-update-field-names-of-struct-kmem_cache
+++ a/scripts/gdb/linux/slab.py
@@ -196,7 +196,7 @@ def slabtrace(alloc, cache_name):
 
     if target_cache['flags'] & SLAB_STORE_USER:
         for i in range(0, nr_node_ids):
-            cache_node = target_cache['node'][i]
+            cache_node = target_cache['per_node']['node'][i]
             if cache_node['nr_slabs']['counter'] == 0:
                 continue
             process_slab(loc_track, cache_node['partial'], alloc, target_cache)
@@ -300,7 +300,7 @@ def slabinfo():
         nr_free = 0
         nr_slabs = 0
         for i in range(0, nr_node_ids):
-            cache_node = cache['node'][i]
+            cache_node = cache['per_node']['node'][i]
             try:
                 nr_slabs += cache_node['nr_slabs']['counter']
                 nr_objs = int(cache_node['total_objects']['counter'])
_

Patches currently in -mm which might be from illia@yshyn.com are


