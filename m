Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207140F726
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525513; cv=none; b=f3McYYSSA2s+W0crJmHxcebwHaYobV4oDmB45jksbmIYVCnUPZ7/bcqQ4UcC3jhjl0Z3UqleSQLg8e9qdNZCPzV7UmVtrSnrEng1Kdu2Dco77IJk29o13Gwet9XXqxBbELQFPSOJFz83e8iW49X4sPuVzk95GAPxBOkMRHxwIYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525513; c=relaxed/simple;
	bh=wMiCsJwH7GxsTnLjns2cLbx6RUyvJB2wY4BtJRpzqMU=;
	h=Date:To:From:Subject:Message-Id; b=NEYP1LgfGkuWtSp7cePI1tufpUaj39JbWlQIMDPBvCOX5S8KNf+N9OM7HsYSRefqPR9phkBPjA+o4xPCHcWg19ClTggdKLIQh0nJtyyVMfTZiw0f1RiHibSQrc3U+o8Mb5fC/UBB6gtEeskF9ynqNXXAPAZNvflIQzdag8fA5Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=05uNNOug; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="05uNNOug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80C11F00893;
	Fri,  9 Oct 2026 05:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525512;
	bh=srWwYf5gWvSzsmJ9mGXtab2Cw0Gb3mTL1l5wkI5TsWA=;
	h=Date:To:From:Subject;
	b=05uNNOugtGqyod7II+zOu7VC5utLOUAEXfBNBtgHMpR+BvFlzZVSpz345g/YwXmIo
	 l2ExEsY5qyQCSKGGYeSa6/XbGB9x+ArsjVodnHNGXZOg3OoZu+LXa1EoTVPLZqlllv
	 YD8JMPOZDKfXfqq3bDaaEzhnCAuRykud0QrIu3es=
Date: Thu, 08 Oct 2026 22:58:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch removed from -mm tree
Message-Id: <20261009055832.B80C11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
has been removed from the -mm tree.  Its filename was
     maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add memory related docs in core-mm/ to MM - MISC section
Date: Wed, 02 Sep 2026 11:10:12 +0300

Previous efforts to make sure that mm files are properly listed in
MAINTAINERS missed

Documentation/core-api/mm-api.rst
Documentation/core-api/memory-allocation.rst

Add them to "MEMORY MANAGEMENT - MISC"

Link: https://lore.kernel.org/20260902-docs-memalloc-guide-v2-2-218c1a4dcb80@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section
+++ a/MAINTAINERS
@@ -17268,6 +17268,8 @@ F:	Documentation/ABI/testing/sysfs-kerne
 F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
+F:	Documentation/core-api/memory-allocation.rst
+F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
 F:	mm/char-mem.c
 F:	include/linux/cma.h
_

Patches currently in -mm which might be from rppt@kernel.org are

docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

