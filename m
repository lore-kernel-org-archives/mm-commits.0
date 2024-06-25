Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FDD1419A0
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291642; cv=none; b=J5NxB5iDPMA66F1qvQD5NL08nMBxjHvVajuF2yZrajmRjRePddj0coG8/qqaKy7ynCVGLZzckvxzxv7+Z5NM1xhCpUGXrJLDyzzlDKVGuM699a15tSnx14VnCMrNJPCqsNs2vsy4nhuAovPsHayJyr4kGcG9CxurR7ul08Ys31g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291642; c=relaxed/simple;
	bh=uExwolSI8JJ/2iqU9I10sJX/+5BHTDAD7vM3bWzzC2w=;
	h=Date:To:From:Subject:Message-Id; b=LUsHcX23fWZy9Eers/lbLt0V2Rr/EfyLyQhIB64JeLU7PKvLzpVqnlhL2JJZA3FBur/S7Vgu0wwhFiW2hjgaX/tOarwNyU+a+VPxD94W1We0Jg9Ps44meIONiRxtmI3YvKp9wd4xPLf3z/I+tjrVSlz+r3vn+VFpqUlEfpmePQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HxTfAz1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HxTfAz1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B81CC32782;
	Tue, 25 Jun 2024 05:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291642;
	bh=uExwolSI8JJ/2iqU9I10sJX/+5BHTDAD7vM3bWzzC2w=;
	h=Date:To:From:Subject:From;
	b=HxTfAz1+l92bQ3LI1Wi67KwUuCqyC5Quael4/e29eaVbhypDcnb8wnqe3mYocOrFU
	 Oi9p0Pa/6SJHQnu6REirK+sjFZoks4aCfVytob1MbWGB9LQiNyQErG2TCEDGvc1mhx
	 ziKJ4pGCU/ptd7+OQPehku1M+D0FGBSyluKCOmks=
Date: Mon, 24 Jun 2024 22:00:41 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,david@redhat.com,Jonathan.Cameron@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch removed from -mm tree
Message-Id: <20240625050042.4B81CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: drop memblock_phys_free() call in try_remove_memory()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: mm/memory_hotplug: drop memblock_phys_free() call in try_remove_memory()
Date: Wed, 5 Jun 2024 11:20:49 +0300

The call for memblock_phys_free() in try_remove_memory() does not balance
any call to memblock_alloc() (or memblock_reserve() for that matter).

There are no memblock_reserve() calls in mm/memory_hotplug.c, no memblock
allocations possible after mm_core_init(), and even if memblock_add_node()
called from add_memory_resource() would need to allocate memory, that
memory would ba allocated from slab.

The patch f9126ab9241f ("memory-hotplug: fix wrong edge when hot add a new
node") that introduced that call to memblock_free() does not provide
adequate description why that was required and tinkering with memblock in
the context of memory hotplug on x86 seems bogus because x86 never kept
memblock after boot anyway.

Drop memblock_phys_free() call in try_remove_memory().

[rppt@kernel.org: rewrite the commit message]
Link: https://lkml.kernel.org/r/20240605082049.973242-1-rppt@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory
+++ a/mm/memory_hotplug.c
@@ -2282,10 +2282,8 @@ static int __ref try_remove_memory(u64 s
 		remove_memory_blocks_and_altmaps(start, size);
 	}
 
-	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
-		memblock_phys_free(start, size);
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK))
 		memblock_remove(start, size);
-	}
 
 	release_mem_region_adjustable(start, size);
 
_

Patches currently in -mm which might be from Jonathan.Cameron@huawei.com are


