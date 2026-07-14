Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A02636164D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 02:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783994487; cv=none; b=eBLQoOKA1Dusklhhp9IXrLlNDMTFeWzDllsNZgm7D7/SBU6muslq5VqE6azbLg4oFqMqhJX9v/GGL1yY+ksUO+O1FeIM4hFQgkUrNoWgqjBiJiiXAHoit1O/Ioae2yn+wUoi4SLle5dgeaM+veL0Pb4+DwzwKoryapbryrhGCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783994487; c=relaxed/simple;
	bh=/9pXpPYWXEGUAWuCCTSVC4Hhsi6Nd04+FTDsvpNjgnU=;
	h=Date:To:From:Subject:Message-Id; b=GkFx8zTy6uVyUCG/L+HI/NaPGwTPs14q432t/auCvUuZjsglTNE4kzUVIG//GhZ6CHkKeOMCuXla7ppQjRUyQFpiOMrcP8n7BuiPs1dumWp65OiOyHLDFqsirvrbRirpBF8C0LleYxfwXwcHlua3LpKoYevRJ9pmtW/NsRbajYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N02SqVje; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N02SqVje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE51E1F000E9;
	Tue, 14 Jul 2026 02:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783994486;
	bh=Ot+N4uIbhmgkv4U8/ERFw7UO7Nvqj2ydcZiT1B5cZGs=;
	h=Date:To:From:Subject;
	b=N02SqVjeSdhf+Yzy+eI4DpaGv/hRj2I3pURax2I1gFqNwfwG0HEOEqDROitZMShSz
	 QvjaXwU4t0fkPaHdfpU28BtVigoaIvcUUObqwrsGCCRSMkCj8wEf0Boji7vX/DxThn
	 ZYW3eTyYccBBs0/NkWNsU1a6VXC3WZRDqS1HEKCM=
Date: Mon, 13 Jul 2026 19:01:25 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,julianbraha@gmail.com,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-drop-redundant-dependency-wrappers.patch added to mm-new branch
Message-Id: <20260714020125.EE51E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kconfig: drop redundant dependency wrappers
has been added to the -mm mm-new branch.  Its filename is
     mm-kconfig-drop-redundant-dependency-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-drop-redundant-dependency-wrappers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
@@ -1392,17 +1386,15 @@ menuconfig USERFAULTFD
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

mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch
mm-percpu-honor-gfp-constraints-when-populating-chunks.patch
mm-percpu-make-cached-pages-lookup-explicit.patch
mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch
mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch
mm-kconfig-drop-redundant-dependency-wrappers.patch

