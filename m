Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F9153565;
	Sat,  1 Feb 2025 11:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410853; cv=none; b=W/1xcQrMSm6rbEBDWr/n0qoIvR51Eg7IuYDeY6Tt8rB7DUWoq39ReoRe8c9oHbVaYzvIU0NzY9yb7eabaP6wpw1kxXGJm8Q5czBLXHLmp377Va1N22+BkI2TsJDBWDOOkpayK8s9Y0TVp7tDc/2EEVPzBozrqejagZt7tNyS0XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410853; c=relaxed/simple;
	bh=BmZsaWgibptChufQXydmUZxVgTanbW0NqgQ6lIew7gk=;
	h=Date:To:From:Subject:Message-Id; b=V1t0R2Bky5X/uHReUQLiB7g7nukDFJ96KV9+8f+Ln6URqJuN3kumBoykRArbQNlo+RgAg/OfNcxcg7JgeaU1ceRDS2DjsK3yzYAD46WQBksttwneRyvFUUKK9CfqZaW38rJp9gGUr3raPeKl73YZ6yoqwNYNtBmj0d7u+KtwdlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v4OXZ4Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v4OXZ4Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264AFC4CED3;
	Sat,  1 Feb 2025 11:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410853;
	bh=BmZsaWgibptChufQXydmUZxVgTanbW0NqgQ6lIew7gk=;
	h=Date:To:From:Subject:From;
	b=v4OXZ4QcyYW5y5fOfJ/7+MRpakProLN8xJ8jf6SQeoCl5DDkfgB2X1LBnOSHW4y4k
	 9xpkYeixcZ8roFOLEc8mOyzWT57DZ/GPr4BUVVe7o/5uwnbkQ/SYwT31plf8nFG0B2
	 sfXDt+jaihqQBZbvRI2Pld8enl9XQlG1C8VJYwas=
Date: Sat, 01 Feb 2025 03:54:12 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,glider@google.com,dvyukov@google.com,cl@linux.com,elver@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch removed from -mm tree
Message-Id: <20250201115413.264AFC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfence: skip __GFP_THISNODE allocations on NUMA systems
has been removed from the -mm tree.  Its filename was
     kfence-skip-__gfp_thisnode-allocations-on-numa-systems.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


