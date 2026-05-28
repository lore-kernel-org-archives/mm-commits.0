Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8EF3F9272
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779988452; cv=none; b=LVX4cVT64nTFencew/gaJJk9oBWw+cDv8g/WNKq19U+zuJLiz+iT7gmHok1LMz3SU4wfND+1mT1rIMvlyR/eKbzci/7QHQLNsLYFtqILYjwmBrlYG2Srrx6jrkIFM4KHuzWN/oXLt6Zye+/JDmeAobPN9cNC0kBQEoIkR1pNlPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779988452; c=relaxed/simple;
	bh=oY2/aZ+ozhnYdoMaKJOEZrLBOFr/iw3SYiMdJUYXBv8=;
	h=Date:To:From:Subject:Message-Id; b=gCnoIge1iU/EaVnAqJJ/B7/SD2a6yfEwMaCOLC9Kuk599N4dUX48t8g4NlKJipeVVMj7UkNPNz/ov5yTcU8RxroXRNCk2DYMelaNj//8H8nKcoWBDj6anksttS6uzBCWCUdZ5b0deP6mmwnckgdF9pQNE/aR6axbbVjIbd7x53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oAyO3hn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAyO3hn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25A41F000E9;
	Thu, 28 May 2026 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779988451;
	bh=CGBl6duDWzJQzu32PjdFU3GAM6d0Y0WgWdapfk0hPIc=;
	h=Date:To:From:Subject;
	b=oAyO3hn9AA01FCRc0K6zd88F7A2jRgFkaIn0xJIvPGQz5sQvcSwslXwxlHYbmRix1
	 GnUisAFlx3VdTlZVpjK4NYkdtwkuJMCb3Yxvhb2u0LyxPCKci40NhuO7LlUpMdY2p+
	 Kd5w3aididEso00tJ+P8qVIJNAmfZyUel9AaGxPY=
Date: Thu, 28 May 2026 10:14:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,roman.gushchin@linux.dev,rientjes@google.com,harry@kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch removed from -mm tree
Message-Id: <20260528171410.F25A41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
has been removed from the -mm tree.  Its filename was
     maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
Date: Mon, 25 May 2026 09:26:39 +0200

Make sure the maintainers and reviewers are CC'd on changes to the scripts
and tools that depend on slab internals.

Link: https://lore.kernel.org/20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/MAINTAINERS~maintainers-add-slab-related-scripts-and-tools-to-slab-allocator
+++ a/MAINTAINERS
@@ -24623,6 +24623,12 @@ F:	mm/mempool.c
 F:	mm/slab.h
 F:	mm/slab_common.c
 F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
 
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
_

Patches currently in -mm which might be from vbabka@kernel.org are


