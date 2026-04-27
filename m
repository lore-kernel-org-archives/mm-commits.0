Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7445127E1D7
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777301263; cv=none; b=UH58hGfvgZ4fH3Yjx9rk/PaRAHEgiqs9xZ3bVasj3SblaZsiYiMQXLoDtetT1+bVyQ8y6b/llerXUFjye9X0sjwT4Clvn9ET3y2SwKEGNaUJxFYM9R1b/EoyKg4vCSBG/HihsFK9jhg/HoFDcfsjN2wPwMZ6DjiN7ZLjIFLFTz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777301263; c=relaxed/simple;
	bh=hsxNQacGtWFCv2Zoq5PyfZT7mSN/k7tkY/D0hT4kHa8=;
	h=Date:To:From:Subject:Message-Id; b=lHhRyCIn6lnrl7N0FaKDYP33Q3hf0tVxvnRdWuPIYTw2TOnHLTkvaItDxN/+ELX6VWEM4UFM4qZt/vUktL3OW9cID9ykuCddQ1Im/GJv3lC6dywva6PRm67tOd/wIl/8RxPVP47Pmqnqg0rw0tZi+RKB9eIEvXy/+flMFd4TpiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TdxljZJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TdxljZJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C515C2BCB7;
	Mon, 27 Apr 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777301263;
	bh=hsxNQacGtWFCv2Zoq5PyfZT7mSN/k7tkY/D0hT4kHa8=;
	h=Date:To:From:Subject:From;
	b=TdxljZJmdwfJsdFY/btnE47zXZ+qaUGib8pEOfM7+AY1qZxhMjgWUT3jkP97hq1Y6
	 mEvcuqyLQAtR2SwiBNQBLvlukixmCyg87Hvx09NycXK9ufMz+EHvKC040OfKMh/rr0
	 lr6dMuBkuMXBRUzWEuuORly3fYU2uFF3A4E0s5I8=
Date: Mon, 27 Apr 2026 07:47:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.com,kbingham@kernel.org,jan.kiszka@siemens.com,hsj0512@snu.ac.kr,harry@kernel.org,hao.li@linux.dev,florian.fainelli@broadcom.com,illia@yshyn.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch added to mm-hotfixes-unstable branch
Message-Id: <20260427144743.0C515C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb: slab: update field names of struct kmem_cache
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: Vlastimil Babka <vbabka@suse.com>
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

scripts-gdb-mm-cast-untyped-symbols-in-x86_page_ops.patch
scripts-gdb-slab-update-field-names-of-struct-kmem_cache.patch

