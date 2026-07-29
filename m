Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A1393DE0
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298500; cv=none; b=Ym6IeAatMBIRNfCC8YAudo0kjWUs9kPz670Ruwq12qPeQhz7CpemJVUkLYVt+dKgRPYZf6FBvroOr/6hmVTWi8vgXSIMey6TXYRQHoj8n3lk+vi9pzIQj+DpanxYji0+2Znz1CPfClikOEzNSd4D2nxFbnTlESMdi34DtxGZ1ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298500; c=relaxed/simple;
	bh=382xggTN1+pR5rU+Et7G69yDHpTfeKRElJ47Q/AFoQA=;
	h=Date:To:From:Subject:Message-Id; b=epjl5fWZwwMMSL93PgJ3MtttsuwOYTM2Jpe3ggrc4k16ssMulq56hmxGKt05A2LWypE7NTifyOBAZ6cNuUYM6qVmbUUNpHVtYvmGrXuxpctJXOdZpRndXg1Fu2QbOrM3/m2t0yTbgYcA090hiNY6xWJKhH1t/uX7mguLUdZ5Jws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NiSmPZxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NiSmPZxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0771F000E9;
	Wed, 29 Jul 2026 04:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298499;
	bh=ymhK0dMFuO+EaPDmUOvo06undSYHyGajmJhm9V9KkEk=;
	h=Date:To:From:Subject;
	b=NiSmPZxK/Wp+SGCfN224wZ6klyvyd96/OQsPdHExmC5u8ZpIjgoTUvcBiLyZrqeIY
	 Ur72/UQLaX/U9L/VTvHCz7a/NbGi6YW42DuvSDL82PJ7zW2iW/G8o6E4gBeTP4i38l
	 0d4mlhMFhR+ofNU6Os/ei6CfWYsk6XaRG74BlWtA=
Date: Tue, 28 Jul 2026 21:14:58 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,rppt@kernel.org,ljs@kernel.org,liam@infradead.org,kent.overstreet@linux.dev,jackmanb@google.com,harry@kernel.org,hao.ge@linux.dev,david@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-move-inactive-maintainer-to-credits.patch removed from -mm tree
Message-Id: <20260729041459.1C0771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: move inactive maintainer to CREDITS
has been removed from the -mm tree.  Its filename was
     maintainers-move-inactive-maintainer-to-credits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: MAINTAINERS: move inactive maintainer to CREDITS
Date: Thu, 25 Jun 2026 11:48:56 -0700

Patch series "move alloc_tag.c file under mm/".

Memory allocation profiling is ultimately an mm feature and now that we
need to use some internal mm definitions in it [1], the time is right to
move its implementation under mm/. The move is straight-forward, involving
just alloc_tag.c file. Update config, makefiles and maintainers as well.


This patch (of 2):

Move Kent Overstreet from maintainers for Memory Allocation Profiling to
CREDITS in recognition of his co-authorship and contributions to this
feature.

Link: https://lore.kernel.org/20260625184857.2193482-2-surenb@google.com
Link: https://lore.kernel.org/all/20260622-alloc-trylock-v2-13-31f31367d420@google.com/ [1]
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Hao Ge <hao.ge@linux.dev>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |    4 ++++
 MAINTAINERS |    1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/CREDITS~maintainers-move-inactive-maintainer-to-credits
+++ a/CREDITS
@@ -3096,6 +3096,10 @@ N: Jens Osterkamp
 E: jens@de.ibm.com
 D: Maintainer of Spidernet network driver for Cell
 
+N: Kent Overstreet
+E: kent.overstreet@linux.dev
+D: Co-authored and contributed to Memory Allocation Profiling
+
 N: Gadi Oxman
 E: gadio@netvision.net.il
 D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
--- a/MAINTAINERS~maintainers-move-inactive-maintainer-to-credits
+++ a/MAINTAINERS
@@ -16889,7 +16889,6 @@ F:	tools/testing/memblock/
 
 MEMORY ALLOCATION PROFILING
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Kent Overstreet <kent.overstreet@linux.dev>
 R:	Hao Ge <hao.ge@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-add-ioctl-to-proc-allocinfo.patch

