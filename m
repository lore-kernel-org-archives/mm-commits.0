Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793568482;
	b=MyjoI5rPQlFUNrDEu0o9iQbGDDz246Wh6nWPFffgPuHaf4o0UZf1cZvRmvVv140kUA0A
	 RE5Foav6VDqh+hwBemduIZzvCx04cis8cVE+GoSEQDkj1GxFxDEv9fyqxksZz3w33CQhg
	 Bk/tW0iY5Vsn5kE8JsFdtrr926MHK2VVz6wU340tWmih2Ggfug7Vh+PXaEoNfbgzNGbfL
	 cbQtBfcDCNLVedrsqtG+yOUG1LKt7AklPHN1GYNHo4SeMBOgWCAVvH/TqFi3t4mR9235w
	 l9AJENHsTwOc5LsSMOBRGv4fKxRJFfSIEhhEy9E80d+GoFkxesTRF1n8K4RRyHjIEEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793568482;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=uCNYXOufAzV523iOiGDjOBoCVnhsXfm7cg4cvcyVatM=;
	b=wXDxL+dgGErKKtco0m0sKaPCBE/kDQthFWT3VTYdws5ZCN3R3v/iRaUQIqcxau6JqKfD
	 K6u4EEQIV4zFnbAtiR5LJshBpwlCWDLYQNxC3+i6gHfbKDvL8d2354Xdnn/WtERINxCho
	 YEBMo2x7YGyFsU/0TXHIbnb7Q9aY2D+N8MyLv3Jh56c9Y6vdLInzq7IL+cVb0L61NPWJx
	 9P/JPueFxyTcb9zIIJHz5Ekd4MXOyJdRFdV7nZR7tctkvQyRzmLBDsULm1b5Ta7geFWu6
	 vrAU0RQFQ/yASG+7FkesNWY+OoNuKFNQ5evePW6O/X6rQVvg6pvU0MqMb+H55dScMJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uqwKe2DH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BFC606A324
	for <mm-commits@vger.kernel.org>; Sun,  1 Nov 2026 21:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uqwKe2DH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EA01F000C1;
	Sun,  1 Nov 2026 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793568481;
	bh=uCNYXOufAzV523iOiGDjOBoCVnhsXfm7cg4cvcyVatM=;
	h=Date:To:From:Subject;
	b=uqwKe2DHgJEXFy+zMrpQbarIYMlFvd35ecCJocb4TCGHEPBu3FEdQthkH22zLtkKy
	 oelH/gCxDUwqV3Qvvw7lxQKvoLNk5BpknhChyNo7M0DLJnTcanxoPfMENxZuLPn7Mc
	 a//gmKhjOqGmY0lOVp/oHpN/8zbxcxBN9yOi8yYs=
Date: Sun, 01 Nov 2026 13:28:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,surenb@google.com,
	rppt@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	jannh@google.com,harry@kernel.org,hao.li@linux.dev,hannes@cmpxchg.org,
	gourry@gourry.net,david@kernel.org,cl@gentwo.org,brendan.jackman@linux.dev,
	vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-move-slab-allocator-under-memory-management.patch added to mm-hotfixes-unstable branch
Message-Id: <20261101212801.A6EA01F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: move SLAB ALLOCATOR under MEMORY MANAGEMENT
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-move-slab-allocator-under-memory-management.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-move-slab-allocator-under-memory-management.patch

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
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
---

 MAINTAINERS |   59 ++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

--- a/MAINTAINERS~maintainers-move-slab-allocator-under-memory-management
+++ a/MAINTAINERS
@@ -17798,6 +17798,35 @@ F:	mm/shmem_quota.c
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
@@ -25775,36 +25804,6 @@ S:	Maintained
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

maintainers-add-johannes-as-the-page-allocator-co-maintainer.patch
maintainers-move-slab-allocator-under-memory-management.patch

