Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672174;
	b=IHvDp7PQyo6gJWpztCb73WAd2X+RUj4mNPbwOT5A7LhkgKeUU3q+3EaY+STYnBoSAhrp
	 a0iuxBObsTeJIP3aQg7BOfMmzejbxWlOqz87ciLFZwXjuufZl3eD96jwYLA3tmNw4zKrZ
	 5Pk5/fn9SYgJ0wPqotYK6EvSROTIyzJQlRkKe5QR4q53w8EGvLuSSJy5yavnHR7cD6ayJ
	 kpBtWuHgcsrIFYDocNkCkMDMV37v9EByvkkwsAMRcGDtwSbgIXgxp/k2Bji5mLK86/5zi
	 oWarGf7Zzw1xA5g02GJOnIED5VXqmSVIFAScejsXGmXrG81QcrbxCaOVTM0dzh2EIlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672174;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=GCJMwAAfw64IIEEQbJErpFOKdaK6G1NFUH4k/BdeMQE=;
	b=u/q/XZGpP79+n/3BR9TYtFr6QNfDpwcf6TJf8/nQsxmea+U06t8Vkm16FB7HzLCFZ3x4
	 nX6z+V7bqzH7J41ZW7/zsYLzxVoIdITk/jFD8Bm3DaHJGbIf+epThRhoHxGLqJ3Yfizr1
	 CMLEwC4LZTnnuprhDxPLTalvMIk88rtYBUxyKWpB/VlwbORplAWWY98MzNExiGf3sm9XO
	 0+CgoMtEsYcWiwFU97F07Gf+tBqtgpVs//g17dUfnrDdepCBE4LRM4eO0ovJD3HPSxa3c
	 4eJh18RwqbGcGmSGIYrggu1t1UqqANp+/bPFC35cpjF0Lrsm/6zh24/OMnCrYvkGZcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeklUrHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0CC606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 02:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SeklUrHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAFB1F000C1;
	Tue,  3 Nov 2026 02:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672174;
	bh=GCJMwAAfw64IIEEQbJErpFOKdaK6G1NFUH4k/BdeMQE=;
	h=Date:To:From:Subject;
	b=SeklUrHwQeHSC2s2U9W2AT7kq3/eWUkmmiHy9OrFqtmW08vU+1UfyU+fU68SeAz1E
	 FYvm8GNyfVK/35ezPo7NmbY2vks8VCt2kR1ZI5DpHnq9GHsr1e3DJuidbyAdZrHWdc
	 pBqgBtaneBhLfWxcIrV9xBgoNEvFuxBP27usskrg=
Date: Mon, 02 Nov 2026 18:16:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,
	gourry@gourry.net,david@kernel.org,cl@gentwo.org,brendan.jackman@linux.dev,
	vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-move-slab-allocator-under-memory-management.patch removed from -mm tree
Message-Id: <20261103021613.DCAFB1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT
has been removed from the -mm tree.  Its filename was
     maintainers-move-slab-allocator-under-memory-management.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT
Date: Sun, 01 Nov 2026 17:34:49 +0100

Following David's consolidation of several other MM subcomponents, do
the same for the slab allocator.

Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
remain in alphabetical order.

Remove Andrew as M: to signify he's not the primary person for picking
patches in this subcomponent. get_maintainers will continue CCing him on
most patches via the catch-all MM entry. David prefers not being added
for mail volume reasons.

Indicate the primary integration branch (slab/for-next) in the T: entry.
It will now be integrrated via the mm/linux integration tree.

Link: https://lore.kernel.org/20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
---

 MAINTAINERS |   59 ++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

--- a/MAINTAINERS~maintainers-move-slab-allocator-under-memory-management
+++ a/MAINTAINERS
@@ -17853,6 +17853,35 @@ F:	mm/shmem_quota.c
 F:	tools/testing/selftests/memfd/
 F:	tools/testing/selftests/tmpfs/
 
+MEMORY MANAGEMENT - SLAB ALLOCATOR
+M:	Vlastimil Babka <vbabka@kernel.org>
+M:	Harry Yoo <harry@kernel.org>
+R:	Hao Li <hao.li@linux.dev>
+R:	Christoph Lameter <cl@gentwo.org>
+R:	David Rientjes <rientjes@google.com>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git slab/for-next
+F:	Documentation/ABI/testing/sysfs-kernel-slab
+F:	Documentation/admin-guide/mm/slab.rst
+F:	Documentation/mm/slab.rst
+F:	include/linux/mempool.h
+F:	include/linux/slab.h
+F:	include/trace/events/kmem.h
+F:	lib/tests/slub_kunit.c
+F:	mm/failslab.c
+F:	mm/mempool.c
+F:	mm/slab.h
+F:	mm/slab_common.c
+F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
+
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Chris Li <chrisl@kernel.org>
@@ -25852,36 +25881,6 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
 F:	drivers/nvmem/layouts/sl28vpd.c
 
-SLAB ALLOCATOR
-M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry@kernel.org>
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Hao Li <hao.li@linux.dev>
-R:	Christoph Lameter <cl@gentwo.org>
-R:	David Rientjes <rientjes@google.com>
-R:	Roman Gushchin <roman.gushchin@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git
-F:	Documentation/ABI/testing/sysfs-kernel-slab
-F:	Documentation/admin-guide/mm/slab.rst
-F:	Documentation/mm/slab.rst
-F:	include/linux/mempool.h
-F:	include/linux/slab.h
-F:	include/trace/events/kmem.h
-F:	lib/tests/slub_kunit.c
-F:	mm/failslab.c
-F:	mm/mempool.c
-F:	mm/slab.h
-F:	mm/slab_common.c
-F:	mm/slub.c
-F:	scripts/gdb/linux/slab.py
-F:	tools/cgroup/memcg_slabinfo.py
-F:	tools/include/linux/slab.h
-F:	tools/lib/slab.c
-F:	tools/mm/slabinfo-gnuplot.sh
-F:	tools/mm/slabinfo.c
-
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
 L:	linux-can@vger.kernel.org
_

Patches currently in -mm which might be from vbabka@kernel.org are


