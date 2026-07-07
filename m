Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C070D375ADF
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443761; cv=none; b=hUyreeNBhlPREmOdqX0UmYi331YWJ3vmNFmHu9jMyMLJaBFbY8HAptYfPvwfLlGP2DHetz0qtAPVFtxewff0480H5sTFT3VYJnII1ys6MbARwzJlWbZyJm41JrQOgQIWi45MMIZcn4eFz935dQ1Xn6KxQnKIp7Vz6OPIMP7TIKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443761; c=relaxed/simple;
	bh=e0/5y4EAn+HduHK4YRyNP7R1CLc+Gvc1JVUg+nfFEJQ=;
	h=Date:To:From:Subject:Message-Id; b=jwo8enGuTvxvMr6NISI4JBsV5+yPiAhMmsM1RuCjwfmFM10Jag9e4HYHaZRIIIZX20a5YUbWFaBCkJbqnouuc+4twE0dZh/ja2mt5wq6fu8ZJgy8chajrzVkFFTWc9L7zXWiQn6cXluw5UwdCujlZIBplSdklXit+u6KTXnL7ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fc/Fk6rM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fc/Fk6rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320E81F000E9;
	Tue,  7 Jul 2026 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783443759;
	bh=eSzs4i8gciGDzk4UUYqL0C8aIe14tKgRMvbIJ5ZwwRg=;
	h=Date:To:From:Subject;
	b=Fc/Fk6rMrX/M6R9KVMRIb7LGmFZU1IiQINWwSgR3+q7M55bDtg4CzK6EsWfFDCdH9
	 P70308HaTDBPabuX4nwF40OKO+WkhC/Qo96/R+s/L2Td5dSSpuS9aVchRz6/SDSgtq
	 hw8ogt71IAKeMKUzC4QW1ugllldOOuaMR4SabjhQ=
Date: Tue, 07 Jul 2026 10:02:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,chengkaitao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch added to mm-new branch
Message-Id: <20260707170239.320E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kconfig: drop redundant memory hotplug dependencies
has been added to the -mm mm-new branch.  Its filename is
     mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch

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
Subject: mm/kconfig: drop redundant memory hotplug dependencies
Date: Tue, 7 Jul 2026 17:03:31 +0800

MHP_MEMMAP_ON_MEMORY is defined inside the MEMORY_HOTPLUG block, and
MEMORY_HOTPLUG already depends on SPARSEMEM_VMEMMAP.  Keep the explicit
MEMORY_HOTPLUG dependency for local readability, but drop the redundant
SPARSEMEM_VMEMMAP dependency.

ZONE_DEVICE depends on MEMORY_HOTREMOVE, which depends on MEMORY_HOTPLUG. 
MEMORY_HOTPLUG in turn depends on SPARSEMEM_VMEMMAP.  Drop the direct
MEMORY_HOTPLUG and SPARSEMEM_VMEMMAP dependencies from ZONE_DEVICE.

This does not change the set of valid configurations.

Link: https://lore.kernel.org/20260707090331.52971-1-kaitao.cheng@linux.dev
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/Kconfig~mm-kconfig-drop-redundant-memory-hotplug-dependencies
+++ a/mm/Kconfig
@@ -596,7 +596,7 @@ config MEMORY_HOTREMOVE
 
 config MHP_MEMMAP_ON_MEMORY
 	def_bool y
-	depends on MEMORY_HOTPLUG && SPARSEMEM_VMEMMAP
+	depends on MEMORY_HOTPLUG
 	depends on ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 
 endif # MEMORY_HOTPLUG
@@ -1235,9 +1235,7 @@ config ZONE_DMA32
 
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
-	depends on MEMORY_HOTPLUG
 	depends on MEMORY_HOTREMOVE
-	depends on SPARSEMEM_VMEMMAP
 	select XARRAY_MULTI
 
 	help
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-vmalloc-honor-gfp-constraints-in-pcpu_get_vm_areas.patch
mm-percpu-honor-gfp-constraints-when-populating-chunks.patch
mm-percpu-make-cached-pages-lookup-explicit.patch
mm-percpu-avoid-io-fs-reclaim-in-backing-allocations.patch
mm-kconfig-drop-redundant-memory-hotplug-dependencies.patch

