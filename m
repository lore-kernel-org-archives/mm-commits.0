Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478E532AACB
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622263; cv=none; b=AK8NLZobK4YhxRw3I4gZmkwWUZv2KvZE6lukS44A5mcURYGBilRF319Q46yOOUek1VklAGO/YhzgRZzXWEs2uxOruXP3bBPc+CoetfoLR8vHjwsdqd3xTJy7jM//cA9596P2PWVAujQgkpeLXT82k+gZfYrx1yVI366BM76pq9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622263; c=relaxed/simple;
	bh=joxC3ZhCI0CD5v1uEQUA/aZTRIGlo5Qri/sYN28+odA=;
	h=Date:To:From:Subject:Message-Id; b=LG9zl7Cvefu81gZhzQ6Irux+LStAJnA9iBcvm2xkSpCFOrdhPpcXjkIz9DOg9ogWcG3BslGK5lr0Yh7SPB+Wr8MN1loIMR3fiBE5g+ns9NHqBMGFIkkOeRHaZQAQOeJtRXyXLM8pTTAjBRK24EcDgJ8Qn0Tx3ut5iFpwp5XtMUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r0snHJDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r0snHJDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD601F00A3A;
	Tue, 25 Aug 2026 01:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622262;
	bh=Duzwgs9df8p5iz5eFWtHOIDnu03pe+W6sHPZO3Gkp5E=;
	h=Date:To:From:Subject;
	b=r0snHJDhOa/mbIO21rjcvCCzqZhAwTAppq6Kgoc74+2LPrMf6KDiVcNd7qeQ49Wex
	 IOnZBZ4eczIZsDzpQ+G7YGNp3IUaKQkSOY7lMTn7GZaV3oeojsAOguN0FvzHVjqZbZ
	 ENeUc/1UScV1zwfqCYLkTmcMipO28DmhVYw7S0dQ=
Date: Mon, 24 Aug 2026 18:44:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,julianbraha@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kconfig-drop-redundant-dependency-wrappers.patch removed from -mm tree
Message-Id: <20260825014422.1CD601F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kconfig: drop redundant dependency wrappers
has been removed from the -mm tree.  Its filename was
     mm-kconfig-drop-redundant-dependency-wrappers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/kconfig: drop redundant dependency wrappers
Date: Sun, 12 Jul 2026 17:33:26 +0800

Some mm Kconfig entries repeat dependencies that are already expressed by
their surrounding blocks or menus.

The zsmalloc allocator options menu already depends on ZSMALLOC, so the
outer if ZSMALLOC block does not add any extra constraint. 
MEMORY_HOTREMOVE and MHP_MEMMAP_ON_MEMORY are both inside the if
MEMORY_HOTPLUG block, so their local depends on MEMORY_HOTPLUG entries are
redundant.

PTE_MARKER_UFFD_WP is the only entry under if USERFAULTFD.  Move the
USERFAULTFD dependency into the symbol itself and combine it with the
architecture support dependency.

This keeps the same visibility and defaults while avoiding duplicate
dependency expressions.

Link: https://lore.kernel.org/20260712093326.8313-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Suggested-by: Julian Braha <julianbraha@gmail.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/mm/Kconfig~mm-kconfig-drop-redundant-dependency-wrappers
+++ a/mm/Kconfig
@@ -125,8 +125,6 @@ config ZSWAP_COMPRESSOR_DEFAULT
 config ZSMALLOC
 	tristate
 
-if ZSMALLOC
-
 menu "Zsmalloc allocator options"
 	depends on ZSMALLOC
 
@@ -161,8 +159,6 @@ config ZSMALLOC_CHAIN_SIZE
 
 endmenu
 
-endif
-
 menu "Slab allocator options"
 
 config SLUB
@@ -583,12 +579,10 @@ endchoice
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	depends on MEMORY_HOTPLUG
 	select MIGRATION
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
-	depends on MEMORY_HOTPLUG
 	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 
 endif # MEMORY_HOTPLUG
@@ -1393,17 +1387,15 @@ menuconfig USERFAULTFD
 	  Enable the userfaultfd() system call that allows to intercept and
 	  handle page faults in userland.
 
-if USERFAULTFD
 config PTE_MARKER_UFFD_WP
 	bool "Userfaultfd write protection support for shmem/hugetlbfs"
 	default y
-	depends on HAVE_ARCH_USERFAULTFD_WP
+	depends on USERFAULTFD && HAVE_ARCH_USERFAULTFD_WP
 
 	help
 	  Allows to create marker PTEs for userfaultfd write protection
 	  purposes.  It is required to enable userfaultfd write protection on
 	  file-backed memory types like shmem and hugetlbfs.
-endif # USERFAULTFD
 
 # multi-gen LRU {
 config LRU_GEN
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are


