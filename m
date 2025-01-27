Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2547D1991BF;
	Mon, 27 Jan 2025 22:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738018255; cv=none; b=fDrQi1QUazU9qc+bTAeVh4t8E41YVHpkUvlXIEyHRhCDWffP7nDKYxsQ8iMI1scVdf7cLfvyqWz8ddzerX32GtciXiOZZck9RWW4WcM8vP6cND8uo0pKD78fFb+Y1dizA1x7lyzurYSWvmwGdJC9Kb5tTXML5i8v8wH0ax/1TL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738018255; c=relaxed/simple;
	bh=0Uk4hRJ48t/UFJ08O+tq3eODrx+TmUhoiGFzch6Zp6Q=;
	h=Date:To:From:Subject:Message-Id; b=hROS3DWFCkqlBrm3PqAm5rS8u2gclUDPvfUdsnkSasQ7O0md82s/VT3lTK0jUYG0tGptMF1a86L/aKAEO7AF5NiOhj9wqknzbohiE7bJIyws14B1JYy2NLa/rwL9gAQnKZbK80MtRMrrvV1HYJvucNZUSFM38obPIced0X+NgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NRL21EZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRL21EZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87201C4CED2;
	Mon, 27 Jan 2025 22:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738018253;
	bh=0Uk4hRJ48t/UFJ08O+tq3eODrx+TmUhoiGFzch6Zp6Q=;
	h=Date:To:From:Subject:From;
	b=NRL21EZqQe/bsrAO+cmVY3eqHFdbEIlmIfFQWkeGZrO57rA6NwBJOkAzsYYmFHAR6
	 IbWpFsKDlzhaDEJ+inAYSdUE3OsOq+Vtv/jKubEhp0bLJE1t0Z5l3/A+JKPU+lL/pe
	 cXLy254OEvvWlv4A98yV6S1tKUYLG+iWR8bZvkSU=
Date: Mon, 27 Jan 2025 14:50:52 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,glider@google.com,dvyukov@google.com,cl@linux.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127225053.87201C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfence: skip __GFP_THISNODE allocations on NUMA systems
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Marco Elver <elver@google.com>
Subject: kfence: skip __GFP_THISNODE allocations on NUMA systems
Date: Fri, 24 Jan 2025 13:01:38 +0100

On NUMA systems, __GFP_THISNODE indicates that an allocation _must_ be on
a particular node, and failure to allocate on the desired node will result
in a failed allocation.

Skip __GFP_THISNODE allocations if we are running on a NUMA system, since
KFENCE can't guarantee which node its pool pages are allocated on.

Link: https://lkml.kernel.org/r/20250124120145.410066-1-elver@google.com
Fixes: 236e9f153852 ("kfence: skip all GFP_ZONEMASK allocations")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Chistoph Lameter <cl@linux.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/kfence/core.c~kfence-skip-__gfp_thisnode-allocations-on-numa-systems
+++ a/mm/kfence/core.c
@@ -21,6 +21,7 @@
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
+#include <linux/nodemask.h>
 #include <linux/notifier.h>
 #include <linux/panic_notifier.h>
 #include <linux/random.h>
@@ -1084,6 +1085,7 @@ void *__kfence_alloc(struct kmem_cache *
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
+	    ((flags & __GFP_THISNODE) && num_online_nodes() > 1) ||
 	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
 		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
_

Patches currently in -mm which might be from elver@google.com are

kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch

