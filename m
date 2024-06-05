Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9E49629
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717625768; cv=none; b=j9l2m9YIjJc8gwaUyS4NO1tq1DcU+ULenRG9KaCElkaRuKJql20HkfXBaUeMDc2cL0Mdml2eQ55n4LMtz5bzxENnxrH1j1WoOKsyf9A5oXhSG4+nFzJpGFwvIUnsmRa9+skLpfUA/zjJgKpH2H20MQoYCf2Kr68D7r1LQlqZPV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717625768; c=relaxed/simple;
	bh=ZR9kMGBA1rzwGLASFvlT12elydhg/BdCsWMKTURafWk=;
	h=Date:To:From:Subject:Message-Id; b=SHK8z8kxEHnqVmluRsAlZH/IENcIEOhK6VORviWCWtV5RWBlv013HUILneWF21QycFq4V27Io0ZNI0r0BzDewIY9ukrnp1GGOjX4GnnK/QdP+1NEG+RnUxhES7Tt/2tWPlbnuA2/fkZf26y0jewq4zH+UsB4LpFGa2x3vyBsgBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KCO37sqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KCO37sqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CF8C2BD11;
	Wed,  5 Jun 2024 22:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717625768;
	bh=ZR9kMGBA1rzwGLASFvlT12elydhg/BdCsWMKTURafWk=;
	h=Date:To:From:Subject:From;
	b=KCO37sqCRF6Q2bVdCVwwDieqhrh1jU10Nzm8at27GNRYTqmUoEbfi3/hxav3yxARU
	 aPFHZOYzOzgYLlWfKVEjexoaxVjAzN+jqA89eo6zb4OmJqpO7GxFQfBoVrQ/Lha6mF
	 grxhChyVYsHMpGFk3Uo4wE2X74LFUxts6juB+aQY=
Date: Wed, 05 Jun 2024 15:16:07 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,david@redhat.com,Jonathan.Cameron@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch added to mm-unstable branch
Message-Id: <20240605221608.23CF8C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: drop memblock_phys_free() call in try_remove_memory()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch

This patch will later appear in the mm-unstable branch at
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
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-memory_hotplug-drop-memblock_phys_free-call-in-try_remove_memory.patch

