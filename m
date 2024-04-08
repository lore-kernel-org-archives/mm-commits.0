Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E245BAF0
	for <mm-commits@vger.kernel.org>; Mon,  8 Apr 2024 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712598367; cv=none; b=SUgd2MO20LKG88dajWL5tlB6gxiZOPP/vxZCoO/AIiWc8cTkiR8eFAcKChv97dWg7XgWdgWQyTFAdTSHo7tdcj+mu9zay2WJSLSS/HmPHtU6rqMWRZQQosBRlzK00jfsuV87ZIq/d9ds2TlV/JBoh+esHeSdnDJiUpBcxPbBul0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712598367; c=relaxed/simple;
	bh=mMRDfeNNj9NQmuSYVZiS+0Drrns6M8MaA7NFV+lrHMM=;
	h=Date:To:From:Subject:Message-Id; b=TO62/o3VT77xNJXL6o/1HmII1+Ig3Zd5YVOxRwel9H165ZheOsBIPMNJq6Gd2qYZr0wxqNmYXUQCAMEkrkC1Gfzomerqw+Op7b0f77xsC7ORDbSgylZb7cbQwkRI76ttlPCWIdL8zHz6+3R/XMXuB7QsNXPzGn0l3XBkNynuu5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OhR+yPku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OhR+yPku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA02C433C7;
	Mon,  8 Apr 2024 17:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712598366;
	bh=mMRDfeNNj9NQmuSYVZiS+0Drrns6M8MaA7NFV+lrHMM=;
	h=Date:To:From:Subject:From;
	b=OhR+yPkuLbvzQdCPrvFcLCu0Nn7tCSsnUIGGCTOWMuoqp/hnxUZBONwMI9DC9RP4K
	 dzqrVW8H9pRUcbs8T5S4IPuaf9fzgoOt8tk0H/RC2SUuZBpp657BgBNyJdyEaTrWJ/
	 ILb9sXUM6J/qlaw8xM0MGcJ1CKVdUeS+LKXvYB/o=
Date: Mon, 08 Apr 2024 10:46:05 -0700
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-missing-vmalloch-includes-fix-6.patch added to mm-unstable branch
Message-Id: <20240408174606.6BA02C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been added to the -mm mm-unstable branch.  Its filename is
     fix-missing-vmalloch-includes-fix-6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-missing-vmalloch-includes-fix-6.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: fixup! fix missing vmalloc.h includes
Date: Fri, 5 Apr 2024 15:51:15 -0700

fix arc build

Link: https://lkml.kernel.org/r/20240405225115.431056-1-surenb@google.com
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404050828.5pKgmCLu-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kernel test robot <lkp@intel.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/mmu-arcv2.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arc/include/asm/mmu-arcv2.h~fix-missing-vmalloch-includes-fix-6
+++ a/arch/arc/include/asm/mmu-arcv2.h
@@ -9,6 +9,8 @@
 #ifndef _ASM_ARC_MMU_ARCV2_H
 #define _ASM_ARC_MMU_ARCV2_H
 
+#include <soc/arc/aux.h>
+
 /*
  * TLB Management regs
  */
_

Patches currently in -mm which might be from surenb@google.com are

fix-missing-vmalloch-includes-fix-2.patch
fix-missing-vmalloch-includes-fix-6.patch
mm-introduce-slabobj_ext-to-support-slab-object-extensions.patch
mm-introduce-__gfp_no_obj_ext-flag-to-selectively-prevent-slabobj_ext-creation.patch
mm-slab-introduce-slab_no_obj_ext-to-avoid-obj_ext-creation.patch
slab-objext-introduce-objext_flags-as-extension-to-page_memcg_data_flags.patch
lib-code-tagging-framework.patch
lib-code-tagging-module-support.patch
lib-prevent-module-unloading-if-memory-is-not-freed.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix.patch
lib-add-allocation-tagging-support-for-memory-allocation-profiling-fix-2.patch
lib-introduce-support-for-page-allocation-tagging.patch
lib-introduce-early-boot-parameter-to-avoid-page_ext-memory-overhead.patch
mm-percpu-increase-percpu_module_reserve-to-accommodate-allocation-tags.patch
change-alloc_pages-name-in-dma_map_ops-to-avoid-name-conflicts.patch
mm-enable-page-allocation-tagging.patch
mm-enable-page-allocation-tagging-fix.patch
mm-create-new-codetag-references-during-page-splitting.patch
mm-fix-non-compound-multi-order-memory-accounting-in-__free_pages.patch
mm-page_ext-enable-early_page_ext-when-config_mem_alloc_profiling_debug=y.patch
lib-add-codetag-reference-into-slabobj_ext.patch
mm-slab-add-allocation-accounting-into-slab-allocation-and-free-paths.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends.patch
mm-slab-enable-slab-allocation-tagging-for-kmalloc-and-friends-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix.patch
mempool-hook-up-to-memory-allocation-profiling-fix-2.patch
mm-percpu-enable-per-cpu-allocation-tagging.patch
mm-percpu-enable-per-cpu-allocation-tagging-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix.patch
mm-vmalloc-enable-memory-allocation-profiling-fix-2.patch
rhashtable-plumb-through-alloc-tag-fix.patch
lib-add-memory-allocations-report-in-show_mem.patch
codetag-debug-skip-objext-checking-when-its-for-objext-itself.patch
codetag-debug-mark-codetags-for-reserved-pages-as-empty.patch
codetag-debug-introduce-objexts_alloc_fail-to-mark-failed-slab_ext-allocations.patch

